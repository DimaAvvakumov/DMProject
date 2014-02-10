//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

@interface SVWebViewController : UIViewController <UIDocumentInteractionControllerDelegate>

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)doneButtonClicked:(id)sender;

@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;
@property (nonatomic, assign) BOOL hideToolbar;

@end
