//
//  Nodobo_ReplayAppDelegate.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodoboController.h"
#import "TableModel.h"
#import "MapperController.h"

@interface Nodobo_ReplayAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow * window;
    NodoboView * view;
    NodoboController * controller;
    TableModel * tableModel;
    MapperController * mapperController;
}

@property(assign) IBOutlet NSWindow * window;
@property(assign) IBOutlet NodoboView * view;
@property(assign) IBOutlet NodoboController * controller;
@property(assign) IBOutlet TableModel * tableModel;
@property(assign) IBOutlet MapperController * mapperController;

- (IBAction) runPanel: (id) sender;

@end
