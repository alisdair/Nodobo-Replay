//
//  NodoboView.m
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboView.h"

@implementation NodoboView

@synthesize screenLabel;
@synthesize nextLabel;

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
        [nextLabel setStringValue: @"-"];
        [screenLabel setStringValue: @"Done"];
    }
    else
    {
        NSTimeInterval i = [[nextInteraction timestamp] timeIntervalSinceDate: [thisInteraction timestamp]];
        i = MIN(2.0, i);
        [NSTimer scheduledTimerWithTimeInterval: i target: self
                                       selector: @selector(resetTimer:)
                                       userInfo: nil repeats: NO];
        [nextLabel setStringValue: [NSString stringWithFormat: @"Next in %.2fs", i]];

        NSUInteger index = [session.screens indexOfObject: screen] + 1;
        NSUInteger limit = [session.screens count];
        
        [screenLabel setStringValue: [NSString stringWithFormat: @"Screen %d/%d", index, limit]];
    }
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
