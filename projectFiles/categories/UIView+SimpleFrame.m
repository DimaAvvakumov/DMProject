//
//  UIView+SimpleFrame.m
//  DMProject
//
//  Created by Dima Avvakumov on 17.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "UIView+SimpleFrame.h"

@implementation UIView (SimpleFrame)

- (void) setFrameSize: (CGSize) size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void) setFrameSizeWidth: (float) width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void) setFrameSizeHeight: (float) height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void) setFrameOrigin: (CGPoint) origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void) setFrameOriginX: (float) x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void) setFrameOriginY: (float) y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void) setCenterX: (float) x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void) setCenterY: (float) y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

@end
