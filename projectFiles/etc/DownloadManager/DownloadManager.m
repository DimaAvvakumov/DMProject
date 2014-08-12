//
//  DownloadManager.m
//  DMProject
//
//  Created by Dima Avvakumov on 18.12.12.
//  Copyright (c) 2012 EDima Avvakumov. All rights reserved.
//

#import "DownloadManager.h"
#import "ObserverWrapper.h"

#define DownloadManager_NSUserDefaultKey_LastUpdateDate @"DownloadManager_NSUserDefaultKey_LastUpdateDate"

#define DownloadManager_OperationIdentifier_Issue @"DownloadManager_OperationIdentifier_Issue"

#define DownloadManager_OperationIdentifier_Comments @"DownloadManager_OperationIdentifier_Comments"

@interface DownloadManager ()

@property (strong, nonatomic) NSOperationQueue *queueDownloads;

@property (strong, nonatomic) NSDate *lastDownloadUpdateDate;

@property (strong, nonatomic) NSMutableArray *listObservers;

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
        self.queueDownloads = [[NSOperationQueue alloc] init];
        [_queueDownloads setMaxConcurrentOperationCount: 1];
        
        // last update date
        NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
        self.lastDownloadUpdateDate = [store objectForKey:DownloadManager_NSUserDefaultKey_LastUpdateDate];
        
        // observers
        self.listObservers = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

#pragma mark - Observer methods

- (void) addObserver: (id <DownloadManagerDelegate>) observer {
    NSUInteger index = [self findObjectInObservers:observer];
    if (index != NSNotFound) return;
    
    ObserverWrapper *observerWrapper = [[ObserverWrapper alloc] init];
    observerWrapper.observerObject = observer;
    
    [_listObservers addObject:observerWrapper];
}

- (NSInteger) findObjectInObservers: (id) object {
    for (int i = 0; i < [_listObservers count]; i++) {
        ObserverWrapper *observer = [_listObservers objectAtIndex:i];
        if ([observer.observerObject isEqual:object]) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (void) removeObserver: (id <DownloadManagerDelegate>) observer {
    NSUInteger index = [self findObjectInObservers:observer];
    if (index == NSNotFound) return;
    
    [_listObservers removeObjectAtIndex:index];
}

#pragma mark - Add/remove operation methods

- (void) queueAddOperation: (DownloadManagerOperation *) operation {
    [_queueDownloads addOperation:operation];
}

- (void) queueCancelOperation: (DownloadManagerOperation *) operation {
    NSArray *allOperations = [_queueDownloads operations];
    for (int i = 0; i < [allOperations count]; i++) {
        DownloadManagerOperation *checkedOperation = (DownloadManagerOperation *) [allOperations objectAtIndex: i];
        
        if ([checkedOperation isEqual:operation]) {
            [checkedOperation cancel];
        }
    }
}

#pragma mark - Cancel custom operation

- (void) cancelDownloadByIdentifer: (NSString *) identifer {
    NSArray *allOperations2 = [_queueDownloads operations];
    for (int i = 0; i < [allOperations2 count]; i++) {
        DownloadManagerOperation *operation = (DownloadManagerOperation *) [allOperations2 objectAtIndex: i];
        
        if ([operation.identifier isEqualToString: identifer]) {
            [operation cancel];
        }
    }
}

#pragma mark - Check exist custom operation

- (BOOL) operationWithIdentifierExist: (NSString *) identifer {
    NSArray *allOperations2 = [_queueDownloads operations];
    for (int i = 0; i < [allOperations2 count]; i++) {
        DownloadManagerOperation *operation = (DownloadManagerOperation *) [allOperations2 objectAtIndex: i];
        
        if ([operation.identifier isEqualToString: identifer]) {
            return YES;
        }
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

@end
