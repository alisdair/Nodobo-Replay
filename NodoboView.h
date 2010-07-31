//
//  NodoboView.h
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Session.h"
#import "Screen.h"

@interface NodoboView : NSView {
    Session * session;
    Screen * currentScreen;
    Screen * nextScreen;
    NSEnumerator * enumerator;
}

- (void) setSession:(Session *) s;
- (void) resizeWindowForImage:(NSImage *)image;
- (void) nextInteraction: (NSTimer *) timer;
- (void) play;

@end
