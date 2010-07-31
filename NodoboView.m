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
    enumerator = [[session.screens objectEnumerator] retain];

    currentScreen = nil;
    nextScreen = [[enumerator nextObject] retain];
    
    [self resizeWindowForImage: nextScreen.image];
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

- (void) nextInteraction: (NSTimer *) timer
{
    [currentScreen release];
    currentScreen = nextScreen;
    nextScreen = [[enumerator nextObject] retain];
    [self setNeedsDisplay: YES];
    
    if (nextScreen == nil)
    {
        [enumerator release];
        [nextLabel setStringValue: @"-"];
        [screenLabel setStringValue: @"Done"];
    }
    else
    {
        NSTimeInterval i = [nextScreen.timestamp timeIntervalSinceDate: currentScreen.timestamp];
        [NSTimer scheduledTimerWithTimeInterval: i target: self
                                       selector: @selector(nextInteraction:)
                                       userInfo: nil repeats: NO];
        
        NSUInteger index = [session.screens indexOfObject: nextScreen];
        NSUInteger limit = [session.screens count];
        
        [nextLabel setStringValue: [NSString stringWithFormat: @"Next in %.2fs", i]];
        [screenLabel setStringValue: [NSString stringWithFormat: @"Screen %d/%d", index, limit]];
    }
}

- (void) play
{
    [self nextInteraction: nil];
}

- (void) drawRect: (NSRect) rect
{
    if (currentScreen == nil || currentScreen.image == nil)
        return;
    NSImage * image = currentScreen.image;
    [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) dealloc
{
    [session release];
    [currentScreen release];
    [enumerator release];
    [super dealloc];
}

@end
