//
//  DownloadNodesUpdateOperation.h
//  igazeta
//
//  Created by Dima Avvakumov on 10.01.14.
//  Copyright (c) 2014 East-media. All rights reserved.
//

#import "DownloadManagerOperation.h"

typedef void (^DownloadNodesUpdateOperationCompetitionBlock)(BOOL isUpdated);
typedef void (^DownloadNodesUpdateOperationErrorBlock)(NSInteger errorCode);

@interface DownloadNodesUpdateOperation : DownloadManagerOperation

@property (copy, nonatomic) DownloadNodesUpdateOperationCompetitionBlock successBlock;
@property (copy, nonatomic) DownloadNodesUpdateOperationErrorBlock errorBlock;

@property (strong, nonatomic) NSArray *ids;
@property (assign, nonatomic) NSRange range;
@property (assign, nonatomic) NSInteger categoryID;
@property (strong, nonatomic) NSString *dateTag;

@property (assign, nonatomic) BOOL isMedia;

@property (assign, nonatomic) BOOL isAuthor;
@property (assign, nonatomic) NSInteger authorRubricID;

@property (assign, nonatomic) BOOL isSpecial;
@property (assign, nonatomic) NSInteger specialRubricID;

@end
