//
//  NSDictionary+SimpleGetters.h
//  DMProject
//
//  Created by Dima Avvakumov on 20.12.12.
//  Copyright (c) 2012 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SimpleGetters)

- (NSString *) stringForKey: (id) key;
- (NSString *) stringForKeyOrNil: (id) key;
- (NSNumber *) numberForKey: (id) key;
- (BOOL) boolForKey: (id) key;
- (CGRect) rectForKey: (id) key;
- (CGPoint) pointForKey: (id) key;
- (CGSize) sizeForKey: (id) key;
- (NSRange) rangeForKey: (id) key;
- (UIColor *) colorForKey: (id) key;

@end
