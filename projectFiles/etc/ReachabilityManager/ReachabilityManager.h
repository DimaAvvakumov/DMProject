//
//  ReachabilityManager.h
//  bosfera
//
//  Created by Dima Avvakumov on 21.02.13.
//  Copyright (c) 2013 East Media LTD. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ReachabilityManager : AFHTTPClient

@property (assign, nonatomic) AFNetworkReachabilityStatus status;

+ (ReachabilityManager*) defaultManager;

- (BOOL) internetAvaliable;

@end
