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
    
    // SQLite3 stores dates in ISO 8601 strings, so we have to parse them out
    NSDateFormatter * f = [[[NSDateFormatter alloc] init] autorelease];
    [f setTimeStyle: NSDateFormatterFullStyle];
    [f setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];

    NSMutableArray * inputs = [NSMutableArray array];
    while([rs next])
    {
        NSString * kind = [rs stringForColumn:@"kind"];
        NSString * data = [rs stringForColumn:@"data"];
        NSString * date = [rs stringForColumn:@"datetime"];
        NSDate * timestamp = [f dateFromString: date];
        
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
