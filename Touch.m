//
//  Touch.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Touch.h"


@implementation Touch

@synthesize point;
@synthesize pressure;

+ (Touch *) touchWithPoint: (NSPoint) p timestamp: (NSDate * ) t
{
    return [[[Touch alloc] initWithPoint: p timestamp: t] autorelease];
}

- (Touch *) initWithPoint: (NSPoint) p timestamp: (NSDate * ) t
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    point = NSMakePoint(p.x/2, 400.0 - p.y/2);
    timestamp = [t retain];
    
    return self;
}

@end
