//
//  UIDevice+Idiom.h
//  DPS
//
//  Created by Maxim Keegan on 04.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Idiom)

- (BOOL) isPhone;
- (BOOL) isPad;
- (BOOL) isIphone5;
- (NSString *) family;

- (CGSize) screenSizeForOrientation: (UIInterfaceOrientation) orientation;

- (NSInteger) primarySystemVersion;
- (NSInteger) secondarySystemVersion;

@end
