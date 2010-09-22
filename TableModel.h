//
//  TableModel.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 22/09/2010.
//  Copyright 2010 University of Strathclyde. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Session.h"
#import "Interaction.h"

@interface TableModel : NSObject {
    Session * session;
    NSTableView * tableView;
    Interaction * current;
}

@property(assign) IBOutlet NSTableView * tableView;

@property(retain) Interaction * current;

- (void) setSession: (Session *) s;

@end
