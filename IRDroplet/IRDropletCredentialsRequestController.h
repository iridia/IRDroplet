//
//  IRDropletCredentialsRequestController.h
//  IRDroplet
//
//  Created by Evadne Wu on 8/31/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRDropletCredentialsRequestController : UINavigationController

+ (id) controllerWithCompletionBlock:(void(^)(BOOL didAuthenticate))aBlock;

@end
