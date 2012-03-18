//
//  NSString+IRDropletAdditions.m
//  IRDroplet
//
//  Created by Evadne Wu on 3/19/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "NSString+IRDropletAdditions.h"

@implementation NSString (IRDropletAdditions)

- (NSString *) normalizedDropboxFilename {
	
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
	
}

@end
