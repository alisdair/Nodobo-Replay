//
//  TestFrame.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Frame.h"

@interface TestFrame : SenTestCase
{
    Frame * frame;
    NSString * path;
    NSDate * timestamp;
    NSDateFormatter * df;
}
@end

@implementation TestFrame

- (void) setUp
{
    path = @"/Users/alisdair/data/20100726142608.123456.png";
    timestamp = [[NSDate dateWithTimeIntervalSinceReferenceDate: 301843568.123456] retain];
    
    df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterFullStyle];
    [df setDateFormat:@"yyyyMMddHHmmss.SSS"];
    
    frame = [[Frame alloc] initWithPath: path];
    STAssertNotNil(frame, @"Could not create instance of frame.");
}

- (void) testPath
{
    STAssertNotNil([frame path], nil);
    STAssertEquals(path, [frame path], nil);
}

- (void) testTimestamp
{
    STAssertNotNil([frame timestamp], nil);

    NSTimeInterval knownTimeInterval = [timestamp timeIntervalSinceReferenceDate];
    NSTimeInterval frameTimeInterval = [[frame timestamp] timeIntervalSinceReferenceDate];
    STAssertEqualsWithAccuracy(knownTimeInterval, frameTimeInterval, 0.001, @"Timestamp '%.6d' should be '%.6d' to within 0.001", frameTimeInterval, knownTimeInterval);
    
    NSString * knownFormatted = [df stringFromDate: timestamp];
    NSString * frameFormatted = [df stringFromDate: [frame timestamp]];
    STAssertEqualObjects(knownFormatted, frameFormatted, nil);
    
}

- (void) testSetPath
{
    NSDate *oldTimestamp = [frame timestamp];

    NSString *newPath = @"/Users/alisdair/data/20100730221530.466342.png";
    [frame setPath: newPath];

    STAssertNotNil([frame path], nil);
    STAssertEquals(newPath, [frame path], nil);
    
    STAssertNotNil([frame timestamp], nil);
    STAssertTrue([frame timestamp] != oldTimestamp, nil);
}
                 
- (void) testBadPath
{
    [frame setPath: @"/Users/stephen/.secret/photos/naked-lady-with-big-boobs.png"];
    STAssertNotNil(frame, @"Could not create instance of frame.");
    STAssertNil([frame timestamp], nil);
}

- (void) tearDown
{
    [timestamp release];
    [df release];
    [frame release];
}
@end
