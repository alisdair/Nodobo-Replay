//
//  Interaction.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 31/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol Interaction

- (NSString *) description;
- (NSDate *) timestamp;

@end
