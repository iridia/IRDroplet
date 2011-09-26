//
//  NSString+Dropbox.m
//  DropboxSDK
//
//  Created by Brian Smith on 7/19/10.
//  Copyright 2010 Dropbox, Inc. All rights reserved.
//

#import "NSString+Dropbox.h"


@implementation NSString (Dropbox)

- (NSString *) normalizedDropboxPath {
    if ([self isEqual:@"/"]) return @"";
    return [[self lowercaseString] precomposedStringWithCanonicalMapping];
}

- (BOOL) isEqualToDropboxPath:(NSString*)otherPath {
    return [[self normalizedDropboxPath] isEqualToString:[otherPath normalizedDropboxPath]];
}

- (NSString *) normalizedDropboxFilename {            
    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}

@end
