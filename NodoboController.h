//
//  NodoboController.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 04/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodoboView.h"
#import "Session.h"
#import "Interaction.h"
#import "Screen.h"
#import "Touch.h"

@interface NodoboController : NSObject {
    NodoboView * view;
    NSTextField * nowLabel;
    NSTextField * endLabel;

    Session * session;
    Interaction * thisInteraction;
    Interaction * nextInteraction;
    NSEnumerator * enumerator;    
}

@property (assign) IBOutlet NodoboView * view;
@property (assign) IBOutlet NSTextField * nowLabel;
@property (assign) IBOutlet NSTextField * endLabel;

@property (retain) NSEnumerator * enumerator;
@property (retain) Interaction * thisInteraction;
@property (retain) Interaction * nextInteraction;

- (void) setSession:(Session *) s;
- (void) rewind;
- (void) setTimeIntervalLabel: (NSTextField *) label fromStart: (Interaction *) start toEnd: (Interaction *) end;
- (void) resetTimer: (NSTimer *) timer;
- (void) play;

@end
