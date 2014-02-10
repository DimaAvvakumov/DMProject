//
//  UIDevice+Idiom.m
//  DPS
//
//  Created by Maxim Keegan on 04.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIDevice+Idiom.h"

@implementation UIDevice (Idiom)

- (BOOL) isPhone {
    UIUserInterfaceIdiom ideom = [[UIDevice currentDevice] userInterfaceIdiom];
    return (ideom == UIUserInterfaceIdiomPhone);
}

- (BOOL) isIphone5 {
    if([[UIScreen mainScreen] bounds].size.height == 568.0)
    {
        return YES;
    }
    return NO;
}

- (BOOL) isPad {
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    return (idiom == UIUserInterfaceIdiomPad);
}

- (NSString *) family {
    if ([self isPad]) {
        return @"iPad";
    } else {
        if ([self isIphone5]) {
            return @"iPhone5";
        }
        return @"iPhone";
    }
}

- (CGSize) screenSizeForOrientation: (UIInterfaceOrientation) orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if ([self isPad]) {
            return CGSizeMake(1024.0, 768.0);
        } else {
            if ([self isIphone5]) {
                return CGSizeMake(568.0, 320.0);
            } else {
                return CGSizeMake(480.0, 320.0);
            }
        }
    } else {
        if ([self isPad]) {
            return CGSizeMake(768.0, 1024.0);
        } else {
            if ([self isIphone5]) {
                return CGSizeMake(320.0, 568.0);
            } else {
                return CGSizeMake(320.0, 480.0);
            }
        }
    }
}

- (NSInteger) primarySystemVersion {
    static NSInteger version = 0;
    if (version == 0) {
        NSString *v = [[UIDevice currentDevice] systemVersion];
        version = [v integerValue];
    }
    return version;
}

- (NSInteger) secondarySystemVersion {
    static NSInteger version = -1;
    if (version == -1) {
        NSString *v = [[UIDevice currentDevice] systemVersion];
        
        NSArray *pieses = [v componentsSeparatedByString:@"."];
        if ([pieses count] > 1) {
            version = [[pieses objectAtIndex:1] integerValue];
        } else {
            version = 0;
        }
    }
    return version;
}


@end
