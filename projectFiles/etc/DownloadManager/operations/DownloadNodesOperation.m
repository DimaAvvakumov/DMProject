//
//  DownloadNodesOperation.m
//  igazeta
//
//  Created by Dima Avvakumov on 23.11.13.
//  Copyright (c) 2013 East-media. All rights reserved.
//

#import "DownloadNodesOperation.h"

@interface DownloadNodesOperation()

@property (strong, nonatomic) NSArray *ids;
@property (copy, nonatomic) DownloadNodesOperationCompetitionBlock block;

@end

@implementation DownloadNodesOperation

- (id) initWithIds:(NSArray *)ids andBlock:(DownloadNodesOperationCompetitionBlock)block {
    self = [super init];
    if (self) {
        
        self.ids = ids;
        self.block = block;
    }
    return self;
}

#pragma mark - NSOperation methods

- (void) start {
    [self beforeStart];
    
    [self downloadItems];
    
    [[CoreDataManager defaultManager] saveContext];
    [self executeBlock];
    [self finish];
}

- (BOOL) downloadItems {
    // performing params
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"jsonResponse"];
    [params setObject:((IS_PAD) ? @"iPad" : @"iPhone") forKey:@"family"];
    [params setObject:[NSNumber numberWithInt:(([UIScreen isRetina]) ? 1 : 0)] forKey:@"retina"];
    [params setObject:[_ids componentsJoinedByString: @","] forKey:@"ids"];
    
    // performing request
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL: ServerParams_BaseURL];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"ru/nodes/load.html" parameters:params];
    [request setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 30.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSInteger resultCode = [[ServerManager defaultManager] parseResultCode:JSON];
        if (resultCode != 0) {
            
            self.error = resultCode;
            self.whileDownloading = NO;
            self.successDownload = NO;
            
            return;
        }
        
        self.JSON = JSON;
        self.whileDownloading = NO;
        self.successDownload = YES;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        self.error = ServerParams_ErrorServerIsUnavailable;
        
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
    
    if (self.error) {
        [self executeBlock];
        return NO;
    }
    
    [self parseDownloadInfo: self.JSON];
    
    return YES;
}

- (void) parseDownloadInfo:(NSDictionary *)json {
    
#pragma mark parse request
    NSArray *nodesItems = [json objectForKey: @"nodes"];
    if (nodesItems && [nodesItems isKindOfClass: [NSArray class]]) {
        for (NSDictionary *itemInfo in nodesItems) {
            [[CoreDataManager defaultManager] parseNodeItem: itemInfo];
        }
    }
}

- (void) executeBlock {
    if (_block && !_isCancelled) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _block(self.error);
        });
    }
}

@end
