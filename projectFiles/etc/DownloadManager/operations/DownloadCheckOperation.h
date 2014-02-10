//
//  DownloadCheckOperation.h
//  formulaEastwind
//
//  Created by Dima Avvakumov on 30.10.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "DownloadManagerOperation.h"

typedef void (^DownloadCheckOperationCompetitionBlock)(BOOL actualState);

@interface DownloadCheckOperation : DownloadManagerOperation

@property (copy, nonatomic) DownloadCheckOperationCompetitionBlock finishBlock;

@end
