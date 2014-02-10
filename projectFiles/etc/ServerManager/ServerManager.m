//
//  ServerManager.m
//  formulaEastWind
//
//  Created by Dima Avvakumov on 17.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "ServerManager.h"

#define ServerManager_ErrorLoginFailed 100

@implementation ServerManager

+ (ServerManager *) defaultManager {
    static ServerManager *instance = nil;
    if (instance == nil) {
        instance = [[ServerManager alloc] init];
    }
    return instance;
}

#pragma mark - Error message

- (NSString *) errorStrigByNumber: (NSInteger) errNO {
    switch (errNO) {
        case ServerParams_ErrorAuthorizationFailed: {
            return @"Ошибка авторизации";
            
            break;
        }
        case ServerParams_ErrorAccessDeny: {
            return @"Нет доступа";
            
            break;
        }
        case ServerParams_ErrorServerWrongResponse: {
            return @"Сервер временно недоступен. Пожалуйста повторите попытку позже";
            
            break;
        }
        case ServerParams_ErrorServerIsUnavailable: {
            return @"Сервер недоступен. Пожалуйста повторите попытку позже";
            
            break;
        }
        case ServerParams_ErrorUnknow: {
            return @"Неизвестная ошибка. Пожалуйста повторите попытку позже";
            
            break;
        }
        case ServerManager_ErrorLoginFailed: {
            return @"Неверное имя пользователя или пароль";
            
            break;
        }
        case ServerParams_ErrorFileManagerCreate: {
            return @"Ошибка файловой системы. Пожалуйста, убедитесь что у вас достаточно свободного места";
            
            break;
        }
        case ServerParams_ErrorFileManagerModify: {
            return @"Ошибка файловой системы. Пожалуйста, повторите попытку позже";
            
            break;
        }
        default:
            return @"Сервер недоступен. Пожалуйста, проверьте ваше сетевое соединение или повторите попытку позже";
            
            break;
    }
}

#pragma mark - Error type

- (BOOL) isAuthError: (NSInteger) errNO {
    return (errNO == ServerParams_ErrorAuthorizationFailed);
}

- (BOOL) isDenyError: (NSInteger) errNO {
    return (errNO == ServerParams_ErrorAccessDeny);
}

#pragma mark - Help function

- (NSInteger) parseResultCode: (NSDictionary *) json {
    if (![json isKindOfClass: [NSDictionary class]]) {
        return ServerParams_ErrorServerWrongResponse;
    }
    
    NSNumber *resultCode = [json objectForKey: @"resultCode"];
    if (!resultCode || (![resultCode isKindOfClass:[NSNumber class]])) {
        return ServerParams_ErrorServerWrongResponse;
    }
    
    return [resultCode integerValue];
}

#pragma mark - Peoples

- (void) setAboutPeoples: (NSArray *) peoples {
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    if (peoples) {
        [store setObject:peoples forKey:@"ServerManager_AboutPeoplesArray"];
    } else {
        [store removeObjectForKey:@"ServerManager_AboutPeoplesArray"];
    }
    [store synchronize];
}

- (NSArray *) aboutPeoples {
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    return [store objectForKey:@"ServerManager_AboutPeoplesArray"];
}


@end
