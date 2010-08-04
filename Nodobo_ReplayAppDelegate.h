//
//  Nodobo_ReplayAppDelegate.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodoboView.h"

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface Nodobo_ReplayAppDelegate : NSObject
#else
@interface Nodobo_ReplayAppDelegate : NSObject <NSApplicationDelegate>
#endif
{
    NSWindow *window;
    NodoboView *view;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NodoboView *view;

- (IBAction) runPanel: (id) sender;

@end
