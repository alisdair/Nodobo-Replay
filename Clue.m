//
//  Clue.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Clue.h"
#import "Touch.h"
#import "Orientation.h"
#import "Location.h"
#import "FMDatabase.h"

@implementation Clue

@synthesize kind;
@synthesize data;

+ (NSArray *) cluesFromDatabaseAtPath: (NSString *) path
{
    FMDatabase * db = [FMDatabase databaseWithPath: path];
    if (![db open])
    {
        NSLog(@"Error opening clues database: %@", [db lastErrorMessage]);
        return [NSArray array];        
    }

    FMResultSet * rs = [db executeQuery: @"SELECT * FROM clues;"];
    if ([db hadError])
    {
        NSLog(@"Error selecting clues: %@", [db lastErrorMessage]);
        return [NSArray array];        
    }

    NSMutableArray * clues = [NSMutableArray array];
    while([rs next])
    {
        NSString * kind = [rs stringForColumn:@"kind"];
        NSString * data = [rs stringForColumn:@"data"];
        long long msSince1970 = [rs longLongIntForColumn:@"datetime"];
        NSDate * timestamp = [NSDate dateWithTimeIntervalSince1970: msSince1970/1000.0];
        
        Clue * clue = [Clue clueWithKind: kind data: data timestamp: timestamp];
        if (clue != nil)
            [clues addObject: clue];
    }
    
    return [NSArray arrayWithArray: clues];
}

+ (Clue *) clueWithKind: (NSString *) kind data: (NSString *) data timestamp: (NSDate * ) timestamp
{
    if ([kind isEqualTo: @"touch"])
    {
        NSArray * coords = [data componentsSeparatedByString: @","];
        if ([coords count] < 2)
        {
            NSLog(@"Invalid touch found: data='%@', timestamp='%@'", data, timestamp);
            return nil;
        }
        CGFloat x = [[coords objectAtIndex: 0] floatValue];
        CGFloat y = [[coords objectAtIndex: 1] floatValue];
        CGFloat pressure = 50.0;
        if ([coords count] > 2)
            pressure = [[coords objectAtIndex:2] floatValue];
        NSPoint point = NSMakePoint(x, y);
        return [Touch touchWithPoint: point pressure: pressure timestamp: timestamp];
    }
    else if ([kind isEqualTo: @"orientation"])
    {
        return [Orientation orientationWithRotation: [data integerValue] timestamp: timestamp];
    }
    else if ([kind isEqualTo: @"location"])
    {
        NSArray * coords = [data componentsSeparatedByString: @","];
        if ([coords count] < 2)
        {
            NSLog(@"Invalid location found: data='%@', timestamp='%@'", data, timestamp);
        }
        NSString * lat = [NSString stringWithString:[coords objectAtIndex:0]];
        NSString * lon = [NSString stringWithString:[coords objectAtIndex:1]];
        Location * location = [Location locationWithLatitude: lat longitude: lon timestamp: timestamp];
        return location;
    }
    else
    {
        return [[[Clue alloc] initWithKind: kind data: data timestamp: timestamp] autorelease];
    }
}

- (NSString *) kind
{
    if (kind != nil)
        return kind;
    else
        return [super kind];
}

- (Clue *) initWithKind: (NSString *) k data: (NSString *) d timestamp: (NSDate * ) t
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    kind = [k retain];
    data = [d retain];
    timestamp = [t retain];
    
    return self;    
}

@end
