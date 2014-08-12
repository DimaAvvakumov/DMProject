//
//  EMError.m
//  Pinme
//
//  Created by Lobanov Aleksey on 07.07.14.
//  Copyright (c) 2014 Lobanov Aleksey. All rights reserved.
//

#import "EMError.h"

@implementation EMError

- (id) initWithErrorType:(TypeErrorCodes) errorType
               errorCode:(EMErrorCodes) errorCode
              andMessage:(NSString *) message
{
    self = [super init];
    if (self) {
        self.typeErrorCode = errorType;
        self.errorCode = errorCode;
        self.message = message;
    }
    
    return self;
}

+ (EMError *) errorWithServerResponse:(NSDictionary *) serverResponse {
    EMError *emError = [[EMError alloc] init];
    
    
    if ([serverResponse objectForKey: @"errors"]) {
        NSDictionary *error;
        if ([[serverResponse objectForKey: @"errors"] isKindOfClass: [NSDictionary class]]) {
            error = [serverResponse objectForKey: @"errors"];
        }
        if ([[serverResponse objectForKey: @"errors"] isKindOfClass: [NSArray class]]) {
            error = [[serverResponse objectForKey: @"errors"] firstObject];
        }
        
        NSLog(@"ОШИБКА! code: %@, msg: %@", [error objectForKey:@"code"], [error objectForKey:@"msg"]);
        
        EMErrorCodes code = (EMErrorCodes)[[error objectForKey:@"code"] integerValue];
        NSString *message = [error objectForKey:@"msg"];
        
        emError.typeErrorCode = TypeErrorServer;
        emError.errorCode = code;
        emError.message = message;
        
        return emError;
    }

    NSDictionary *result = [serverResponse objectForKey: @"result"];
    if (result && [result isKindOfClass: [NSDictionary class]]) {
        if ([result objectForKey: @"success"]) {
            BOOL success = [result boolForKey:@"success"];
            if (!success) {
                emError.typeErrorCode = TypeErrorServer;
                emError.errorCode = EMErrorServerUnknown;
                emError.message = @"";
                
                return emError;
            }
        }
        
        return nil;
    }
    
    emError.typeErrorCode = TypeErrorServer;
    emError.errorCode = EMErrorServerUnknown;
    emError.message = @"";
    
    return emError;
}

@end
