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

@synthesize enumerator;
@synthesize thisInteraction;
@synthesize nextInteraction;
@synthesize timer;

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    [self rewind];
}

- (void) rewind
{
    [self.timer invalidate];
    
    self.enumerator = [session.interactions objectEnumerator];
    
    // Skip the start of the interactions until the first screen
    Screen * screen;
    for (screen in enumerator)
    {
        if (screen == nil || [screen isKindOfClass: [Screen class]])
            break;
    }
    view.screen = screen;
    
    self.thisInteraction = nil;
    self.nextInteraction = screen;
    
    [view resizeWindow];
    
    // FIXME: this really doesn't seem like it should be here...
    Interaction * end = [session.interactions lastObject];
    [self setTimeIntervalLabel: endLabel fromStart: nextInteraction toEnd: end];
}

- (void) resetTimer: (NSTimer *) timer
{
    self.thisInteraction = self.nextInteraction;
    self.nextInteraction = [enumerator nextObject];
    
    // Screen: update the main view display
    if ([self.thisInteraction isKindOfClass: [Screen class]])
    {
        view.screen = (Screen *) self.thisInteraction;
        [view setNeedsDisplay: YES];
    }
    // Touch: set up a touch to be displayed for a bit
    else if ([self.thisInteraction isKindOfClass: [Touch class]])
    {
        view.touch = (Touch *) self.thisInteraction;
        [view setNeedsDisplay: YES];
        [NSTimer scheduledTimerWithTimeInterval: 0.75 target: self
                                       selector: @selector(resetTouch:)
                                       userInfo: nil repeats: NO];
    }
    if (self.nextInteraction == nil)
    {
        self.enumerator = nil;
    }
    else
    {
        NSTimeInterval i = [self.nextInteraction.timestamp timeIntervalSinceDate: self.thisInteraction.timestamp];
        i = MIN(2.0, i);
        self.timer = [NSTimer scheduledTimerWithTimeInterval: i target: self
                                                    selector: @selector(resetTimer:)
                                                    userInfo: nil repeats: NO];
    }
    
    Interaction * start = [session.screens objectAtIndex: 0];
    [self setTimeIntervalLabel: nowLabel fromStart: start toEnd: self.thisInteraction];
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
