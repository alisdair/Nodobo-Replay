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
    NSString * kind;
    NSString * data;
}

@property(retain) NSString * kind;
@property(retain) NSString * data;

+ (NSArray *) cluesFromDatabaseAtPath: (NSString *) path;
+ (Clue *) clueWithKind: (NSString *) kind data: (NSString *) data timestamp: (NSDate * ) timestamp;
- (Clue *) initWithKind: (NSString *) k data: (NSString *) d timestamp: (NSDate * ) t;

@end
