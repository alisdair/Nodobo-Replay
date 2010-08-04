//
//  NodoboController.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 04/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboController.h"


@implementation NodoboController

@synthesize view;
@synthesize nowLabel;
@synthesize endLabel;

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    [enumerator release];
    enumerator = [[session.interactions objectEnumerator] retain];
    
    // Skip the start of the interactions until the first screen
    Screen * screen;
    for (screen in enumerator)
    {
        if (screen == nil || [screen isKindOfClass: [Screen class]])
            break;
    }
    view.screen = screen;
    
    thisInteraction = nil;
    nextInteraction = [screen retain];
    
    [view resizeWindow];
    
    // FIXME: this really doesn't seem like it should be here...
    Interaction * end = [session.interactions lastObject];
    [self setTimeIntervalLabel: endLabel fromStart: nextInteraction toEnd: end];
}

- (void) resetTimer: (NSTimer *) timer
{
    [thisInteraction release];
    thisInteraction = nextInteraction;
    nextInteraction = [[enumerator nextObject] retain];
    
    // Screen: update the main view display
    if ([thisInteraction isKindOfClass: [Screen class]])
    {
        view.screen = (Screen *) thisInteraction;
        [view setNeedsDisplay: YES];
    }
    // Touch: set up a touch to be displayed for a bit
    else if ([thisInteraction isKindOfClass: [Touch class]])
    {
        view.touch = (Touch *) thisInteraction;
        [view setNeedsDisplay: YES];
        [NSTimer scheduledTimerWithTimeInterval: 0.75 target: self
                                       selector: @selector(resetTouch:)
                                       userInfo: nil repeats: NO];
    }
    if (nextInteraction == nil)
    {
        [enumerator release];
    }
    else
    {
        NSTimeInterval i = [nextInteraction.timestamp timeIntervalSinceDate: thisInteraction.timestamp];
        i = MIN(2.0, i);
        [NSTimer scheduledTimerWithTimeInterval: i target: self
                                       selector: @selector(resetTimer:)
                                       userInfo: nil repeats: NO];
    }
    
    Interaction * start = [session.screens objectAtIndex: 0];
    [self setTimeIntervalLabel: nowLabel fromStart: start toEnd: thisInteraction];
}

- (void) resetTouch: (NSTimer *) timer
{
    view.touch = nil;
}

- (void) setTimeIntervalLabel: (NSTextField *) label
                    fromStart: (Interaction *) start
                        toEnd: (Interaction *) end
{
    NSTimeInterval interval = [end.timestamp timeIntervalSinceDate: start.timestamp];
    NSInteger minutes = (NSInteger) interval / 60;
    NSInteger seconds = (NSInteger) interval % 60;
    NSString * time = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    [label setStringValue: time];    
}

- (void) play
{
    [self resetTimer: nil];
}

- (void) dealloc
{
    [session release];
    [thisInteraction release];
    [nextInteraction release];
    [enumerator release];
    [super dealloc];
}

@end
