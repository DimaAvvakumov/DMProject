//
//  ConfigManager.h
//  proteplo
//
//  Created by Dima Avvakumov on 11.04.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

//Keys for NSUserDefaults
#define MainMenuCompact

#define EMConfigManager \
[ConfigManager defaultManager]

@interface ConfigManager : NSObject

+(ConfigManager *) defaultManager;

#pragma mark - Lang
- (NSArray *) languageList;

#pragma mark - Google analytics
- (NSString *) googleAnalyticsTrackID;

#pragma mark - Facebook
- (NSString *) facebookAppID;
//- (NSString *) facebookAppSecret;

#pragma mark - Twitter
- (NSString *) twitterAppKey;
- (NSString *) twitterAppSecret;

#pragma mark - Odnoklassniki
- (NSString *) odnoklassnikiAppID;
- (NSString *) odnoklassnikiAppKey;
- (NSString *) odnoklassnikiAppSecret;

#pragma mark - Vkontakte
- (NSString *) vkontakteAppID;

#pragma mark - Server params
- (NSString *) serverHost;
- (NSString *) serverProtocol;
- (NSString *) serverAbsolutePath;
- (NSString *) apiVersion;
- (NSURL *) serverURL;

- (NSString *) apnsAbsolutePath;

@end
