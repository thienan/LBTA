//
//  ViewController.swift
//  audiable
//
//  Created by Ihar Tsimafeichyk on 2/19/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit



protocol LogginControllerDelegate: class // break retain cycle 
{
    func finishLoggingIn ()
}

class LoginViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LogginControllerDelegate {
    
    let cellId = "cellId"
    let loginId = "liginId"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(PageCell.self, forCellWithReuseIdentifier: self.cellId)
        cv.register(LoginCell.self, forCellWithReuseIdentifier: self.loginId)
        cv.isPagingEnabled = true
        return cv
    } ()

    
    lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.numberOfPages = self.pages.count + 1
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        return pc
    }()
    
    let pages : [PageModel] = {
        let firstPage = PageModel(title: "Share a great listen", message: "It's free to send your books to the people in your life. Every recipient's first book is on us.", image: "page1")
        let secondPage = PageModel(title: "Send from your library", message: "Tap the More menu next to any book. Choose \"Send this Book\"", image: "page2")
        let thirdPage = PageModel(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", image: "page3")
        return [firstPage, secondPage, thirdPage]
        
    }()
    
    let skipButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skipButtonHandler), for: .touchUpInside)
        return button
    }()
    
    func skipButtonHandler () {
        let indexPath = IndexPath(item: pages.count, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = pages.count
        moveControlConstrainOfTheScreen()
    }
    
    let nextButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextButtonHandler), for: .touchUpInside)
        return button
    }()
    
    func nextButtonHandler() {
        if pageControl.currentPage == pages.count {
            return
        }
        
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstrainOfTheScreen()
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1

    }
    
    var pageControlBottomAncor: NSLayoutConstraint?
    var topAncorSkipButton: NSLayoutConstraint?
    var topAncorNextButton: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observKeybordNotifications()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControlBottomAncor = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        pageControlBottomAncor?.isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        skipButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topAncorSkipButton = skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        topAncorSkipButton?.isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAncorNextButton = nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        topAncorNextButton?.isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

    fileprivate func observKeybordNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keybordHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
    }
    
    var keybordFixedSize : CGFloat?
    
    func keyboardShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: {
            if let keybordFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                self.view.frame.origin.y = 0
                
                if  self.keybordFixedSize == nil {
                    self.keybordFixedSize = keybordFrame.size.height
                }
                
                let devider: CGFloat = UIDevice.current.orientation.isLandscape ?  5 :  2.2
                self.view.frame.origin.y -= (self.keybordFixedSize! / devider)
            }
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
            cell.pageContent = pages[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
 
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == pages.count {
            moveControlConstrainOfTheScreen()

        } else {
            moveControlConstrainToTheScreen()
        }

    }
    
    fileprivate func moveControlConstrainToTheScreen () {
        topAncorNextButton?.constant = 8
        topAncorSkipButton?.constant = 8
        pageControlBottomAncor?.constant = 0
        
        animateMoveControl()
    }
    
    fileprivate func moveControlConstrainOfTheScreen () {
        topAncorNextButton?.constant = -68
        topAncorSkipButton?.constant = -68
        pageControlBottomAncor?.constant = 40
        
        animateMoveControl()
    }
    
    fileprivate func animateMoveControl() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // remove keyboard if present while swipe
        view.endEditing(true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // handler for landscape mode
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        
        // scroll to index after the rotation is going
        DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
        
        
    }
    
    func finishLoggingIn () {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        guard let mainNavController = rootViewController as? MainNavigationViewController else {
            return
        }
        
        mainNavController.viewControllers = [HomeController()]
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        
        dismiss(animated: true, completion: nil)
    
    }
}








