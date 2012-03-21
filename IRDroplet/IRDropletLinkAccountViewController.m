//
//  IRDropletLinkAccountViewController.m
//  IRDroplet
//
//  Created by Evadne Wu on 3/13/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRDropletLinkAccountViewController.h"
#import "DBSession+IRDropletAdditions.h"

@interface IRDropletLinkAccountViewController () <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *view;
@property (nonatomic, readwrite, copy) IRDropletLinkAccountCompletion completionBlock;

@property (nonatomic, readonly, retain) UIActivityIndicatorView *spinner;

@end

@implementation IRDropletLinkAccountViewController
@synthesize completionBlock, spinner;
@dynamic view;

+ (id) controllerWithCompletion:(IRDropletLinkAccountCompletion)block {

	return [[[self alloc] initWithCompletion:block] autorelease];

}

- (id) initWithCompletion:(IRDropletLinkAccountCompletion)block {

	self = [super init];
	if (!self)
		return nil;
	
	completionBlock = [block copy];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancel:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.spinner] autorelease];
	
	return self;

}

- (id) init {

	return [self initWithCompletion:nil];

}

- (void) dealloc {

	[completionBlock release];
	[spinner release];
	
	[super dealloc];

}

- (void) loadView {

	self.view = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
	self.view.scalesPageToFit = YES;
	self.view.delegate = self;
	
	DBSession * const dbs = [DBSession sharedSession];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.dropbox.com/1/connect?k=%@&s=%@", dbs.consumerKey, dbs.secret]];
	
	[self.view loadRequest:[NSURLRequest requestWithURL:url]];
	
	//	It is assumed that this view controller is extremely ephemeral
	//	…in sense that it never has to leave the screen before its job (ask the user to link) is done.

}

- (void) webViewDidStartLoad:(UIWebView *)webView {

	[self.spinner startAnimating];

}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

	[self.spinner stopAnimating];
	
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {

	[self.spinner stopAnimating];
	
	//	Hack around a viewport problem with modal form sheets with some ad-hoc JS array enumerator implementation
	//	In other words, facepalm (but this is such a common problem with UIWebView’s viewport handling as well?)
	
	[webView stringByEvaluatingJavaScriptFromString:@"(function(array, functor){ for (var idx = 0; idx < array.length; idx ++) { functor(idx, array[idx]); } })(document.querySelectorAll('meta[name*=viewport]'), function(idx, obj){ obj.setAttribute('content', 'width=100%'); });"];

}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	//	Intercept — if the request starts with `db`, it’s something bound to be consumed by the Dropbox SDK
	//	in that case, don’t load it
	
	NSURL *underlyingURL = [request URL];
	
	if ([[underlyingURL scheme] hasPrefix:@"db-"]) {
	
		//	We don’t even need to do the parsing, just trampoline it back to where it belongs
		//	NSString *query = [underlyingURL query];
		
		BOOL successful = [[DBSession sharedSession] handleOpenURL:underlyingURL];
		
		if (self.completionBlock)
			self.completionBlock(successful, nil);
	
		return NO;
	
	}

	return YES;

}

- (UIActivityIndicatorView *) spinner {

	if (spinner)
		return spinner;
	
	UIActivityIndicatorViewStyle style;
	
	switch ([UIDevice currentDevice].userInterfaceIdiom) {
		case UIUserInterfaceIdiomPad: {
			style = UIActivityIndicatorViewStyleGray;
			break;
		}
		case UIUserInterfaceIdiomPhone: {
			style = UIActivityIndicatorViewStyleWhite;
			break;
		}
	}
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	spinner.hidesWhenStopped = YES;
	
	return spinner;
	
}

- (void) handleCancel:(UIBarButtonItem *)sender {

	if (self.completionBlock)
		self.completionBlock(NO, nil);

}

- (UINavigationController *) wrappingNavigationController {

	if (self.navigationController)
		return self.navigationController;
	
	return [[[UINavigationController alloc] initWithRootViewController:self] autorelease];

}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	switch ([UIDevice currentDevice].userInterfaceIdiom) {
		case UIUserInterfaceIdiomPad: {
			return YES;
			break;
		}
		case UIUserInterfaceIdiomPhone: {
			return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
			break;
		}
	}

}

@end
