//
//  NodoboView.m
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboView.h"
#import "Frame.h"

@implementation NodoboView

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    [enumerator release];
    enumerator = [[session.frames objectEnumerator] retain];
    [self nextFrame: nil];
    
    NSRect frame = [[self window] frame];
    NSSize size = [currentFrame.image size];
    frame = NSMakeRect(frame.origin.x, frame.origin.y, size.width, size.height);
    
    [[self window] setFrame: frame display: YES];
    [[self window] center];
    [[self window] makeKeyAndOrderFront: self];
}

- (void) nextFrame: (NSTimer *) timer
{
    [currentFrame autorelease];
    currentFrame = [[enumerator nextObject] retain];
    if (currentFrame == nil)
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
    [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(nextFrame:)
                                   userInfo: nil repeats: YES];
}

- (void) drawRect: (NSRect) rect
{
    if (currentFrame == nil || currentFrame.image == nil)
        return;
    NSImage * image = currentFrame.image;
    [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) dealloc
{
    [session release];
    [currentFrame release];
    [enumerator release];
    [super dealloc];
}

@end
