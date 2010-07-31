//
//  Frame.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Frame.h"

@implementation Frame

@synthesize path;
@synthesize timestamp;
@synthesize image;

+ (Frame *) frameWithPath: (NSString *) p
{
    return [[[Frame alloc] initWithPath: p] autorelease];
}

- (Frame *) initWithPath: (NSString *) p
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

- (NSString *) stringValue
{
    return @"Frame";
}

- (void) dealloc
{
    [path release];
    [timestamp release];
    [image release];
    [super dealloc];
}

@end
