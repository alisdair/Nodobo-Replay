//
//  Clue.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Interaction.h"

@interface Clue : Interaction {
}

+ (NSArray *) cluesFromDatabaseAtPath: (NSString *) path;
+ (Clue *) clueWithKind: (NSString *) kind data: (NSString *) data timestamp: (NSDate * ) timestamp;

@end
