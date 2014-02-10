//
//  DMArrayDifference.m
//  igazeta
//
//  Created by Dima Avvakumov on 13.01.14.
//  Copyright (c) 2014 East-media. All rights reserved.
//

#import "DMArrayDifference.h"

@interface DMArrayDifference()

@property (strong, nonatomic) NSArray *prevArray;
@property (strong, nonatomic) NSArray *nextArray;

@property (strong, nonatomic) NSArray *reloadArray;
@property (strong, nonatomic) NSArray *insertArray;
@property (strong, nonatomic) NSArray *deleteArray;

@property (strong, nonatomic) NSArray *indexPathsForReload;
@property (strong, nonatomic) NSArray *indexPathsForDelete;
@property (strong, nonatomic) NSArray *indexPathsForInsert;

@end

@implementation DMArrayDifference

- (id)initWithArray: (NSArray *) prevArray andArray: (NSArray *) nextArray {
    self = [super init];
    if (self) {
        self.prevArray = prevArray;
        self.nextArray = nextArray;
        
        self.reloadArray = nil;
        self.insertArray = nil;
        self.deleteArray = nil;
        
        self.indexPathsForReload = nil;
        self.indexPathsForDelete = nil;
        self.indexPathsForInsert = nil;
        
        self.section = 0;
        self.rowOffset = 0;
        
        [self parse];
    }
    return self;
}

- (void) parse {
    NSInteger countSrc = [_prevArray count];
    NSInteger countDesc = [_nextArray count];
    NSInteger countMax = MAX(countSrc, countDesc);
    
    NSMutableArray* diffArr = [NSMutableArray arrayWithCapacity: countMax];
    NSMutableArray* newArr = [NSMutableArray arrayWithCapacity: countMax];
    NSMutableArray* delArr = [NSMutableArray arrayWithCapacity: countMax];
    
    for (int i = 0; i < countMax; i++) {
        NSString *prevObject = nil;
        NSString *nextObject = nil;
        
        if (i < countSrc) prevObject = [_prevArray objectAtIndex: i];
        if (i < countDesc) nextObject = [_nextArray objectAtIndex: i];
        
        // not changed
        if (prevObject && nextObject && [prevObject isEqualToString: nextObject]) continue;
        
        if (prevObject && nextObject) {
            [diffArr addObject: [NSNumber numberWithInteger: i]];
        } else {
            if (prevObject) {
                [delArr addObject: [NSNumber numberWithInteger: i]];
            } else  {
                [newArr addObject: [NSNumber numberWithInteger: i]];
            }
        }
    }
    
    if ([diffArr count] > 0) self.reloadArray = diffArr;
    if ([newArr count] > 0) self.insertArray = newArr;
    if ([delArr count] > 0) self.deleteArray = delArr;
}

- (NSArray *) indexPathsForReload {
    if (_indexPathsForReload) return _indexPathsForReload;
    
    if (_reloadArray == nil) return nil;
    
    NSArray *indexPaths = [self indexPathsByArray: _reloadArray];
    self.indexPathsForReload = indexPaths;
    
    return _indexPathsForReload;
}

- (NSArray *) indexPathsForInsert {
    if (_indexPathsForInsert) return _indexPathsForInsert;
    
    if (_insertArray == nil) return nil;
    
    NSArray *indexPaths = [self indexPathsByArray: _insertArray];
    self.indexPathsForInsert = indexPaths;
    
    return _indexPathsForInsert;
}

- (NSArray *) indexPathsForDelete {
    if (_indexPathsForDelete) return _indexPathsForDelete;
    
    if (_deleteArray == nil) return nil;
    
    NSArray *indexPaths = [self indexPathsByArray: _deleteArray];
    self.indexPathsForDelete = indexPaths;
    
    return _indexPathsForDelete;
}

- (NSArray *) indexPathsByArray: (NSArray *) arrayNumbers {
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity: [arrayNumbers count]];
    for (NSNumber *index in arrayNumbers) {
        NSInteger row = [index integerValue] + _rowOffset;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection:_section];
        
        [indexPaths addObject:indexPath];
    }
    
    return indexPaths;
}

- (BOOL) changesExists {
    return (_reloadArray || _insertArray || _deleteArray) ? YES : NO;
}

@end
