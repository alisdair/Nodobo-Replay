//
//  NodoboController.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 04/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboController.h"
#import "Orientation.h"


@implementation NodoboController

@synthesize view;
@synthesize label;
@synthesize pause;
@synthesize slider;

@synthesize session;
@synthesize enumerator;
@synthesize thisInteraction;
@synthesize nextInteraction;
@synthesize timer;

- (void) rewind
{
    self.enumerator = [self.session.interactions objectEnumerator];
    view.screen = [self.session.screens objectAtIndex: 0];
    view.touch = nil;
    
    // Skip the start of the interactions until the first screen
    for (Interaction * interaction in enumerator)
        if (interaction == nil || interaction == view.screen)
            break;
    
    self.thisInteraction = nil;
    self.nextInteraction = view.screen;
}

- (IBAction) play: (id) sender
{
    [self.timer invalidate];
    self.timer = nil;
    [self.pause setTitle: @"Pause"];
    [self.pause setAction: @selector(pause:)];
    if (sender == nil)
        [self rewind];
    [self resetTimer: nil];
}

- (IBAction) pause: (id) sender
{
    [self.timer invalidate];
    self.timer = nil;
    [self.pause setTitle: @"Play"];
    [self.pause setAction: @selector(play:)];
}
- (void) resetTimer: (NSTimer *) timer
{
    [self updateInteraction];
    
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
        
    [self updateLabel];
    [self updateSlider];
}

- (void) resetTouch: (NSTimer *) timer
{
    view.touch = nil;
}

- (void) updateInteraction
{
    self.thisInteraction = self.nextInteraction;
    self.nextInteraction = [enumerator nextObject];
    
    // FIXME: there has got to be a better way to do this...
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
    else if ([self.thisInteraction isKindOfClass: [Orientation class]])
    {
        Orientation * orientation = (Orientation *) self.thisInteraction;
        
        if (orientation.rotation == 1)
            view.rotated = YES;
        else
            view.rotated = NO;
        
        [view resizeWindow];
        [view setNeedsDisplay: YES];
    }
}

- (void) updateLabel
{
    NSDate * start = [(Screen * )[self.session.screens objectAtIndex: 0] timestamp];
    NSDate * now = self.thisInteraction.timestamp;
    NSTimeInterval interval = [now timeIntervalSinceDate: start];
    
    NSInteger minutes = (NSInteger) interval / 60;
    NSInteger seconds = (NSInteger) interval % 60;
    [label setStringValue: [NSString stringWithFormat:@"%02d:%02d", minutes, seconds]];
}

- (void) updateSlider
{
    NSDate * start = [(Screen * )[self.session.screens objectAtIndex: 0] timestamp];
    NSDate * end = [(Screen * )[self.session.screens lastObject] timestamp];
    NSDate * now = self.thisInteraction.timestamp;
    NSTimeInterval total = [end timeIntervalSinceDate: start];
    NSTimeInterval interval = [now timeIntervalSinceDate: start];
    
    [slider setFloatValue: interval/total];
}

- (IBAction) scrub: (id) sender
{
    [self.timer invalidate];
    self.timer = nil;
    [self rewind];
    
    NSDate * start = [(Screen * )[self.session.screens objectAtIndex: 0] timestamp];
    NSDate * end = [(Screen * )[self.session.screens lastObject] timestamp];
    NSTimeInterval total = [end timeIntervalSinceDate: start];
    NSDate * now = [start dateByAddingTimeInterval: total * [slider floatValue]];
    
    while (self.nextInteraction != nil)
    {
        self.nextInteraction = [enumerator nextObject];
        
        if ([self.nextInteraction.timestamp timeIntervalSinceDate: now] >= 0.0)
        {
            break;
        }
    }
    
    if ([[pause title] isEqual: @"Play"])        
        [self updateInteraction];
    else
        [self resetTimer: nil];
}

- (void) dealloc
{
    [self.timer invalidate];
    self.session = nil;
    self.thisInteraction = nil;
    self.nextInteraction = nil;
    self.enumerator = nil;
    [super dealloc];
}

@end
