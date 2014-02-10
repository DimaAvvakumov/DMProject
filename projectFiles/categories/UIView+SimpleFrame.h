//
//  UIView+SimpleFrame.h
//  DMProject
//
//  Created by Dima Avvakumov on 17.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SimpleFrame)

- (void) setFrameSize: (CGSize) size;
- (void) setFrameSizeWidth: (float) width;
- (void) setFrameSizeHeight: (float) height;
- (void) setFrameOrigin: (CGPoint) origin;
- (void) setFrameOriginX: (float) x;
- (void) setFrameOriginY: (float) y;

- (void) setCenterX: (float) x;
- (void) setCenterY: (float) y;

@end
