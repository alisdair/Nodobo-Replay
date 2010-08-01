//
//  NodoboView.m
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboView.h"

@implementation NodoboView

@synthesize nowLabel;
@synthesize endLabel;

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    [enumerator release];
    enumerator = [[session.interactions objectEnumerator] retain];

    // Skip the start of the interactions until the first screen
    screen = nil;
    do {
        screen = [enumerator nextObject];
    } while (screen != nil && ![screen isKindOfClass: [Screen class]]);
    [screen retain];
    thisInteraction = nil;
    nextInteraction = [screen retain];
    
    if (screen != nil)
        [self resizeWindowForImage: screen.image];
    
    // FIXME: this really doesn't seem like it should be here...
    Interaction * start = [session.interactions objectAtIndex: 0];
    Interaction * end = [session.interactions objectAtIndex: [session.interactions count] - 1];
    [self setTimeIntervalLabel: endLabel fromStart: start toEnd: end];
}

- (void) resizeWindowForImage: (NSImage *) image
{
    NSRect windowFrame = [[self window] frame];
    NSRect viewFrame = [self frame];
    NSSize imageSize = [image size];
    CGFloat width = windowFrame.size.width - viewFrame.size.width + imageSize.width;
    CGFloat height = windowFrame.size.height - viewFrame.size.height + imageSize.height;
    windowFrame = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y, width, height);
    
    [[self window] setFrame: windowFrame display: YES];
    [[self window] center];
    [[self window] makeKeyAndOrderFront: self];
}

- (void) resetTimer: (NSTimer *) timer
{
    [thisInteraction release];
    thisInteraction = nextInteraction;
    nextInteraction = [[enumerator nextObject] retain];
    
    // Screen: update the main view display
    if ([thisInteraction isKindOfClass: [Screen class]])
    {
        [screen autorelease];
        screen = [thisInteraction retain];
        [self setNeedsDisplay: YES];
    }
    // TODO: if the interaction is a touch, set the touch ivar to the interaction.
    // Then setNeedsDisplay. Fix drawRect: to render this as an alpha-blended
    // circle or whatever, and draw nothing when nil. Set a timer for 0.5s to call
    // a method which resets the touch ivar to nil. That's it!
    
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
    
    Interaction * start = [session.interactions objectAtIndex: 0];
    [self setTimeIntervalLabel: nowLabel fromStart: start toEnd: thisInteraction];
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

- (void) drawRect: (NSRect) rect
{
    if (screen == nil || screen.image == nil)
        return;
    NSImage * image = screen.image;
    [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) dealloc
{
    [session release];
    [screen release];
    [thisInteraction release];
    [nextInteraction release];
    [enumerator release];
    [super dealloc];
}

@end
