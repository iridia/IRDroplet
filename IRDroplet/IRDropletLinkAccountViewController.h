//
//  IRDropletLinkAccountViewController.h
//  IRDroplet
//
//  Created by Evadne Wu on 3/13/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^IRDropletLinkAccountCompletion)(BOOL didFinish, NSError *error);

@interface IRDropletLinkAccountViewController : UIViewController

/*

	IRDropletLinkAccountViewController is a drop-in replacement to the old “create account” controller.
	
	It does:
		*	Provide easy, in-app authentication — a more seamless experience like the old one
		*	Allow very structured calling site code by providing a single (albeit asynchronous) point of exit
	
	It does not:
		* Support multiple accounts.  We don’t use that in our app, so this is not being added.
		*	Support back / forward.

*/

+ (id) controllerWithCompletion:(IRDropletLinkAccountCompletion)block;
- (id) initWithCompletion:(IRDropletLinkAccountCompletion)block;

- (UINavigationController *) wrappingNavigationController;
//	Creates one if not already wrapped, mostly for succinctness
//	Also an overriding point for potential styling work
//	on the bar (as well as the bar button items), or for class swizzling.

@end
