//
//  NodoboController.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 04/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboController.h"
#import "Orientation.h"
#import "Location.h"


@implementation NodoboController

@synthesize view;
@synthesize nowLabel;
@synthesize endLabel;
@synthesize pause;
@synthesize slider;
@synthesize tableModel;
@synthesize mapperController;

@synthesize session;
@synthesize enumerator;
@synthesize thisInteraction;
@synthesize nextInteraction;
@synthesize timer;

- (void) setThisInteraction:(Interaction *) i
{
    [thisInteraction autorelease];
    thisInteraction = [i retain];
    
    self.tableModel.current = thisInteraction;
}


- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    [self setTimeLabel: endLabel
                 start: [(Screen * )[self.session.screens objectAtIndex: 0] timestamp]
                   end: [(Screen * )[self.session.screens lastObject] timestamp]];
}

- (void) rewind
{
    self.enumerator = [self.session.interactions objectEnumerator];
    view.screen = [self.session.screens objectAtIndex: 0];
    view.rotated = NO;
    view.touch = nil;
    
    // Skip the start of the interactions until the first screen
    for (Interaction * interaction in self.enumerator)
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
        [self rewind];
        [self pause: nil];
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

- (void) updateInteraction
{
    self.thisInteraction = self.nextInteraction;
    self.nextInteraction = [self.enumerator nextObject];
    
    if ([self.thisInteraction isKindOfClass: [Screen class]])
    {
        view.screen = (Screen *) self.thisInteraction;
    }
    else if ([self.thisInteraction isKindOfClass: [Touch class]])
    {
        view.touch = (Touch *) self.thisInteraction;
        [NSTimer scheduledTimerWithTimeInterval: 0.75 target: view
                                       selector: @selector(clearTouch:)
                                       userInfo: nil repeats: NO];
    }
    else if ([self.thisInteraction isKindOfClass: [Orientation class]])
    {
        Orientation * orientation = (Orientation *) self.thisInteraction;
        view.rotated = (orientation.rotation == 1);
        [view resizeWindow];
    }
    else if ([self.thisInteraction isKindOfClass: [Location class]])
    {
        [mapperController showMarkerAtLocation: (Location * ) self.thisInteraction];
    }
}

- (void) setTimeLabel: (NSTextField *) label start: (NSDate *) start end: (NSDate *) end
{
    NSTimeInterval interval = [end timeIntervalSinceDate: start];
    
    NSInteger minutes = (NSInteger) interval / 60;
    NSInteger seconds = (NSInteger) interval % 60;
    [label setStringValue: [NSString stringWithFormat:@"%02d:%02d", minutes, seconds]];
}

- (void) updateLabel
{
    [self setTimeLabel: nowLabel
                 start: [(Screen * )[self.session.screens objectAtIndex: 0] timestamp]
                   end: self.thisInteraction.timestamp];
}

- (void) updateSlider
{
    NSDate * start = [(Screen * )[self.session.screens objectAtIndex: 0] timestamp];
    NSDate * end = [(Screen * )[self.session.screens lastObject] timestamp];
    NSDate * now = self.thisInteraction.timestamp;
    NSTimeInterval total = [end timeIntervalSinceDate: start];
    NSTimeInterval interval = [now timeIntervalSinceDate: start];
    
    [self.slider setFloatValue: interval/total];
}

- (IBAction) scrub: (id) sender
{
    [self.timer invalidate];
    self.timer = nil;
    [self rewind];
    
    NSDate * start = [(Screen * )[self.session.screens objectAtIndex: 0] timestamp];
    NSDate * end = [(Screen * )[self.session.screens lastObject] timestamp];
    NSTimeInterval total = [end timeIntervalSinceDate: start];
    NSDate * now = [start dateByAddingTimeInterval: total * [self.slider floatValue]];
    
    BOOL rotated = view.rotated;
    while (self.nextInteraction != nil)
    {
        self.nextInteraction = [self.enumerator nextObject];
        
        if ([self.nextInteraction isKindOfClass: [Screen class]])
        {
            view.screen = (Screen *) self.nextInteraction;
        }
        if ([self.nextInteraction isKindOfClass: [Orientation class]])
        {
            Orientation * orientation = (Orientation *) self.nextInteraction;
            rotated = (orientation.rotation == 1);
        }
        if ([self.nextInteraction isKindOfClass: [Location class]])
        {
            Location * location = (Location * ) self.nextInteraction;
            NSLog(@"Location clue: %@, %@", location.latitude, location.longitude);
        }
        
        if ([self.nextInteraction.timestamp timeIntervalSinceDate: now] >= 0.0)
        {
            break;
        }
    }
    if (view.rotated != rotated)
        view.rotated = rotated;
    
    NSRect sliderFrame = [self.slider frame];
    NSRect oldFrame = [[view window] frame];
    [view resizeWindow];
    NSRect newFrame = [[view window] frame];
    
    if (newFrame.size.width != oldFrame.size.width)
    {
        CGFloat oldSliderWidth = sliderFrame.size.width;
        CGFloat newSliderWidth = newFrame.size.width - (oldFrame.size.width - sliderFrame.size.width);
        
        CGFloat oldSliderKnobX = sliderFrame.origin.x + oldSliderWidth * [self.slider floatValue];
        CGFloat newSliderKnobX = sliderFrame.origin.x + newSliderWidth * [self.slider floatValue];
        CGFloat deltaX = newSliderKnobX - oldSliderKnobX;
        
        newFrame.origin.x -= deltaX;
        [[view window] setFrameOrigin: newFrame.origin];
    }
    
    if ([[pause title] isEqual: @"Play"])
    {
        [self updateInteraction];
        [self updateLabel];
        [self updateSlider];
    }
    else
    {
        [self resetTimer: nil];
    }
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
