//
//  EMError.h
//  Pinme
//
//  Created by Lobanov Aleksey on 07.07.14.
//  Copyright (c) 2014 Lobanov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    // server
    EMErrorServerSuccess = 0,
    EMErrorServerUnknown = 666,
    
    // pin error
    EMErrorServerFileNotFound = 300,
    EMErrorServerUploadFileError = 301,
    EMErrorServerFileBanned = 302,
    EMErrorServerPinAddError = 303,
    EMErrorServerPinNotFound = 304,
    EMErrorServerCommentAddError = 305,
    EMErrorServerFileExists = 306,
    EMErrorServerBoardNotFound = 307,
    
    // auth
    EMErrorServerUserNotFoundOrIncorrectPassword = 100,
    EMErrorServerUserBlocked = 101,
    EMErrorServerUserInactive = 102,
    EMErrorServerSocialAuthError = 103,

    // feedback
    EMErrorServerSendMessageInternalError = 800,
    
    // complaint
    EMErrorServerComplaintBadSubjectId = 900,
    EMErrorServerComplaintPinNotFound = 901,
    EMErrorServerComplaintCommentNotFound = 902,
    EMErrorServerComplaintMessageNotFound = 903,
    
    // inApp
    EMErrorInAppNoInternet = -10,
    
    EMErrorInAppFacebookAccountMissing = -20,
    EMErrorInAppFacebookAccountPermissionDenied = -30
} EMErrorCodes;

typedef enum {
    TypeErrorInApp = 0,
    TypeErrorServer = 1
} TypeErrorCodes;

@interface EMError : NSObject

@property (assign, nonatomic) TypeErrorCodes typeErrorCode;
@property (assign, nonatomic) EMErrorCodes errorCode;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL isActionCommand;

#pragma mark - init
+ (EMError *) errorWithServerResponse:(NSDictionary *) serverResponse;
- (id) initWithErrorType:(TypeErrorCodes) errorType
               errorCode:(EMErrorCodes) errorCode
              andMessage:(NSString *) message;

@end
