//
//  DownloadManager.h
//  DMProject
//
//  Created by Dima Avvakumov on 18.12.12.
//  Copyright (c) 2012 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadUpdateOperation.h"
#import "DownloadNodesOperation.h"
#import "DownloadNodesUpdateOperation.h"
#import "DownloadCheckOperation.h"

#define DownloadManagerStartDownloadNotification @"DownloadManagerStartDownloadNotification"
#define DownloadManagerProgressDownloadNotification @"DownloadManagerProgressDownloadNotification"
#define DownloadManagerFinishDownloadNotification @"DownloadManagerFinishDownloadNotification"
#define DownloadManagerBannerDownloadNotification @"DownloadManagerBannerDownloadNotification"

#define DownloadManagerCheckFinishNotification @"DownloadManagerCheckFinishNotification"

#define DownloadManagerUpdateFinishNotification @"DownloadManagerUpdateFinishNotification"

#define DownloadManagerNodesFinishNotification @"DownloadManagerNodesFinishNotification"

#define DownloadManagerProgramFinishNotification @"DownloadManagerProgramFinishNotification"

#define DownloadManagerFileFinishNotification @"DownloadManagerFileFinishNotification"
#define DownloadManagerFileProgressNotification @"DownloadManagerFileProgressNotification"

#define DownloadManagerChatThreadsUpdateNotification @"DownloadManagerChatThreadsUpdateNotification"
#define DownloadManagerChatMessagesUpdateNotification @"DownloadManagerChatMessagesUpdateNotification"

#define DownloadManagerProgramReviewNotification @"DownloadManagerProgramReviewNotification"
//#define DownloadManagerChatMessagesUpdateNotification @"DownloadManagerChatMessagesUpdateNotification"

#define DownloadManagerHeadlineFinishNotification @"DownloadManagerHeadlineFinishNotification"

#define DownloadManagerUserInfoKeyError @"error"
#define DownloadManagerUserInfoKeyProgress @"progress"
#define DownloadManagerUserInfoKeyArticleID @"articleID"
#define DownloadManagerUserInfoKeyArticleIds @"articleIds"
#define DownloadManagerUserInfoKeyItemsIds @"itemsIds"
#define DownloadManagerUserInfoKeyActualState @"actualState"
#define DownloadManagerUserInfoKeyBannerUpdated @"bannerUpdated"
#define DownloadManagerUserInfoKeyFileID @"fileID"
#define DownloadManagerUserInfoKeyIsUpdated @"isUpdated"
#define DownloadManagerUserInfoKeyChatThreadID @"threadID"

@interface DownloadManager : NSObject

+ (DownloadManager *) defaultManager;

- (void) cancelDownloadByIdentifer: (NSString *) identifer;
- (BOOL) operationWithIdentifierExist: (NSString *) identifer;

- (void) downloadUpdates;
- (BOOL) updateInProgress;
- (NSDate *) dateLastUpdate;

- (void) downloadNodes: (NSArray *) ids withIdentifer: (NSString *) identifer;

- (void) checkForUpdate;

@end