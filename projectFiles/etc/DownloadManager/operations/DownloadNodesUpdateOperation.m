//
//  DownloadNodesUpdateOperation.m
//  igazeta
//
//  Created by Dima Avvakumov on 10.01.14.
//  Copyright (c) 2014 East-media. All rights reserved.
//

#import "DownloadNodesUpdateOperation.h"

@interface DownloadNodesUpdateOperation()

@property (assign, nonatomic) BOOL isUpdated;

@end

@implementation DownloadNodesUpdateOperation

- (id) init {
    self = [super init];
    if (self) {
        
        self.ids = nil;
        self.categoryID = 0;
        self.range = NSMakeRange(0, 0);
        self.dateTag = nil;
        
        self.successBlock = nil;
        
        self.isUpdated = NO;
    }
    return self;
}

#pragma mark - NSOperation methods

- (void) start {
    [self beforeStart];
    
    BOOL res = [self downloadItems];
    if (res) {
        [[CoreDataManager defaultManager] saveContext];
        [self executeBlock];
    } else {
        [self executeBlock];
    }
    
    [self finish];
}

- (BOOL) downloadItems {
#pragma warning - Replace last item to specify item
    NodeItem *lastItem = nil;
    if (_isMedia) {
        lastItem = [[CoreDataManager defaultManager] lastMediaItem];
    } else {
        lastItem = [[CoreDataManager defaultManager] lastNodeItemWithCategory:_categoryID dateTag:_dateTag];
    }
    
    // performing params
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"jsonResponse"];
    [params setObject:((IS_PAD) ? @"iPad" : @"iPhone") forKey:@"family"];
    [params setObject:[NSNumber numberWithInt:(([UIScreen isRetina]) ? 1 : 0)] forKey:@"retina"];
    if (_ids) {
        [params setObject:[_ids componentsJoinedByString: @","] forKey:@"ids"];
    }
    if (_dateTag) {
        [params setObject:_dateTag forKey:@"dateTag"];
    }
    if (_categoryID) {
        [params setObject:[NSNumber numberWithInteger:_categoryID] forKey:@"categoryID"];
    }
    if (_isMedia) {
        [params setObject:[NSNumber numberWithBool:_isMedia] forKey:@"isMedia"];
    }
    [params setObject:[NSNumber numberWithInteger:_range.location] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:_range.length] forKey:@"length"];
    if (lastItem) {
        [params setObject:[NSNumber numberWithInt:lastItem.nodeID] forKey:@"lastID"];
    }
    
    // performing request
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL: ServerParams_BaseURL];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"ru/node/update.html" parameters:params];
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
        return NO;
    }
    
    [self parseDownloadInfo: self.JSON];
    
    return YES;
}

- (void) parseDownloadInfo:(NSDictionary *)json {
    
    #pragma mark parse request
    NSArray *nodesItems = [json objectForKey: @"nodeItems"];
    if (nodesItems && [nodesItems isKindOfClass: [NSArray class]] && [nodesItems count] > 0) {
        self.isUpdated = YES;
        
        for (NSDictionary *itemInfo in nodesItems) {
            [[CoreDataManager defaultManager] parseNodeItem: itemInfo];
        }
    }
}

- (void) executeBlock {
    if (_errorBlock && self.error != 0) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _errorBlock( self.error );
        });
        
        return;
    }
    
    if (_isCancelled) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _errorBlock( 0 );
        });
        
        return;
    }
    
    if (_successBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _successBlock( _isUpdated );
        });
    }
}

@end
