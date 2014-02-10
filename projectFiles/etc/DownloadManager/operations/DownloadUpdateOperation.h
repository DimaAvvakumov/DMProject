//
//  DownloadUpdateOperation.h
//  formulaEastwind
//
//  Created by Dima Avvakumov on 19.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "DownloadManagerOperation.h"

typedef void (^DownloadUpdateOperationCompetitionBlock)(NSInteger errorCode);
typedef void (^DownloadUpdateOperationProgressBlock)(float progress);
typedef void (^DownloadUpdateOperationBannersBlock)(BOOL bannerDownloaded);

@interface DownloadUpdateOperation : DownloadManagerOperation

@property (copy, nonatomic) DownloadUpdateOperationProgressBlock progressBlock;
@property (copy, nonatomic) DownloadUpdateOperationBannersBlock bannersBlock;

@property (assign, nonatomic) NSInteger rangeLength;

- (id) initWithBlock: (DownloadUpdateOperationCompetitionBlock) block;

@end
