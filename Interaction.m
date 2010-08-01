//
//  Interaction.m
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import "Interaction.h"

@implementation Interaction

@synthesize timestamp;

- (void) dealloc
{
    [timestamp release];
    [super dealloc];
}

@end
