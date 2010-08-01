//
//  Screen.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Screen.h"

@implementation Screen

@synthesize path;
@synthesize image;

+ (Screen *) screenWithPath: (NSString *) p
{
    return [[[Screen alloc] initWithPath: p] autorelease];
}

- (Screen *) initWithPath: (NSString *) p
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    // Copy path
    [path autorelease];
    path = [p copy];
    
    // Parse the timestamp from the filename
    NSString * filename = [[path lastPathComponent] stringByDeletingPathExtension];
    NSDateFormatter * f = [[[NSDateFormatter alloc] init] autorelease];
    [f setTimeStyle: NSDateFormatterFullStyle];
    [f setDateFormat: @"yyyyMMddHHmmss.SSS"];
    timestamp = [[f dateFromString:filename] retain];
    
    // Load the image
    image = [[NSImage alloc] initWithContentsOfFile: self.path];
    
    return self;
}

- (void) dealloc
{
    [path release];
    [image release];
    [super dealloc];
}

@end
