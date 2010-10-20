//
//  Location.m
//  Nodobo Replay
//
//  Created by Stephen Bell on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize latitude;
@synthesize longitude;

+ (Location *) locationWithLatitude: (NSString * ) lat longitude: (NSString * ) lon timestamp: (NSDate * ) t
{
    return [[[Location alloc] initWithLatitude: lat longitude: lon timestamp: t] autorelease];
}

- (Location *) initWithLatitude: (NSString * ) lat longitude: (NSString * ) lon timestamp: (NSDate * ) t
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    [latitude autorelease];
    latitude = [lat copy];
    [longitude autorelease];
    longitude = [lon copy];
    timestamp = [t retain];
    
    return self;    
}

- (NSString * ) data
{
    return [NSString stringWithFormat: @"%@,%@", latitude, longitude];
}

@end
