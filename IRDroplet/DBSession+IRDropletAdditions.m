//
//  DBSession+IRDropletAdditions.m
//  IRDroplet
//
//  Created by Evadne Wu on 3/13/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import "DBSession+IRDropletAdditions.h"
#import "MPOAuth.h"


@interface DBSession (IRDropletPrivateAdditions)
@property (nonatomic, readonly, retain) NSDictionary *baseCredentials;
@end

@implementation DBSession (IRDropletAdditions)

- (NSString *) consumerKey {
	
	return [self.baseCredentials objectForKey:kMPOAuthCredentialConsumerKey];

}

- (NSString *) consumerSecret {

	return [self.baseCredentials objectForKey:kMPOAuthCredentialConsumerSecret];

}

- (NSString *) secret {

	NSData *consumerSecretData = [self.consumerSecret dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char md[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(consumerSecretData.bytes, [consumerSecretData length], md);
	NSUInteger sha_32 = htonl(((NSUInteger *)md)[CC_SHA1_DIGEST_LENGTH/sizeof(NSUInteger) - 1]);

	return [NSString stringWithFormat:@"%x", sha_32];

}

@end

@implementation DBSession (IRDropletPrivateAdditions)

- (NSDictionary *) baseCredentials {

	return (NSDictionary *)object_getIvar(self, object_getInstanceVariable(self, "baseCredentials", NULL));

}

@end
