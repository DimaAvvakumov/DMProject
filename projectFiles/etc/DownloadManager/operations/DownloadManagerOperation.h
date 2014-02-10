//
//  DownloadManagerOperation.h
//  formulaEastwind
//
//  Created by Dima Avvakumov on 19.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManagerOperation : NSOperation {
    BOOL _isReady;
    BOOL _finished;
    BOOL _executing;
    BOOL _isCancelled;
}

@property (atomic, assign) BOOL whileDownloading;
@property (atomic, assign) BOOL successDownload;
@property (strong, nonatomic) id JSON;
@property (assign, nonatomic) NSInteger error;

- (void) beforeStart;
- (void) finish;

- (NSString *) identifier;
- (void) setIdentifier: (NSString *) identifier;

@end
