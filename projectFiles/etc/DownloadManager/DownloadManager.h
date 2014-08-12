//
//  DownloadManager.h
//  DMProject
//
//  Created by Dima Avvakumov on 18.12.12.
//  Copyright (c) 2012 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadManagerOperation.h"

// Actions & Downloads

#pragma mark - DownloadManagerDelegate @protocol

@protocol DownloadManagerDelegate <NSObject>

@optional

@end

#pragma mark - DownloadManager @interface

@interface DownloadManager : NSObject

+ (DownloadManager *) defaultManager;

#pragma mark - Observer methods
- (void) addObserver: (id <DownloadManagerDelegate>) observer;
- (void) removeObserver: (id <DownloadManagerDelegate>) observer;

#pragma mark - Add/remove operation methods
- (void) queueAddOperation: (DownloadManagerOperation *) operation;
- (void) queueCancelOperation: (DownloadManagerOperation *) operation;

#pragma mark - Cancel custom operation
- (void) cancelDownloadByIdentifer: (NSString *) identifer;

#pragma mark - Check exist custom operation
- (BOOL) operationWithIdentifierExist: (NSString *) identifer;

@end