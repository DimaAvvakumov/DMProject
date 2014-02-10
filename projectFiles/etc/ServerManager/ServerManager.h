//
//  ServerManager.h
//  formulaEastWind
//
//  Created by Dima Avvakumov on 17.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *) defaultManager;

- (NSString *) errorStrigByNumber: (NSInteger) errNO;
- (BOOL) isAuthError: (NSInteger) errNO;
- (BOOL) isDenyError: (NSInteger) errNO;

#pragma mark - Help function
- (NSInteger) parseResultCode: (NSDictionary *) json;

#pragma mark - Peoples

- (void) setAboutPeoples: (NSArray *) peoples;
- (NSArray *) aboutPeoples;

@end
