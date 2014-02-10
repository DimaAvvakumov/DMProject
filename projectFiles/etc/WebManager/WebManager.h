//
//  WebManager.h
//  formulaEastwind
//
//  Created by Dima Avvakumov on 06.10.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WebManager_OpenURLNotification @"WebManager_OpenURLNotification"
#define WebManager_SendMailNotification @"WebManager_SendMailNotification"
#define WebManager_AddContactNotification @"WebManager_AddContactNotification"

#define WebManager_InfoKey_URL @"WebManager_InfoKey_URL"

#define WebManager_InfoKey_Subject @"WebManager_InfoKey_Subject"
#define WebManager_InfoKey_Body @"WebManager_InfoKey_Body"
#define WebManager_InfoKey_BodyIsHTML @"WebManager_InfoKey_BodyIsHTML"
#define WebManager_InfoKey_To @"WebManager_InfoKey_To"
#define WebManager_InfoKey_CC @"WebManager_InfoKey_CC"
#define WebManager_InfoKey_BCC @"WebManager_InfoKey_BCC"

#define WebManager_ContactInfoKey_FirstName     @"FirstName"
#define WebManager_ContactInfoKey_LastName      @"lastName"
#define WebManager_ContactInfoKey_PhoneNumber   @"PhoneNumber"
#define WebManager_ContactInfoKey_MobileNumber  @"MobileNumber"
#define WebManager_ContactInfoKey_Email         @"Email"
#define WebManager_ContactInfoKey_Address       @"Address"
#define WebManager_ContactInfoKey_Avatar        @"Avatar"

@interface WebManager : NSObject

+ (WebManager *) defaultManager;

- (BOOL) openURL: (NSURL *) url;
- (void) sendMailWithSubject: (NSString *) subject body: (NSString *) body asHtml: (BOOL) isHtml toRecipients: (NSArray *) recipients;

- (void) addContact: (NSDictionary *) info;

@end
