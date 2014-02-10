//
//  WebManager.m
//  formulaEastwind
//
//  Created by Dima Avvakumov on 06.10.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "WebManager.h"

@implementation WebManager

+ (WebManager *) defaultManager {
    static WebManager *instance = nil;
    if (instance == nil) {
        instance = [[WebManager alloc] init];
    }
    return instance;
}

- (BOOL) openURL: (NSURL *) url {
    NSString *scheme = url.scheme;
    
    if ([scheme isEqualToString:@"mailto"]) {
        NSArray *rawURLparts = [[url resourceSpecifier] componentsSeparatedByString:@"?"];
        if (rawURLparts.count > 2) {
            return NO; // invalid URL
        }
        
//        NSMutableArray *toRecipients = [NSMutableArray array];
//        NSString *defaultRecipient = [rawURLparts objectAtIndex:0];
//        if (_defaultRecipient) {
//            [toRecipients addObject:_defaultRecipient];
//        }
        
        NSString *subject = nil;
        NSString *body = nil;
        NSMutableArray *to = [NSMutableArray arrayWithObject: [rawURLparts objectAtIndex:0]];
        NSArray *cc = nil;
        NSArray *bcc = nil;
        
        if (rawURLparts.count == 2) {
            NSString *queryString = [rawURLparts objectAtIndex:1];
            
            NSArray *params = [queryString componentsSeparatedByString:@"&"];
            for (NSString *param in params) {
                NSArray *keyValue = [param componentsSeparatedByString:@"="];
                if (keyValue.count != 2) {
                    continue;
                }
                NSString *key = [[keyValue objectAtIndex:0] lowercaseString];
                NSString *value = [[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                if ([key isEqualToString:@"subject"]) {
                    subject = value;
                }
                
                if ([key isEqualToString:@"body"]) {
                    body = value;
                }
                
                if ([key isEqualToString:@"to"]) {
                    NSArray *addTo = [value componentsSeparatedByString:@","];
                    
                    [to addObjectsFromArray: addTo];
                }
                
                if ([key isEqualToString:@"cc"]) {
                    cc = [value componentsSeparatedByString:@","];
                }
                
                if ([key isEqualToString:@"bcc"]) {
                    bcc = [value componentsSeparatedByString:@","];
                }
            }
        }
        
        // send notification
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity: 6];
        if (subject) {
            [info setObject:subject forKey:WebManager_InfoKey_Subject];
        }
        if (body) {
            [info setObject:body forKey:WebManager_InfoKey_Body];
            [info setObject:[NSNumber numberWithBool:NO] forKey:WebManager_InfoKey_BodyIsHTML];
        }
        if (to) {
            [info setObject:to forKey:WebManager_InfoKey_To];
        }
        if (cc) {
            [info setObject:cc forKey:WebManager_InfoKey_CC];
        }
        if (bcc) {
            [info setObject:bcc forKey:WebManager_InfoKey_BCC];
        }
        
        [nc postNotificationName:WebManager_SendMailNotification object:nil userInfo:info];
        
        return YES;
    } else if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"file"]){
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity: 2];
        [info setObject:url forKey:WebManager_InfoKey_URL];
        
        [nc postNotificationName:WebManager_OpenURLNotification object:nil userInfo:info];
        
        return YES;
    }
    
    return NO;
}

- (void) sendMailWithSubject: (NSString *) subject body: (NSString *) body asHtml: (BOOL) isHtml toRecipients: (NSArray *) recipients {
    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity: 6];
    if (subject) {
        [info setObject:subject forKey:WebManager_InfoKey_Subject];
    }
    if (body) {
        [info setObject:body forKey:WebManager_InfoKey_Body];
        [info setObject:[NSNumber numberWithBool:isHtml] forKey:WebManager_InfoKey_BodyIsHTML];
    }
    if (recipients) {
        [info setObject:recipients forKey:WebManager_InfoKey_To];
    }
    
    [nc postNotificationName:WebManager_SendMailNotification object:nil userInfo:info];
}

- (void) addContact:(NSDictionary *)info {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:WebManager_AddContactNotification object:nil userInfo:info];
}

@end
