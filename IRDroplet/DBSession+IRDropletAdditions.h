//
//  DBSession+IRDropletAdditions.h
//  IRDroplet
//
//  Created by Evadne Wu on 3/13/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "DBSession.h"

@interface DBSession (IRDropletAdditions)

@property (nonatomic, readonly, retain) NSString *consumerKey;
@property (nonatomic, readonly, retain) NSString *consumerSecret;
@property (nonatomic, readonly, retain) NSString *secret;

@end
