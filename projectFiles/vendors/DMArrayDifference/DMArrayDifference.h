//
//  DMArrayDifference.h
//  igazeta
//
//  Created by Dima Avvakumov on 13.01.14.
//  Copyright (c) 2014 East-media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMArrayDifference : NSObject

@property (assign, nonatomic) NSInteger rowOffset;
@property (assign, nonatomic) NSInteger section;

- (id)initWithArray: (NSArray *) prevArray andArray: (NSArray *) nextArray;

- (NSArray *) indexPathsForReload;
- (NSArray *) indexPathsForInsert;
- (NSArray *) indexPathsForDelete;

- (BOOL) changesExists;

@end
