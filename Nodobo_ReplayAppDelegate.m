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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[Session sessionWithPath: @"/Users/alisdair/Dropbox/AIOS/quirpbok2/"];
}

@end