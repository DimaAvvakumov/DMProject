//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@implementation SVModalWebViewController

@synthesize barsTintColor, availableActions, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
		self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
	
	if (DeviceSystemMajorVersion() < 7) {
		self.navigationBar.tintColor = self.barsTintColor;
	} else {
		self.navigationBar.barTintColor = self.barsTintColor;
	}
	
	if (DeviceSystemMajorVersion()< 7) {
		self.navigationBar.barStyle = UIBarStyleBlackOpaque;
	}
	
	if (self.doneButtonTitle.length > 0) {
		self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.doneButtonTitle style:UIButtonTypeRoundedRect target:webViewController action:@selector(doneButtonClicked:)];
	}
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

@end
