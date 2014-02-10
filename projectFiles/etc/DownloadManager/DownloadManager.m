//
//  DownloadManager.m
//  DMProject
//
//  Created by Dima Avvakumov on 18.12.12.
//  Copyright (c) 2012 EDima Avvakumov. All rights reserved.
//

#import "DownloadManager.h"

#define DownloadManager_NSUserDefaultKey_LastUpdateDate @"DownloadManager_NSUserDefaultKey_LastUpdateDate"

#define DownloadManager_OperationIdentifier_Update @"DownloadManager_OperationIdentifier_Update"
#define DownloadManager_OperationIdentifier_Check @"DownloadManager_OperationIdentifier_Check"

#define DownloadManager_OperationIdentifier_Headline @"DownloadManager_OperationIdentifier_Headline"

@interface DownloadManager ()

@property (strong, nonatomic) NSOperationQueue *queueUpdates;
@property (strong, nonatomic) NSOperationQueue *queueDownloads;

@property (strong, nonatomic) NSDate *lastDownloadUpdateDate;

@end

@implementation DownloadManager

+ (DownloadManager *) defaultManager {
    
	static DownloadManager *instance = nil;
	if (instance == nil) {
        instance = [[DownloadManager alloc] init];
    }
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        self.queueUpdates = [[NSOperationQueue alloc] init];
        [_queueUpdates setMaxConcurrentOperationCount: 1];
        
        self.queueDownloads = [[NSOperationQueue alloc] init];
        [_queueDownloads setMaxConcurrentOperationCount: 1];
        
        // last update date
        NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
        self.lastDownloadUpdateDate = [store objectForKey:DownloadManager_NSUserDefaultKey_LastUpdateDate];
    }
    return self;
}

#pragma mark - Common downloads

- (void) cancelDownloadByIdentifer: (NSString *) identifer {
    NSArray *allOperations = [_queueUpdates operations];
    for (int i = 0; i < [allOperations count]; i++) {
        DownloadManagerOperation *operation = (DownloadManagerOperation *) [allOperations objectAtIndex: i];
        
        if ([operation.identifier isEqualToString: identifer]) {
            [operation cancel];
        }
    }
    NSArray *allOperations2 = [_queueDownloads operations];
    for (int i = 0; i < [allOperations2 count]; i++) {
        DownloadManagerOperation *operation = (DownloadManagerOperation *) [allOperations2 objectAtIndex: i];
        
        if ([operation.identifier isEqualToString: identifer]) {
            [operation cancel];
        }
    }
}

- (BOOL) operationWithIdentifierExist: (NSString *) identifer {
    NSArray *allOperations = [_queueUpdates operations];
    for (int i = 0; i < [allOperations count]; i++) {
        DownloadManagerOperation *operation = (DownloadManagerOperation *) [allOperations objectAtIndex: i];
        
        if ([operation.identifier isEqualToString: identifer]) {
            return YES;
        }
    }
    NSArray *allOperations2 = [_queueDownloads operations];
    for (int i = 0; i < [allOperations2 count]; i++) {
        DownloadManagerOperation *operation = (DownloadManagerOperation *) [allOperations2 objectAtIndex: i];
        
        if ([operation.identifier isEqualToString: identifer]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Download updates

- (void) downloadUpdates {
    if ([self operationWithIdentifierExist: DownloadManager_OperationIdentifier_Update]) return;
    [self cancelDownloadByIdentifer:DownloadManager_OperationIdentifier_Check];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:DownloadManagerStartDownloadNotification
                      object:nil
                    userInfo:nil];
    
    DownloadUpdateOperation *operation = [[DownloadUpdateOperation alloc] initWithBlock:^(NSInteger errorCode) {
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        if (errorCode != 0) {
            NSNumber *error = [NSNumber numberWithInteger: errorCode];
            NSDictionary *info = [NSDictionary dictionaryWithObject:error forKey: DownloadManagerUserInfoKeyError];
            [nc postNotificationName:DownloadManagerUpdateFinishNotification
                              object:nil
                            userInfo:info];
        } else {
            [self setDateLastUpdate: [NSDate date]];
            
            NSDictionary *info = nil;
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:DownloadManagerUpdateFinishNotification
                              object:nil
                            userInfo:info];
        }
    }];
    [operation setBannersBlock:^(BOOL bannerDownloaded) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:DownloadManagerBannerDownloadNotification
                          object:nil
                        userInfo:nil];
    }];
    [operation setProgressBlock:^(float progress) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSNumber *p = [NSNumber numberWithFloat:progress];
        NSDictionary *info = [NSDictionary dictionaryWithObject:p forKey:DownloadManagerUserInfoKeyProgress];
        [nc postNotificationName:DownloadManagerProgressDownloadNotification
                          object:nil
                        userInfo:info];
    }];
    operation.identifier = DownloadManager_OperationIdentifier_Update;
    operation.rangeLength = NODE_ITEMS_PERPAGE;
    
    [_queueUpdates addOperation: operation];
}

- (BOOL) updateInProgress {
    if ([self operationWithIdentifierExist: DownloadManager_OperationIdentifier_Update]) {
        return YES;
    }
    
    return NO;
}

- (NSDate *) dateLastUpdate {
    return _lastDownloadUpdateDate;
}

- (void) setDateLastUpdate: (NSDate *) date {
    self.lastDownloadUpdateDate = date;
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setObject:date forKey:DownloadManager_NSUserDefaultKey_LastUpdateDate];
    [store synchronize];
}

#pragma mark - Download nodes

- (void) downloadNodes:(NSArray *)ids withIdentifer:(NSString *)identifer {
    
    DownloadNodesOperation *operation = [[DownloadNodesOperation alloc] initWithIds:ids andBlock:^(NSInteger errorCode) {
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        if (errorCode != 0) {
            NSNumber *error = [NSNumber numberWithInteger: errorCode];
            NSDictionary *info = [NSDictionary dictionaryWithObject: error forKey: DownloadManagerUserInfoKeyError];
            [nc postNotificationName:DownloadManagerNodesFinishNotification
                              object:nil
                            userInfo:info];
        } else {
            NSDictionary *info = [NSDictionary dictionaryWithObject: ids forKey: DownloadManagerUserInfoKeyItemsIds];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:DownloadManagerNodesFinishNotification
                              object:nil
                            userInfo:info];
        }
    }];
    
    [_queueDownloads addOperation: operation];
}

//#pragma mark - Download files
//
//- (void) downloadFile:(NSInteger)fileID {
//    DownloadFileOperation *operation = [[DownloadFileOperation alloc] initWithFileID:fileID andBlock:^(NSInteger errorCode) {
//        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        if (errorCode != 0) {
//            NSNumber *error = [NSNumber numberWithInteger: errorCode];
//            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:2];
//            [info setObject:[NSNumber numberWithInteger:fileID] forKey:DownloadManagerUserInfoKeyFileID];
//            [info setObject:error forKey:DownloadManagerUserInfoKeyError];
//            
//            [nc postNotificationName:DownloadManagerFileFinishNotification
//                              object:nil
//                            userInfo:info];
//        } else {
//            NSDictionary *info = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:fileID] forKey: DownloadManagerUserInfoKeyFileID];
//            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//            [nc postNotificationName:DownloadManagerFileFinishNotification
//                              object:nil
//                            userInfo:info];
//        }
//    }];
//    [operation setProgressBlock:^(NSNumber *progress) {
//        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:2];
//        [info setObject:[NSNumber numberWithInteger:fileID] forKey:DownloadManagerUserInfoKeyFileID];
//        [info setObject:progress forKey:DownloadManagerUserInfoKeyProgress];
//        
//        [nc postNotificationName:DownloadManagerFileProgressNotification
//                          object:nil
//                        userInfo:info];
//    }];
//    
//    [_queueDownloads addOperation: operation];
//}

#pragma mark - Check for update

- (void) checkForUpdate {
    // check for existing operand
    if ([self operationWithIdentifierExist: DownloadManager_OperationIdentifier_Update]) return;
    if ([self operationWithIdentifierExist: DownloadManager_OperationIdentifier_Check]) return;
    
    // check for empty database
    NodeItem *lastItem = [[CoreDataManager defaultManager] lastNodeItem];
    if (lastItem == nil) return;
    
    // check for last updated time
    NSDate *lastDate = [self lastDownloadUpdateDate];
    NSDate *curDate = [NSDate date];
    NSTimeInterval spentTime = [curDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    if (spentTime < 60.0 * 30.0) {
    // if (spentTime < 10.0) {
        return;
    }
    
    DownloadCheckOperation *operation = [[DownloadCheckOperation alloc] init];
    operation.finishBlock = ^(BOOL actualState) {
        // Notification center
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        // Create user info
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:2];
        [info setObject:[NSNumber numberWithBool:actualState] forKey:DownloadManagerUserInfoKeyActualState];
        
        // response error info
        [nc postNotificationName:DownloadManagerCheckFinishNotification
                          object:nil
                        userInfo:info];
        
        // save date
        [self setDateLastUpdate: [NSDate date]];
    };
    operation.identifier = DownloadManager_OperationIdentifier_Check;
    
    [_queueDownloads addOperation: operation];
}

@end
