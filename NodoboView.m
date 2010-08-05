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
@synthesize rotated;

- (void) resizeWindow
{
    if (self.screen == nil || self.screen.image == nil)
        return;
    
    NSRect windowFrame = [[self window] frame];
    NSRect viewFrame = [self frame];
    NSSize imageSize = [self.screen.image size];
    if (rotated)
    {
        CGFloat t = imageSize.width;
        imageSize.width = imageSize.height;
        imageSize.height = t;
    }
    
    CGFloat max = MAX(imageSize.width, imageSize.height);
    imageSize = NSMakeSize(max, max);
    
    CGFloat width = windowFrame.size.width - viewFrame.size.width + imageSize.width;
    CGFloat height = windowFrame.size.height - viewFrame.size.height + imageSize.height;
    
    
    windowFrame = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y, width, height);
    
    [[self window] setFrame: windowFrame display: YES];
    [[self window] makeKeyAndOrderFront: self];
}

- (void) drawRect: (NSRect) rect
{
    if (self.screen == nil || self.screen.image == nil)
        return;
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];

    NSImage * image = self.screen.image;
    NSSize imageSize = [image size];

    if (rotated)
    {
        NSAffineTransform * rotate = [NSAffineTransform transform];
        [rotate translateXBy: imageSize.height yBy: 0.0];
        [rotate rotateByDegrees: 90.0];
        [rotate concat];
    }
    
    NSPoint origin = NSMakePoint((imageSize.height - imageSize.width)/2.0, 0.0);
    [image drawAtPoint: origin fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1];
    
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
    
    [context restoreGraphicsState];
}

- (void) dealloc
{
    self.screen = nil;
    self.touch = nil;
    [super dealloc];
}

@end
