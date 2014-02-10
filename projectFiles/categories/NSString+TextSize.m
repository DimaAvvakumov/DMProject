//
//  NSString+TextSize.m
//  DMProject
//
//  Created by Dima Avvakumov on 24.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)

- (CGSize) textSizeWithFont: (UIFont *) font andMaxWidth: (float) maxWidth {
    static NSInteger version = 0;
    if (version == 0) {
        NSString *v = [[UIDevice currentDevice] systemVersion];
        version = [v integerValue];
    }
    
    if (version < 7) {
        CGSize sizeMax = CGSizeMake(maxWidth, CGFLOAT_MAX);
        CGSize size = [self sizeWithFont:font constrainedToSize:sizeMax lineBreakMode:NSLineBreakByWordWrapping];
        
        return size;
    } else {
        NSDictionary *attr = @{NSFontAttributeName: font};
        
        CGSize sizeMax = CGSizeMake(maxWidth, CGFLOAT_MAX);
        CGRect rect = [self boundingRectWithSize:sizeMax options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
        
        return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    }
}

@end
