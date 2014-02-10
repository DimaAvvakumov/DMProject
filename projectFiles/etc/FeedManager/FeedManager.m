//
//  FeedManager.m
//  igazeta
//
//  Created by Dima Avvakumov on 31.12.13.
//  Copyright (c) 2013 East-media. All rights reserved.
//

#import "FeedManager.h"

@interface FeedManager() {
    NSInteger _currentIndex;
}

@property (strong, nonatomic) NSArray *storeFeed;

@end

@implementation FeedManager

- (id) init {
    self = [super init];
    if (self) {
        _currentIndex = -1;
        
        self.storeFeed = nil;
    }
    return self;
}

+ (FeedManager *) defaultManager {
    static FeedManager *instance = nil;
    if (instance == nil) {
        instance = [[FeedManager alloc] init];
    }
    return instance;
}

- (void) setNodeFeed: (NSArray *) feed {
    self.storeFeed = feed;
}

- (NSArray *) nodeFeed {
    return _storeFeed;
}

- (NSArray *) nodeFeedForPage:(NSInteger)page {
    if (_storeFeed == nil) return nil;
    
    NSInteger countItems = [_storeFeed count];
    NSInteger rangeLength = NODE_ITEMS_PERPAGE;
    NSInteger rangeLocation = page * rangeLength;
    
    // out of scope
    if (rangeLocation >= countItems) return nil;
    rangeLength = MIN(rangeLength, countItems - rangeLocation);
    
    NSRange range = NSMakeRange(rangeLocation, rangeLength);
    
    return [_storeFeed subarrayWithRange:range];
}

- (NSInteger) rangeLength {
    return NODE_ITEMS_PERPAGE;
}

- (void) setCurrentNodeID: (NSInteger) nodeID {
    NSInteger index = -1;
    if (_storeFeed == nil) {
        _currentIndex = index;
        
        return;
    }
    
    NSInteger countItems = [_storeFeed count];
    for (int i = 0; i < countItems; i++) {
        NSNumber *nodeIDNumber = [_storeFeed objectAtIndex:i];
        
        if ([nodeIDNumber integerValue] == nodeID) {
            index = i;
            
            break;
        }
    }
    
    _currentIndex = index;
}

- (NSInteger) currentNodeID {
    return [self nodeIDFromStorageByIndex:_currentIndex];
}

- (NSInteger) nextNodeID {
    if (_currentIndex == -1) return 0;
    
    NSInteger index = _currentIndex + 1;
    return [self nodeIDFromStorageByIndex:index];
}

- (NSInteger) prevNodeID {
    if (_currentIndex == -1) return 0;
    
    NSInteger index = _currentIndex - 1;
    return [self nodeIDFromStorageByIndex:index];
}

- (NSInteger) nodeIDFromStorageByIndex: (NSInteger) index {
    if (index == -1) return 0;
    if (_storeFeed == nil || index >= [_storeFeed count]) {
        return 0;
    }
    
    return [[_storeFeed objectAtIndex:index] integerValue];
}


@end
