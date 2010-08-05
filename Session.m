//
//  Session.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Session.h"
#import "Screen.h"
#import "Clue.h"


@implementation Session

@synthesize path;
@synthesize interactions;
@synthesize screens;

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
    screens = [Screen screensFromDirectoryAtPath: self.path];
    NSString * database = [self.path stringByAppendingPathComponent: @"clues.sqlite3"];
    NSArray * clues = [Clue cluesFromDatabaseAtPath: database];
    
    NSArray * merged = [screens arrayByAddingObjectsFromArray: clues];

    NSArray *sds = [NSArray arrayWithObject:
                    [[[NSSortDescriptor alloc] initWithKey: @"timestamp" ascending: YES] autorelease]];
    interactions = [[merged sortedArrayUsingDescriptors: sds] retain];
    
    NSPredicate * sp = [NSPredicate predicateWithFormat: @"class = %@", [Screen class]];
    screens = [[interactions filteredArrayUsingPredicate: sp] retain];
}


- (void) dealloc
{
    [path release];
    [interactions release];
    [screens release];
    [super dealloc];
}

@end
