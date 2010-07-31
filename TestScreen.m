//
//  TestScreen.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Screen.h"

@interface TestScreen : SenTestCase
{
    Screen * screen;
    NSString * path;
    NSDate * timestamp;
    NSDateFormatter * df;
}
@end

@implementation TestScreen

- (void) setUp
{
    path = @"/Users/alisdair/data/20100726142608.123456.png";
    timestamp = [[NSDate dateWithTimeIntervalSinceReferenceDate: 301843568.123456] retain];
    
    df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterFullStyle];
    [df setDateFormat:@"yyyyMMddHHmmss.SSS"];
    
    screen = [[Screen screenWithPath: path] retain];
    STAssertNotNil(screen, @"Could not create instance of screen.");
}

- (void) testPath
{
    STAssertNotNil([screen path], nil);
    STAssertEquals(path, [screen path], nil);
}

- (void) testTimestamp
{
    STAssertNotNil([screen timestamp], nil);

    NSTimeInterval knownTimeInterval = [timestamp timeIntervalSinceReferenceDate];
    NSTimeInterval screenTimeInterval = [[screen timestamp] timeIntervalSinceReferenceDate];
    STAssertEqualsWithAccuracy(knownTimeInterval, screenTimeInterval, 0.001, @"Timestamp '%.6d' should be '%.6d' to within 0.001", screenTimeInterval, knownTimeInterval);
    
    NSString * knownFormatted = [df stringFromDate: timestamp];
    NSString * screenFormatted = [df stringFromDate: [screen timestamp]];
    STAssertEqualObjects(knownFormatted, screenFormatted, nil);
    
}

- (void) testBadPath
{
    path = @"/Users/stephen/.secret/photos/naked-lady-with-big-boobs.png";
    [screen release];
    screen = [[Screen screenWithPath: path] retain];
    STAssertNotNil(screen, @"Could not create instance of screen.");
    STAssertNil([screen timestamp], nil);
}

- (void) tearDown
{
    [timestamp release];
    [df release];
    [screen release];
}
@end
