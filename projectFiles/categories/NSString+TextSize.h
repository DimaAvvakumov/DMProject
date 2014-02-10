//
//  NSString+TextSize.h
//  DMProject
//
//  Created by Dima Avvakumov on 24.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TextSize)

- (CGSize) textSizeWithFont: (UIFont *) font andMaxWidth: (float) maxWidth;

@end
