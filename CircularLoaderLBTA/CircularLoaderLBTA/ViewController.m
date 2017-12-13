//
//  ViewController.m
//  CircularLoaderLBTA
//
//  Created by Ihar Tsimafeichyk on 12/12/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UILabel *percentageLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];

    UIBezierPath *circuitPath = [UIBezierPath
                                 bezierPathWithArcCenter:CGPointZero
                                 radius:100 startAngle:0
                                 endAngle:2 * M_PI clockwise:YES];

    CAShapeLayer *trackLayer = [[CAShapeLayer alloc] init];
    trackLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    trackLayer.path = circuitPath.CGPath;
    trackLayer.lineWidth = 10;
    trackLayer.fillColor = [[UIColor clearColor] CGColor];
    trackLayer.position = self.view.center;
    [self.view.layer addSublayer:trackLayer];

    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.path = circuitPath.CGPath;
    self.shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    self.shapeLayer.lineWidth = 10;
    self.shapeLayer.strokeEnd = 0;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.position =self.view.center;
    self.shapeLayer.transform = CATransform3DMakeRotation(-M_PI/2, 0, 0, 1);
    [self.view.layer addSublayer:self.shapeLayer];

    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGesture];

    [self updateLabel];
}

#pragma mark - Private methods

- (void) updateLabel {
    self.percentageLabel = [[UILabel alloc] init];
    [self.percentageLabel setText:@"Start"];
    [self.percentageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.percentageLabel setFont:[UIFont boldSystemFontOfSize:32.0]];
    [self.percentageLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.percentageLabel];
    [self.percentageLabel setFrame:CGRectMake(0, 0, 100, 100)];
    [self.percentageLabel setCenter:self.view.center];
}

- (void) handleTap {
    NSLog(@"%@", @"TapHandler");

    [self beginDownloadingFile];
    //[self animateCircle];
}

- (void) animateCircle {
    NSLog(@"%@", @"Animation started");
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    basicAnimation.duration = 2.0;
    basicAnimation.fillMode = kCAFillModeForwards;
    [basicAnimation setRemovedOnCompletion:NO];

    [self.shapeLayer addAnimation:basicAnimation forKey:@"urSoBasic"];
}

- (void) beginDownloadingFile {
    NSLog(@"%@", @"File downloading begins");
    
    self.shapeLayer.strokeEnd = 0;

    //NSString *urlString = @"https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c";

    NSString *urlString = @"https://static.pexels.com/photos/698865/pexels-photo-698865.jpeg";

    NSURLSessionConfiguration *sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration;
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:operationQueue];

    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLSessionDownloadTask *downloadTask = [urlSession downloadTaskWithURL:url];
    [downloadTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSLog(@"%@", @"File downloading end");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    CGFloat precentage = (CGFloat)totalBytesWritten / (CGFloat) totalBytesExpectedToWrite;
    NSLog(@"%f", precentage);

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_percentageLabel) {
            [_percentageLabel setText: [NSString stringWithFormat:@"%i%%", (int)(precentage * 100)]];
        }
        self.shapeLayer.strokeEnd = precentage;
    });
}


@end
