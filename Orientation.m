//
//  Orientation.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 05/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Orientation.h"


@implementation Orientation

@synthesize rotation;

+ (Orientation * ) orientationWithRotation: (NSUInteger) r timestamp: (NSDate *) t
{
    return [[[Orientation alloc] initWithRotation: r timestamp: t] autorelease];
}

- (Orientation * ) initWithRotation: (NSUInteger) r timestamp: (NSDate *) t
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    rotation = r;
    timestamp = [t retain];
    
    return self;
}

@end
