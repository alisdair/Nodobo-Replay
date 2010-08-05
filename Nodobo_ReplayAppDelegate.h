//
//  Nodobo_ReplayAppDelegate.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodoboController.h"

@interface Nodobo_ReplayAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow * window;
    NodoboView * view;
    NodoboController * controller;
}

@property(assign) IBOutlet NSWindow * window;
@property(assign) IBOutlet NodoboView * view;
@property(assign) IBOutlet NodoboController * controller;

- (IBAction) runPanel: (id) sender;

@end
