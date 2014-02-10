//
//  DownloadUpdateOperation.m
//  formulaEastwind
//
//  Created by Dima Avvakumov on 19.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "DownloadUpdateOperation.h"

@interface DownloadUpdateOperation() {
    long long downloadedSize;
    long long downloadTotalSize;
}

@property (strong, nonatomic) NSDictionary *jsonBanners;

@property (copy, nonatomic) DownloadUpdateOperationCompetitionBlock block;

@end


@implementation DownloadUpdateOperation

- (id) initWithBlock:(DownloadUpdateOperationCompetitionBlock)block {
    self = [super init];
    if (self) {
        
        self.block = block;
        
        self.rangeLength = NODE_ITEMS_PERPAGE;
    }
    return self;
}

#pragma mark - NSOperation methods

- (void) start {
    [self beforeStart];
    
    [self downloadUpdates];
    
    // finished block
    if (!_isCancelled) {
        [[CoreDataManager defaultManager] saveContext];
        
        [self executeBlock];
    }
    [self finish];
}

- (BOOL) downloadUpdates {
    // params
    NodeItem *lastItem = [[CoreDataManager defaultManager] lastNodeItem];
    
    // performing params
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"jsonResponse"];
    [params setObject:((IS_PAD) ? @"iPad" : @"iPhone") forKey:@"family"];
    [params setObject:[NSNumber numberWithInt:(([UIScreen isRetina]) ? 1 : 0)] forKey:@"retina"];
    
    [params setObject:[NSNumber numberWithInteger:_rangeLength] forKey:@"length"];
    if (lastItem) {
        [params setObject:[NSNumber numberWithInt:lastItem.nodeID] forKey:@"lastID"];
    }
    
    // performing request
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL: ServerParams_BaseURL];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"ru/export/init.html" parameters:params];
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
        // [self executeBlock];
        return NO;
    }
    
    // download banners
    if (YES) {
        // params
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
        [params setObject:[NSNumber numberWithInt:1] forKey:@"jsonResponse"];
        [params setObject:((IS_PAD) ? @"iPad" : @"iPhone") forKey:@"device"];
        [params setObject:@"ru.urn.igazeta2" forKey:@"bundleID"];
        [params setObject:[NSNumber numberWithInt:(([UIScreen isRetina]) ? 1 : 0)] forKey:@"retina"];

        // performing request
        NSURL *baseURL = [NSURL URLWithString:@"https://api.east-media.ru/"];
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL: baseURL];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"ru/advertisements/list.html" parameters:params];
        [request setCachePolicy: NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval: 30.0];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSInteger resultCode = [[ServerManager defaultManager] parseResultCode:JSON];
            if (resultCode != 0) {
                
                // self.error = resultCode;
                self.whileDownloading = NO;
                self.successDownload = NO;
                
                return;
            }
            
            self.jsonBanners = JSON;
            self.whileDownloading = NO;
            self.successDownload = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            // self.error = ServerParams_ErrorServerIsUnavailable;
            
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
        
        if (_jsonBanners) {
            [self parseBanners: _jsonBanners];
        }
    }
    
    // parse download error
    [self parseDownloadInfo: self.JSON];
    
    return YES;
}

- (void) parseBanners:(NSDictionary *)json {
    CoreDataManager *coreData = [CoreDataManager defaultManager];
    
    // parse bunners
    long long bannersSize = 0;
    NSMutableArray *filesToDonwload = nil;
    NSArray *banners = [json objectForKey: @"banners"];
    if (banners && [banners isKindOfClass: [NSArray class]]) {
        filesToDonwload = [NSMutableArray arrayWithCapacity: (2 * [banners count])];
        
        NSArray *oldBanners = [coreData allBanners];
        NSMutableDictionary *existiongItemsIds = nil;
        if (oldBanners) {
            existiongItemsIds = [NSMutableDictionary dictionaryWithCapacity: [oldBanners count]];
            for (Banners *banner in oldBanners) {
                NSString *bannerKey = [[NSNumber numberWithInt:banner.bannerID] stringValue];
                [existiongItemsIds setObject:banner forKey:bannerKey];
            }
        }
        
        for (NSDictionary *bannerInfo in banners) {
            Banners *item = [coreData parseBannersItem: bannerInfo];
            if (item == nil) continue;
            
            NSString *itemKey = [NSString stringWithFormat: @"%d", item.bannerID];
            if (existiongItemsIds) {
                [existiongItemsIds removeObjectForKey: itemKey];
            }
            
            if (item.pathLandscape && [item.pathLandscape length] > 0) {
                NSString *bannerPath = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent: item.pathLandscape];
                if (![[NSFileManager defaultManager] fileExistsAtPath: bannerPath]) {
                    [filesToDonwload addObject:item.pathLandscape];
                    // AFHTTPRequestOperation *operation = [self operationForPath: pathLandscape andDestFile: banner.pathLandscape];
                    
                    // [_queue addOperation: operation];
                    bannersSize += item.fileSizeLandscape;
                }
            }
            if (item.pathPortrait && [item.pathPortrait length] > 0) {
                NSString *bannerPath = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent: item.pathPortrait];
                if (![[NSFileManager defaultManager] fileExistsAtPath: bannerPath]) {
                    [filesToDonwload addObject:item.pathPortrait];
                    // AFHTTPRequestOperation *operation = [self operationForPath: pathPortrait andDestFile: banner.pathPortrait];
                    
                    // [_queue addOperation: operation];
                    
                    bannersSize += item.fileSizePortrait;
                }
            }
        }
        
        if (existiongItemsIds) {
            for (NSNumber *bannerID in existiongItemsIds) {
                Banners *banner = [coreData bannerByID: [bannerID integerValue]];
                
                [coreData removeObjectFromContext: banner];
            }
        }
    }
    
    downloadedSize = 0;
    downloadTotalSize = bannersSize;
    
    if (filesToDonwload) {
        for (NSString *filePath in filesToDonwload) {
            // NSString *destPath = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent: filePath];
            AFHTTPRequestOperation *operation = [self operationForPath: filePath andDestFile: filePath];
            
            self.successDownload = NO;
            self.whileDownloading = YES;
            [operation start];
            
            while (self.whileDownloading) {
                if (_isCancelled) {
                    [operation cancel];
                    return;
                }
//                if ([operation isCancelled]) {
//                    break;
//                }
                
                [NSThread sleepForTimeInterval: 0.1];
            }
            
            if (self.successDownload == NO) return;
        }
        
        if (_bannersBlock) {
            [coreData saveContext];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _bannersBlock(YES);
            });
        }
    }
}

- (void) parseDownloadInfo:(NSDictionary *)json {
    CoreDataManager *coreData = [CoreDataManager defaultManager];

    #pragma mark parse node categories
    NSArray *nodeCategories = [json objectForKey:@"nodeCategories"];
    if (nodeCategories && [nodeCategories isKindOfClass:[NSArray class]]) {
        // old companies
        NSArray *existingItems = [coreData nodeCategoryItems];
        NSMutableDictionary *existiongItemsIds = nil;
        if (existingItems) {
            existiongItemsIds = [NSMutableDictionary dictionaryWithCapacity: [existingItems count]];
            for (NodeCategory *item in existingItems) {
                NSNumber *itemID = [NSNumber numberWithInt: item.categoryID];
                
                [existiongItemsIds setObject:itemID forKey:[itemID stringValue]];
            }
        }
        
        // parse new companies
        for (NSDictionary *itemInfo in nodeCategories) {
            NodeCategory *item = [coreData parseNodeCategory:itemInfo];
            if (item == nil) continue;
            
            NSString *itemKey = [NSString stringWithFormat: @"%d", item.categoryID];
            if (existiongItemsIds) {
                [existiongItemsIds removeObjectForKey: itemKey];
            }
        }
        
        // other companies set companies to nil
        if (existiongItemsIds && [existiongItemsIds count] > 0) {
            for (NSString *key in existiongItemsIds) {
                NSInteger itemID = [[existiongItemsIds numberForKey: key] integerValue];
                NodeCategory *item = [coreData nodeCategoryByID:itemID];
                
                [coreData removeObjectFromContext: item];
            }
        }
    }
    
    #pragma mark parse node items
    NSArray *nodeItems = [json objectForKey:@"nodeItems"];
    if (nodeItems && [nodeItems isKindOfClass:[NSArray class]]) {
        // parse new feed
        for (NSDictionary *itemInfo in nodeItems) {
            NodeItem *item = [coreData parseNodeItem:itemInfo];
            if (item == nil) continue;
        }
    }
    
}

- (void) executeBlock {
    if (_block && !_isCancelled) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _block(self.error);
        });
    }
}

- (AFHTTPRequestOperation *) operationForPath: (NSString *) path andDestFile:(NSString *)destFile {
    NSURL *pathURL;
    if ([path hasPrefix: @"http"]) {
        pathURL = [NSURL URLWithString: path];
    } else {
        pathURL = [NSURL URLWithString: [NSString stringWithFormat: @"http://%@", path]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:pathURL
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30.0];
    
    NSString *destPath = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent: destFile];
    NSString *folder = [destPath stringByDeletingLastPathComponent];
    
    NSString *tmpPath = [destPath stringByAppendingString: @".tmp"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:folder
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath: tmpPath append: NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
            if (![[NSFileManager defaultManager] removeItemAtPath:destPath error:&error]) {
                self.successDownload = NO;
                self.whileDownloading = NO;
                
                NSLog(@"remove file into dm error: %@", error);
                
                return;
            }
        }
        
        if (![[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:destPath error:&error]) {
            self.successDownload = NO;
            self.whileDownloading = NO;
            
            NSLog(@"move file into dm error: %@", error);
            
            return;
        }
        
        self.successDownload = YES;
        self.whileDownloading = NO;
        NSLog(@"Newsstand tmp %@ path: %@", tmpPath, destPath);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.successDownload = NO;
        self.whileDownloading = NO;
        
        NSLog(@"server error: %@", error);
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        downloadedSize += bytesRead;
        
        // float progress = 0.5 * downloadedSize / (float) downloadTotalSize;
        float progress = 1.0 * downloadedSize / (float) downloadTotalSize;
        // NSLog(@"progress: %f", progress);
        
        if (_progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _progressBlock(progress);
            });
        }
    }];
    
    return operation;
}

@end
