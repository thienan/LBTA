//
//  ViewController.m
//  CircularLoaderLBTA
//
//  Created by Ihar Tsimafeichyk on 12/12/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGPoint center = self.view.center;
    UIBezierPath *circuitPath = [UIBezierPath bezierPathWithArcCenter:center radius:100 startAngle:-M_PI/2 endAngle:2 * M_PI clockwise:YES];

    CAShapeLayer *trackLayer = [[CAShapeLayer alloc] init];
    trackLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    trackLayer.path = circuitPath.CGPath;
    trackLayer.lineWidth = 10;
    trackLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:trackLayer];
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.path = circuitPath.CGPath;
    self.shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    self.shapeLayer.lineWidth = 10;
    self.shapeLayer.strokeEnd = 0;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:self.shapeLayer];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGesture];

}

- (void) handleTap {
    NSLog(@"%@", @"TapHandle");

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    basicAnimation.duration = 2.0;
    basicAnimation.fillMode = kCAFillModeForwards;
    [basicAnimation setRemovedOnCompletion:NO];

    [self.shapeLayer addAnimation:basicAnimation forKey:@"urSoBasic"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
