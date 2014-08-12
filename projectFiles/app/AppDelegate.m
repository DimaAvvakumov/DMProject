//
//  AppDelegate.m
//  DMProject
//
//  Created by Dima Avvakumov on 08.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"

#import "PadViewController.h"
#import "PhoneViewController.h"

@interface AppDelegate()

@property (strong, nonatomic) PadViewController *padViewController;
@property (strong, nonatomic) PhoneViewController *phoneViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
// fonts provaided by application
//    [NSString printApplicationFonts];
//    return YES;
    
    // base style
    [self initAppearance];
    
    // time zone settings
    [NSTimeZone setDefaultTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    
    // badge cleanup
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // newtwork activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.phoneViewController = [[PhoneViewController alloc] initWithNibName:@"PhoneViewController" bundle:nil];
        
        // ios 6 only make fullscreen
        if (IS_IOS6AndLess) {
            _phoneViewController.wantsFullScreenLayout = YES;
        }
        self.window.rootViewController = self.phoneViewController;
    } else {
        self.padViewController = [[PadViewController alloc] initWithNibName:@"PadViewController" bundle:nil];
        self.window.rootViewController = self.padViewController;
    }
    [self.window makeKeyAndVisible];
    
    // register notification
    [self performSelector:@selector(registerDevice) withObject:nil afterDelay:5.0];

    return YES;
}

- (void) initAppearance {
//    if (IS_IOS6AndLess) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
//    }
//    
//    if (IS_IOS7AndMore) {
//        [[UISearchBar appearance] setBackgroundColor:[UIColor whiteColor]];
//        [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"background_btn_whiteBig.png"]];
//        
//        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
//         setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                 [UIColor grayColor], NSForegroundColorAttributeName,
//                                 [UIFont fontWithName:@"PTSans-Regular" size:13], NSFontAttributeName,
//                                 nil]forState:UIControlStateNormal];
//    }
//    
//    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1], NSForegroundColorAttributeName,
//                                     [UIColor whiteColor], UITextAttributeTextShadowColor,
//                                     [NSValue valueWithUIOffset:UIOffsetMake(0.5, 0.5)], UITextAttributeTextShadowOffset,
//                                     nil];
//    
//	[[UIBarButtonItem appearance] setTitleTextAttributes:settings forState:UIControlStateNormal];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:settings forState:UIControlStateHighlighted];
//    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:16], NSFontAttributeName, nil] forState:UIControlStateNormal];
//    
//    // UITextField appereance
//    UIFont *textFiledFont = [UIFont fontWithName:@"PTSans-Regular" size:13.0];
//    [[UITextField appearance] setFont:textFiledFont];
}

- (void)applicationWillResignActive:(UIApplication *)application {
//    if (_padViewController && [_padViewController canShowSplashBanner]) {
//        [_padViewController showSplashBanner];
//    }
//    
//    if (_phoneViewController && [_phoneViewController canShowSplashBanner]) {
//        [_phoneViewController showSplashBanner];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // badge cleanup
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // start check notification
    // [[DownloadManager defaultManager] checkForUpdate];
    
    // hide splash banner
//    if (_padViewController) {
//        [_padViewController hideSplashBannerWithCheck];
//    }
//    
//    if (_phoneViewController) {
//        [_phoneViewController hideSplashBannerWithCheck];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Register device

- (void) registerDevice {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {
    NSString *webDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    webDeviceToken = [webDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Device successfull register with token: %@", webDeviceToken);
    
    // send token to server
    
    // performing params
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    // [params setObject:[AuthManager defaultManager].token forKey:@"sid"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"type_id"];
    [params setObject:webDeviceToken forKey:@"token"];
#ifdef DEBUG
    [params setValue:@"develop" forKey:@"mode"];
#else
    [params setValue:@"production" forKey:@"mode"];
#endif
    
    // performing request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *apiActionUrl = [NSString stringWithFormat:@"%@%@",EMConfigManager.apnsAbsolutePath, @"auth/set.mobile.token"];
    AFURLConnectionOperation *operation = [manager GET:apiActionUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Token successfully registred");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Register token error: %@", error);
        
    }];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Notification register fail: %@", err);
}

#pragma mark - Facebook handler

//- (BOOL)handleOpenURL:(NSURL*)url {
//    // return [FBSession.activeSession handleOpenURL:url];
//    
//    NSString* scheme = [url scheme];
//    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
//    if ([scheme hasPrefix:prefix]) {
//        return [SHKFacebook handleOpenURL:url];
//    }
//    
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [self handleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [self handleOpenURL:url];
//}

@end
