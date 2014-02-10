//
//  ReachabilityManager.m
//  bosfera
//
//  Created by Dima Avvakumov on 21.02.13.
//  Copyright (c) 2013 East Media LTD. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

- (id) init {
    NSURL *url = [NSURL URLWithString: @"http://formula.east-media.ru/"];
    self = [super initWithBaseURL: url];
    
    if (self) {
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[ReachabilityManager defaultManager] setStatus: status];
        }];
        
        self.status = self.networkReachabilityStatus;
    }
    return self;
}

+ (ReachabilityManager*) defaultManager {
    static ReachabilityManager *instance = nil;
    if (instance == nil) {
        instance = [[ReachabilityManager alloc] init];
    }
    return instance;
}

- (BOOL) internetAvaliable {
    if (_status == AFNetworkReachabilityStatusReachableViaWiFi) return YES;
    if (_status == AFNetworkReachabilityStatusReachableViaWWAN) return YES;
    if (_status == AFNetworkReachabilityStatusUnknown) return YES;
    
    return NO;
}

@end
