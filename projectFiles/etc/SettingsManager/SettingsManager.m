//
//  SettingsManager.m
//  igazeta
//
//  Created by Dima Avvakumov on 28.12.13.
//  Copyright (c) 2013 East-media. All rights reserved.
//

#import "SettingsManager.h"

@interface SettingsManager()

@property (assign, nonatomic) SettingsManagerFontSize storeFontSize;
@property (assign, nonatomic) SettingsManagerMapType storeMapType;

@property (strong, nonatomic) UIFont *articleTitle;
@property (strong, nonatomic) UIFont *articleDetails;
@property (strong, nonatomic) NSString *articleCss;

- (void) buildFonts;

@end

@implementation SettingsManager

- (id) init {
    self = [super init];
    if (self) {
        self.storeFontSize = SettingsManagerFontSizeSmall;
        [self buildFonts];
        
        self.storeMapType = SettingsManagerMapTypeApple;
    }
    return self;
}

+ (SettingsManager *) defaultManager {
    static SettingsManager *instance = nil;
    if (instance == nil) {
        instance = [[SettingsManager alloc] init];
    }
    
    return instance;
}

#pragma mark - Font methods

- (SettingsManagerFontSize) currentFontSize {
    return _storeFontSize;
}

- (void) setCurrentFontSize: (SettingsManagerFontSize) size {
    if (_storeFontSize == size) return;
    
    self.storeFontSize = size;
    [self buildFonts];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:SettingsManagerChangeFontNotification object:nil];
}

- (void) buildFonts {
    switch (_storeFontSize) {
        default:
        case SettingsManagerFontSizeSmall: {
            self.articleTitle = [UIFont fontWithName: @"PTSans-Bold" size: 24.0];
            self.articleDetails = [UIFont fontWithName: @"PTSans-Regular" size: 13.0];
            self.articleCss = @"articleFontSmall.css";
            
            break;
        }
        case SettingsManagerFontSizeMedium: {
            self.articleTitle = [UIFont fontWithName: @"PTSans-Bold" size: 26.0];
            self.articleDetails = [UIFont fontWithName: @"PTSans-Regular" size: 15.0];
            self.articleCss = @"articleFontMedium.css";
            
            break;
        }
        case SettingsManagerFontSizeLarge: {
            self.articleTitle = [UIFont fontWithName: @"PTSans-Bold" size: 28.0];
            self.articleDetails = [UIFont fontWithName: @"PTSans-Regular" size: 17.0];
            self.articleCss = @"articleFontLarge.css";
            
            break;
        }
    }
    
}

- (UIFont *) articleTitleFont {
    return _articleTitle;
}

- (UIFont *) articleDetailsFont {
    return _articleDetails;
}

- (NSString *) articleCssLink {
    return _articleCss;
}

#pragma mark - Map methods

- (SettingsManagerMapType) currentMapType {
    return _storeMapType;
}

- (void) setCurrentMapType: (SettingsManagerMapType) type {
    if (_storeMapType == type) return;
    
    self.storeMapType = type;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:SettingsManagerChangeMapNotification object:nil];
}

@end
