//
//  Input.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Input.h"
#import "Touch.h"
#import "FMDatabase.h"

@implementation Input

+ (NSArray *) inputsFromDatabaseAtPath: (NSString *) path
{
    FMDatabase * db = [FMDatabase databaseWithPath: path];
    if (![db open])
    {
        NSLog(@"Error opening inputs database: %@", [db lastErrorMessage]);
        return [NSArray array];        
    }

    FMResultSet * rs = [db executeQuery: @"SELECT * FROM interactions;"];
    if ([db hadError])
    {
        NSLog(@"Error selecting inputs: %@", [db lastErrorMessage]);
        return [NSArray array];        
    }

    NSMutableArray * inputs = [NSMutableArray array];
    while([rs next])
    {
        NSString * kind = [rs stringForColumn:@"kind"];
        NSString * data = [rs stringForColumn:@"data"];
        long msSince1970 = [rs longForColumn:@"datetime"];
        NSDate * timestamp = [NSDate dateWithTimeIntervalSince1970: msSince1970/1000.0];
        
        Input * input = [Input inputWithKind: kind data: data timestamp: timestamp];
        if (input != nil)
            [inputs addObject: input];
    }
    
    return [NSArray arrayWithArray: inputs];
}

+ (Input *) inputWithKind: (NSString *) kind data: (NSString *) data timestamp: (NSDate * ) timestamp;
{
    if ([kind isEqualTo: @"touch"])
    {
        NSArray * coords = [data componentsSeparatedByString: @","];
        if ([coords count] != 2)
        {
            NSLog(@"Invalid touch found: data='%@', timestamp='%@'", data, timestamp);
            return nil;
        }
        CGFloat x = [[coords objectAtIndex: 0] floatValue];
        CGFloat y = [[coords objectAtIndex: 1] floatValue];
        NSPoint point = NSMakePoint(x, y);
        return [Touch touchWithPoint: point timestamp: timestamp];
    }
    
    return nil;
}
@end
