//
//  FeedManager.h
//  igazeta
//
//  Created by Dima Avvakumov on 31.12.13.
//  Copyright (c) 2013 East-media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedManager : NSObject

+ (FeedManager *) defaultManager;

- (NSInteger) rangeLength;

- (void) setNodeFeed: (NSArray *) feed;
- (NSArray *) nodeFeed;
- (NSArray *) nodeFeedForPage: (NSInteger) page;

- (void) setCurrentNodeID: (NSInteger) nodeID;
- (NSInteger) currentNodeID;
- (NSInteger) nextNodeID;
- (NSInteger) prevNodeID;


@end
