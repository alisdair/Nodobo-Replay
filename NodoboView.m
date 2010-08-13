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
    CGFloat viewSize = MAX(imageSize.width, imageSize.height);
    
    CGFloat width = windowFrame.size.width - viewFrame.size.width + viewSize;
    CGFloat height = windowFrame.size.height - viewFrame.size.height + viewSize;
    
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
    
    CGFloat offset = (ABS(imageSize.height - imageSize.width))/2.0;
    NSAffineTransform * centre = [NSAffineTransform transform];
    [centre translateXBy: offset yBy: 0.0];
    [centre concat];
    
    [image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1];
    
    if (self.touch != nil)
    {
        NSRect fingerRect;
        CGFloat radius = 20.0;
        radius = radius * (self.touch.pressure / 50.0);
        
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
