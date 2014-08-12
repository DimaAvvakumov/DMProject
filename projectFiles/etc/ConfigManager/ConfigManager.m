//
//  ConfigManager.m
//  proteplo
//
//  Created by Dima Avvakumov on 11.04.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager

+(ConfigManager *) defaultManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Lang
- (NSArray *) languageList {
    return @[@{@"ru": @"Русский", @"isDefault":@""}];
}

#pragma mark - Google analytics

- (NSString *) googleAnalyticsTrackID {
    return @"";
}

#pragma mark - Facebook

- (NSString *) facebookAppID {
    return @"254249284632475";
}

//- (NSString *) facebookAppSecret {
//    return @"";
//}
//
#pragma mark - Twitter

- (NSString *) twitterAppKey {
    return @"gFiM1yxoiehxEe3FT1EnA";
}

- (NSString *) twitterAppSecret {
    return @"RZne8oSdN2lrJvY1RzKCESsutNJ5cbhUpGLxFHLY19o";
}

#pragma mark - Vkontakte
- (NSString *) vkontakteAppID {
    return @"5832960";
}

#pragma mark - Odnoklassniki
- (NSString *) odnoklassnikiAppID {
    return @"5832960";
}
- (NSString *) odnoklassnikiAppKey {
    return @"CBACAKFBABABABABA";
}

- (NSString *) odnoklassnikiAppSecret {
    return @"5E4C013D079A4D2102D178CF";
}

#pragma mark - Server params

- (NSString *) serverProtocol {
    return @"http";
}

- (NSString *) serverHost {
    return @"api.east-media.ru";
}

- (NSString *) apnsAbsolutePath {
    return @"http://api.east-media.ru";
}

- (NSString *) apiVersion {
    return @"0.2";
}

- (NSString *) serverAbsolutePath {
    return [NSString stringWithFormat:@"%@://%@/%@/", self.serverProtocol, self.serverHost, self.apiVersion];
}

- (NSURL *) serverURL {
    return [NSURL URLWithString:self.serverAbsolutePath];
}

#pragma mark - Share settings

- (NSString *) itunesAppID {
    return @"";
}

- (NSString *) itunesAppShortLink {
    return @"";
}

@end
