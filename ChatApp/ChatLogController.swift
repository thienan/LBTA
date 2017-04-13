//
//  ChatLogController.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 4/2/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellId = "cellId"
    var bottomAnchorContainerView: NSLayoutConstraint?
    var messages = [Message]()
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observMessages()
        }
    }
    
    override var inputAccessoryView: UIView? {
        get{
            return inputContainerView
        }
    }
    
    // make the inputAccessoryView visible
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgbColor(red: 220, green: 220, blue: 220, alpha: 1)
        return view
    }()
    
    lazy var textInputField: UITextField = {
        let view = UITextField()
        view.placeholder = "Type text message here.."
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sent"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var sendImageView: UIImageView = {
        let image = UIImage(named: "upload_image_icon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleSendImage))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    func observMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id  else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scrol to the las index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)

                })
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func handleSendImage() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            // selected video workflow
            handleVideoSelectedForUrl(fileUrl: videoUrl)
        } else {
            // selected image workflow
            handleImageSelectedForUrl(info: info)
        }
        
        dismiss(animated: true, completion: nil)
            
    }
    
    private func handleVideoSelectedForUrl (fileUrl: URL) {
        let fileName = NSUUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(fileName).putFile(fileUrl, metadata: nil, completion: { (metdata, error) in
            if error != nil {
                print("File upload failure:", error!)
                return
            }
            if let videoUrl = metdata?.downloadURL()?.absoluteString {
                
                guard let thumbnailImage = self.thumbnailImageForVideoUrl (url: fileUrl) else { return }
                
                self.uploadToFirebaseUsingSelectedImage(image: thumbnailImage, completion: { (imageUrl) in
                    let properties: [String: Any] = ["imageUrl": imageUrl,
                                                     "imageWidth": thumbnailImage.size.width,
                                                     "imageHeight": thumbnailImage.size.height,
                                                     "videoUrl": videoUrl]
                    
                    self.sendMessageWithProperties(properties: properties)
                })
                
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
        
    }
    
    private func thumbnailImageForVideoUrl(url: URL) -> UIImage? {
        let assert = AVAsset(url: url)
        let assetGenerator = AVAssetImageGenerator(asset: assert)
        
        do {
            let thumbnailImage = try assetGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)

            return UIImage(cgImage: thumbnailImage)

        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    private func handleImageSelectedForUrl(info: [String: Any]) {
        var selectedInageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedInageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedInageFromPicker = originalImage
        }
        
        if let selectedImage = selectedInageFromPicker {
            uploadToFirebaseUsingSelectedImage(image: selectedImage, completion: {
                (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseUsingSelectedImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = NSUUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metdata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let imageUrl = metdata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
            })
        }
    }

    private func sendMessageWithImageUrl (imageUrl: String, image: UIImage) {
        let properties: [String: Any] = ["imageUrl": imageUrl,
                                              "imageWidth": image.size.width,
                                              "imageHeight": image.size.height]
        sendMessageWithProperties(properties: properties)
    }

    func handleSend() {
        guard let text = textInputField.text , !text.isEmpty else { return }
        let properties : [String : Any] = ["text": text]
        sendMessageWithProperties(properties: properties)
    }

    private func sendMessageWithProperties(properties: [String: Any]) {
        let ref = FIRDatabase.database().reference().child("messages")
        let toId = user!.id!
        let childRef = ref.childByAutoId()
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970
        let messageId = childRef.key
        
        var values: [String: Any] = ["toId" : toId,"fromId": fromId, "timestamp": timestamp, "messageId" : messageId]
        properties.forEach { values[$0] = $1 }
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.textInputField.text = nil
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientMessageRef.updateChildValues([messageId: 1])
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        textInputField.resignFirstResponder()
        return true
    }
    
    // MARK: - Layout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        // allows to slide down the keyboard.
        collectionView?.keyboardDismissMode = .interactive
        
        setupKeyboardObservers()

    }
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = .white
        
        containerView.addSubview(self.separatorLine)
        
        self.separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        self.separatorLine.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        self.separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        containerView.addSubview(self.sendButton)
        self.sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        self.sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(self.sendImageView)
        self.sendImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        self.sendImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.sendImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.sendImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        containerView.addSubview(self.textInputField)
        self.textInputField.leftAnchor.constraint(equalTo: self.sendImageView.rightAnchor, constant: 8).isActive = true
        self.textInputField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.textInputField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.textInputField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
    
        return containerView

    }()
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        cell.messageImageView.image = nil
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        cell.message = message
        
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
            cell.playButton.isHidden =  message.videoUrl != nil ? false : true
        
        return cell
    }
    
    private func setupCell (cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profieImage {
            cell.profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        

        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            cell.bubleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.bubbleRightAnchor?.isActive = true
        } else {
            cell.bubleView.backgroundColor = ChatMessageCell.grayColor
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.bubleView.backgroundColor = .clear
            cell.messageImageView.loadImagesUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
        } else {
            cell.messageImageView.isHidden = true
        }
        
    }
    
    // portrait and ladscape support.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let messageText = messages[indexPath.item].text {
            height = estimatedFrameForText(text: messageText).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHight = message.imageHeight?.floatValue {
            
            height = CGFloat(imageHight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    func performZoomInUiImageView (startingImageView: UIImageView) {
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
        }
        

    }
    
    func handelZoomOut (tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })

        }
    }
}
