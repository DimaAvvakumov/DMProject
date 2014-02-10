//
//  NSArray+ContainsNumber.h
//  DMProject
//
//  Created by Dima Avvakumov on 13.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ContainsNumber)

- (NSUInteger) indexOfNumber:(NSNumber *)number;
- (NSUInteger) indexOfInteger:(NSInteger)value;

@end
