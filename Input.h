//
//  Input.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Interaction.h"

@interface Input : Interaction {
}

+ (NSArray *) inputsFromDatabaseAtPath: (NSString *) path;
+ (Input *) inputWithKind: (NSString *) kind data: (NSString *) data timestamp: (NSDate * ) timestamp;

@end
