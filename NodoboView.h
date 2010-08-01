//
//  NodoboView.h
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Session.h"
#import "Interaction.h"
#import "Screen.h"

@interface NodoboView : NSView {
    NSTextField * screenLabel;
    NSTextField * nextLabel;
    Session * session;
    Screen * screen;
    Interaction * thisInteraction;
    Interaction * nextInteraction;
    NSEnumerator * enumerator;
}

@property (assign) IBOutlet NSTextField * screenLabel;
@property (assign) IBOutlet NSTextField * nextLabel;

- (void) setSession:(Session *) s;
- (void) resizeWindowForImage:(NSImage *)image;
- (void) resetTimer: (NSTimer *) timer;
- (void) play;

@end
