//
//  DownloadCheckOperation.m
//  formulaEastwind
//
//  Created by Dima Avvakumov on 30.10.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "DownloadCheckOperation.h"

@interface DownloadCheckOperation()

@property (assign, nonatomic) BOOL actualState;

@end

@implementation DownloadCheckOperation

- (id) init {
    self = [super init];
    if (self) {
        
        self.finishBlock = nil;
        self.actualState = YES;
    }
    return self;
}

#pragma mark - NSOperation methods

- (void) start {
    [self beforeStart];
    
    [self downloadUpdates];
    
    // finished block
    if (!_isCancelled) {
        [self executeBlock];
    }
    [self finish];
}

- (BOOL) downloadUpdates {
    NodeItem *lastItem = [[CoreDataManager defaultManager] lastNodeItem];
    
    // performing params
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"jsonResponse"];
    [params setObject:((IS_PAD) ? @"iPad" : @"iPhone") forKey:@"family"];
    [params setObject:[NSNumber numberWithInt:(([UIScreen isRetina]) ? 1 : 0)] forKey:@"retina"];

    // add hot news hash
    if (lastItem) {
        [params setObject:[NSNumber numberWithInteger:lastItem.nodeID] forKey:@"lastID"];
    }
    
    // performing request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *apiActionUrl = [NSString stringWithFormat:@"%@%@",EMConfigManager.serverAbsolutePath, @"messenger/message.list"];
    AFURLConnectionOperation *operation = [manager GET:apiActionUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = [responseObject objectForKey:@"result"];
        self.whileDownloading = NO;
        
        self.emError = [EMError errorWithServerResponse:responseObject];
        self.successDownload = (self.emError)?NO:YES;
        
        if (self.successDownload) {
            self.JSON = result;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.emError = [[EMError alloc] initWithErrorType:TypeErrorInApp
                                                errorCode:EMErrorInAppNoInternet
                                               andMessage:@""];
        
        self.whileDownloading = NO;
        self.successDownload = NO;
    }];
    
    self.successDownload = NO;
    self.whileDownloading = YES;
    [operation start];
    
    while (self.whileDownloading) {
        if (_isCancelled) {
            [operation cancel];
            return NO;
        }
        if ([operation isCancelled]) {
            break;
        }
        
        [NSThread sleepForTimeInterval: 0.1];
    }
    
    if (self.emError) {
        // [self executeBlock];
        return NO;
    }
    
    [self parseDownloadInfo: self.JSON];
    
    return YES;
}

- (void) parseDownloadInfo:(NSDictionary *)json {
    self.actualState = [[json numberForKey:@"actualState"] boolValue];
}

- (void) executeBlock {
    if (_finishBlock && !_isCancelled) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(_actualState);
        });
    }
}

@end
