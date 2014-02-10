//
//  SettingsManager.h
//  igazeta
//
//  Created by Dima Avvakumov on 28.12.13.
//  Copyright (c) 2013 East-media. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SettingsManagerChangeFontNotification @"SettingsManagerChangeFontNotification"
#define SettingsManagerChangeMapNotification @"SettingsManagerChangeMapNotification"

typedef enum {
    SettingsManagerFontSizeSmall = 0,
    SettingsManagerFontSizeMedium = 1,
    SettingsManagerFontSizeLarge = 2
} SettingsManagerFontSize;

typedef enum {
    SettingsManagerMapTypeApple = 0,
    SettingsManagerMapTypeYandex = 1
} SettingsManagerMapType;

@interface SettingsManager : NSObject

+ (SettingsManager *) defaultManager;

#pragma mark - Font methods

- (SettingsManagerFontSize) currentFontSize;
- (void) setCurrentFontSize: (SettingsManagerFontSize) size;

- (UIFont *) articleTitleFont;
- (UIFont *) articleDetailsFont;
- (NSString *) articleCssLink;

#pragma mark - Map methods

- (SettingsManagerMapType) currentMapType;
- (void) setCurrentMapType: (SettingsManagerMapType) type;

@end
