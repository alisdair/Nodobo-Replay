//
//  Session.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Session.h"
#import "Frame.h"


@implementation Session

@synthesize path;
@synthesize interactions;
@synthesize frames;

+ (Session *) sessionWithPath: (NSString *) p
{
    return [[[Session alloc] initWithPath: p] autorelease];
}

- (Session *) initWithPath: (NSString *) p
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    [path autorelease];
    path = [p copy];
    
    [self readInteractions];
    
    return self;
}

- (void) readInteractions
{
    NSFileManager *fm = [[[NSFileManager alloc] init] autorelease];
    
    NSMutableArray * mInteractions = [NSMutableArray array];
    
    BOOL isDir;
    
    if ([fm fileExistsAtPath: self.path isDirectory: &isDir] && isDir)
    {
        // Frames
        NSArray * files = [fm contentsOfDirectoryAtPath: self.path error: NULL];
        NSPredicate * pngPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"];
        NSArray * pngFiles = [files filteredArrayUsingPredicate: pngPredicate];
        
        for (NSString * file in pngFiles)
        {
            Frame * frame = [Frame frameWithPath: [self.path stringByAppendingPathComponent: file]];
            
            // Only use frames with a timestamp
            if (frame.timestamp != nil)
            {
                [mInteractions addObject: frame];
            }
        }
        
        // Open context.sqlite3
        // Create a Context for each record, store in interactions
        
        // Open interactions.sqlite3
        // Create an Input for each record, store in interactions
        
        // Sort then filter into multiple arrays
        NSArray *sds = [NSArray arrayWithObject:
                        [NSSortDescriptor sortDescriptorWithKey: @"timestamp" ascending: YES]];
        interactions = [[mInteractions sortedArrayUsingDescriptors: sds] retain];
        
        NSPredicate * fp = [NSPredicate predicateWithFormat: @"class = %@", [Frame class]];
        frames = [[interactions filteredArrayUsingPredicate: fp] retain];
        
#ifndef NDEBUG
        for (id <Interaction> interaction in interactions)
        {
            NSLog(@"Interaction: %@ at %@", [interaction stringValue], interaction.timestamp);
        }
#endif
    }
    else
    {
        interactions = [[NSArray array] retain];
        frames = [[NSArray array] retain];
    }
}


- (void) dealloc
{
    [path release];
    [interactions release];
    [frames release];
    [super dealloc];
}

@end
