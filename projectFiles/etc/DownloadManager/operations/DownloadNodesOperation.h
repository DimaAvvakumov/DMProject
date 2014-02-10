//
//  DownloadNodesOperation.h
//  igazeta
//
//  Created by Dima Avvakumov on 23.11.13.
//  Copyright (c) 2013 East-media. All rights reserved.
//

#import "DownloadManagerOperation.h"

typedef void (^DownloadNodesOperationCompetitionBlock)(NSInteger errorCode);

@interface DownloadNodesOperation : DownloadManagerOperation

- (id) initWithIds: (NSArray *) ids andBlock: (DownloadNodesOperationCompetitionBlock) block;

@end
