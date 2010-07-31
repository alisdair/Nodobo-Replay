//
//  Session.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Session.h"


@implementation Session

+ (Session *) sessionWithPath: (NSString *) p
{
    return [[[Session alloc] initWithPath: p] autorelease];
}

- (Session *) initWithPath: (NSString *) p
{
    self.path = p;
    
    return self;
}

@synthesize path;

- (void) setPath:(NSString *)p
{
    path = [p copy];
    
    [self readInteractions];
}

- (void) readInteractions
{
    NSFileManager *fm = [[[NSFileManager alloc] init] autorelease];
    
    interactions = [[NSArray alloc] init];
    
    // Verify that path is a directory
    BOOL isDir;
    
    if ([fm fileExistsAtPath: path isDirectory: &isDir] && isDir)
    {
        // Find all PNG files in directory
        // Create a Frame for each PNG, store in interactions
        
        // Open context.sqlite3
        // Create a ContextEvent for each record, store in interactions
        
        // Open interactions.sqlite3
        // Create an InteractionEvent for each record, store in interactions
        
        // Sort interactions by timestamp        
    }
}


- (void) dealloc
{
    [path release];
    [interactions release];
    [super dealloc];
}

@end
