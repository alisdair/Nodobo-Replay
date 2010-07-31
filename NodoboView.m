//
//  NodoboView.m
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboView.h"

@implementation NodoboView

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    [enumerator release];
    enumerator = [[session.screens objectEnumerator] retain];
    [self nextScreen: nil];
    
    NSRect frame = [[self window] frame];
    NSSize size = [currentScreen.image size];
    frame = NSMakeRect(frame.origin.x, frame.origin.y, size.width, size.height);
    
    [[self window] setFrame: frame display: YES];
    [[self window] center];
    [[self window] makeKeyAndOrderFront: self];
}

- (void) nextScreen: (NSTimer *) timer
{
    [currentScreen autorelease];
    currentScreen = [[enumerator nextObject] retain];
    if (currentScreen == nil)
    {
        [timer invalidate];        
        [enumerator release];
#ifndef NDEBUG
        NSLog(@"Stopped playing interactions");
#endif        
    }
    
    [self setNeedsDisplay: YES];
}

- (void) play
{
#ifndef NDEBUG
    NSLog(@"Playing interactions");
#endif
    [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(nextScreen:)
                                   userInfo: nil repeats: YES];
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
