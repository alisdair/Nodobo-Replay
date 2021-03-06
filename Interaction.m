//
//  Interaction.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Interaction.h"

@implementation Interaction

@synthesize timestamp;

- (void) dealloc
{
    [timestamp release];
    [super dealloc];
}

- (NSString *) preciseTimestamp
{
    NSDateFormatter * f = [[[NSDateFormatter alloc] init] autorelease];
    [f setDateFormat:@"HH:mm:ss.SSS"];
    return [f stringFromDate: self.timestamp];
}

- (NSString *) kind
{
    return [self className];
}

- (NSString *) data
{
    return nil;
}

@end
