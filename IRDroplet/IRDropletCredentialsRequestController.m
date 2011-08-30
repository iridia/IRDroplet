//
//  IRDropletCredentialsRequestController.m
//  IRDroplet
//
//  Created by Evadne Wu on 8/31/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRDropletCredentialsRequestController.h"
#import "DBLoginController.h"

@interface IRDropletCredentialsRequestController () <DBLoginControllerDelegate>
@property (nonatomic, readwrite, copy) void (^completionBlock)(BOOL didAuthenticate);
@end

@implementation IRDropletCredentialsRequestController
@synthesize completionBlock;

+ (id) controllerWithCompletionBlock:(void(^)(BOOL didAuthenticate))aBlock {

	DBLoginController *loginController = [[[DBLoginController alloc] init] autorelease];
	IRDropletCredentialsRequestController *returnedController = [[[self alloc] initWithRootViewController:loginController] autorelease];
	
	loginController.delegate = returnedController;
	returnedController.completionBlock = aBlock;
	
	return returnedController;

}

- (id) initWithRootViewController:(UIViewController *)rootViewController {

	self = [super initWithRootViewController:rootViewController];
	if (!self)
		return nil;
		
	switch (UI_USER_INTERFACE_IDIOM()) {
		case UIUserInterfaceIdiomPad: {
			self.modalPresentationStyle = UIModalPresentationFormSheet;
			break;
		}
		default: {
			break;
		}
	}
	
	return self;

}

- (void) dealloc {
	
	[completionBlock release];
	[super dealloc];

}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return YES;
	
}

- (void)loginControllerDidLogin:(DBLoginController*)controller {

	if (self.completionBlock)
		self.completionBlock(YES);

}

- (void)loginControllerDidCancel:(DBLoginController*)controller {

	if (self.completionBlock)
		self.completionBlock(NO);

}

@end
