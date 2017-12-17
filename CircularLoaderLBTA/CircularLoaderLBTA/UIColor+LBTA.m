//
//  UIColor+LBTA.m
//  CircularLoaderLBTA
//
//  Created by Ihar Tsimafeichyk on 14/12/2017.
//  Copyright © 2017 Home. All rights reserved.
//

#import "UIColor+LBTA.h"

@implementation UIColor (LBTA)

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:21.0f/255.0f green:22.0f/255.0f blue:33.0f/255.0f alpha:1];
}

+ (UIColor *)outlineStrokeColor {
    return [UIColor colorWithRed:234.0f/255.0f green:46.0f/255.0f blue:111.0f/255.0f alpha:1];
}

+ (UIColor *)trackStrokeColor {
    return [UIColor colorWithRed:56.0f/255.0f green:25.0f/255.0f blue:49.0f/255.0f alpha:1];
}

+ (UIColor *)pulsatingFillColor {
    return [UIColor colorWithRed:86.0f/255.0f green:30.0f/255.0f blue:63.0f/255.0f alpha:1];
}


@end
