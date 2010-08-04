//
//  NodoboView.m
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "NodoboView.h"

@implementation NodoboView

@synthesize screen;
@synthesize touch;

- (void) resizeWindow
{
    if (self.screen == nil || self.screen.image == nil)
        return;
    
    NSRect windowFrame = [[self window] frame];
    NSRect viewFrame = [self frame];
    NSSize imageSize = [self.screen.image size];
    CGFloat width = windowFrame.size.width - viewFrame.size.width + imageSize.width;
    CGFloat height = windowFrame.size.height - viewFrame.size.height + imageSize.height;
    windowFrame = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y, width, height);
    
    [[self window] setFrame: windowFrame display: YES];
    [[self window] center];
    [[self window] makeKeyAndOrderFront: self];
}

- (void) drawRect: (NSRect) rect
{
    if (self.screen == nil || self.screen.image == nil)
        return;
    NSImage * image = self.screen.image;
    [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    if (self.touch != nil)
    {
        NSRect fingerRect;
        CGFloat radius = 20.0;
        
        fingerRect.origin.x = self.touch.point.x - radius;
        fingerRect.origin.y = self.touch.point.y - radius;
        fingerRect.size.width = 2 * radius;
        fingerRect.size.height = 2 * radius;
        
        [[NSColor colorWithCalibratedRed: 1.0 green: 0.3 blue: 0.1 alpha: 0.5] set];
        
        [[NSBezierPath bezierPathWithOvalInRect: fingerRect] fill];
    }
}

- (void) dealloc
{
    self.screen = nil;
    self.touch = nil;
    [super dealloc];
}

@end
