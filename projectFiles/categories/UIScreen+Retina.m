//
//  UIScreen+Retina.m
//  DMProject
//
//  Created by Maxim Keegan on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIScreen+Retina.h"

@implementation UIScreen (Retina)

+ (BOOL) isRetina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
        return YES;
    }
    return NO;
}


@end
