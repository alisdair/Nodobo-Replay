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
#import "Touch.h"

@interface NodoboView : NSView {
    NSTextField * nowLabel;
    NSTextField * endLabel;
    Session * session;
    Screen * screen;
    Touch * touch;
    Interaction * thisInteraction;
    Interaction * nextInteraction;
    NSEnumerator * enumerator;
}

@property (assign) IBOutlet NSTextField * nowLabel;
@property (assign) IBOutlet NSTextField * endLabel;

- (void) setSession:(Session *) s;
- (void) resizeWindowForImage:(NSImage *)image;
- (void) setTimeIntervalLabel: (NSTextField *) label fromStart: (Interaction *) start toEnd: (Interaction *) end;
- (void) resetTimer: (NSTimer *) timer;
- (void) play;


@end
