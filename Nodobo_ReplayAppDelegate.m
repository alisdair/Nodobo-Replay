//
//  Nodobo_ReplayAppDelegate.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Nodobo_ReplayAppDelegate.h"
#import "Session.h"

@implementation Nodobo_ReplayAppDelegate

@synthesize window;
@synthesize view;
@synthesize controller;
@synthesize tableModel;

- (void) applicationDidFinishLaunching: (NSNotification *) notification
{
    [self runPanel: self];
}

- (IBAction) runPanel: (id) sender
{
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles: NO];
    [panel setCanChooseDirectories: YES];
    [panel setAllowsMultipleSelection: NO];
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelCancelButton)
        return;
    
    NSArray * urls = [panel URLs];
	Session * session = [Session sessionWithPath: [[urls lastObject] path]];
    [controller setSession: session];
    [tableModel setSession: session];
    [controller play: nil];
    [view resizeWindow];
    [window center];
}

@end
