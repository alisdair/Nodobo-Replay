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

+ (Frame *) frameWithPath: (NSString *) p
{
    return [[[Frame alloc] initWithPath: p] autorelease];
}

- (Frame *) initWithPath: (NSString *) p
{
    self.path = p;
    
    return self;
}

- (void) setPath:(NSString *) p
{
    path = [p copy];
    
    NSString * filename = [[path lastPathComponent] stringByDeletingPathExtension];
    
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setTimeStyle: NSDateFormatterFullStyle];
    [f setDateFormat: @"yyyyMMddHHmmss.SSS"];
    
    timestamp = [[f dateFromString:filename] retain];
    
    [f release];
}

- (NSString *) stringValue
{
    return @"Frame";
}

@end
