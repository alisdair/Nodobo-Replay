//
//  NodoboView.h
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Session.h"
#import "Frame.h"

@interface NodoboView : NSView {
    Session * session;
    Frame * currentFrame;
    NSEnumerator * enumerator;
}

- (void) setSession:(Session *) s;
- (void) nextFrame: (NSTimer *) timer;
- (void) play;

@end
