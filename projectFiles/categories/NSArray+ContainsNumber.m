//
//  NSArray+ContainsNumber.m
//  DMProject
//
//  Created by Dima Avvakumov on 13.01.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "NSArray+ContainsNumber.h"

@implementation NSArray (ContainsNumber)

- (NSUInteger) indexOfNumber:(NSNumber *)number {
    NSUInteger index = 0;
    for (NSNumber *item in self) {
        if ([item isKindOfClass: [NSNumber class]]) {
            if ([item isEqualToNumber: number]) {
                return index;
            }
        }
        index++;
    }
    return NSNotFound;
}

- (NSUInteger) indexOfInteger:(NSInteger)value {
    NSUInteger index = 0;
    for (NSNumber *item in self) {
        if ([item isKindOfClass: [NSNumber class]]) {
            if ([item integerValue] == value) {
                return index;
            }
        }
        index++;
    }
    return NSNotFound;
}

@end
