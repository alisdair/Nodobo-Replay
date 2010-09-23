//
//  TableModel.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 22/09/2010.
//  Copyright 2010 University of Strathclyde. All rights reserved.
//

#import "TableModel.h"


@implementation TableModel

@synthesize tableView;
@synthesize current;

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    [tableView reloadData];
}

- (void) setCurrent: (Interaction *) i
{
    [current autorelease];
    current = [i retain];
    
    NSUInteger index = [session.interactions indexOfObject: i];
    if (index == NSNotFound)
        return;
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex: index];
    [tableView selectRowIndexes: indexSet byExtendingSelection: NO];
    
    int rowsVisible = [tableView rowsInRect: [tableView visibleRect]].length;
    [tableView scrollRowToVisible: [tableView selectedRow] - rowsVisible / 2];
    [tableView scrollRowToVisible: [tableView selectedRow] + rowsVisible / 2];
}

- (id) tableView: (NSTableView *) tv objectValueForTableColumn: (NSTableColumn *) tc row: (int) ri
{
    if (session == nil)
        return nil;
    
    Interaction * interaction = [session.interactions objectAtIndex: ri];
    return [interaction performSelector: NSSelectorFromString([tc identifier])];
}

- (int) numberOfRowsInTableView: (NSTableView *) tv
{
    if (session == nil)
        return 0;
    
    return [session.interactions count];  
}


@end
