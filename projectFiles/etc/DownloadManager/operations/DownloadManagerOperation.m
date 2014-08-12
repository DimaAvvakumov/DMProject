//
//  DownloadManagerOperation.m
//  formulaEastwind
//
//  Created by Dima Avvakumov on 19.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "DownloadManagerOperation.h"

@interface DownloadManagerOperation()

@property (nonatomic, strong) NSString *operationIdentifier;

@end

@implementation DownloadManagerOperation

- (id) init {
    self = [super init];
    if (self) {
        _isReady = YES;
        _finished = NO;
        _executing = NO;
        _isCancelled = NO;
        
        self.operationIdentifier = @"";
        
        self.successDownload = NO;
        self.whileDownloading = NO;
        self.emError = nil;
    }
    return self;
}

- (NSString *) identifier {
    return _operationIdentifier;
}

- (void) setIdentifier: (NSString *) identifier {
    self.operationIdentifier = identifier;
}

- (void) beforeStart {
    if (_isCancelled) {
        [self finish];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void) finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void) cancel {
    _isCancelled = YES;
}

- (BOOL) isConcurrent {
    return YES;
}

- (BOOL) isReady {
    return _isReady;
}

- (BOOL) isExecuting {
    return _executing;
}

- (BOOL) isFinished {
    return _finished;
}


@end
