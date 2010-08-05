//
//  Orientation.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 05/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Clue.h"

@interface Orientation : Clue {
    NSUInteger rotation;
}

@property(readonly) NSUInteger rotation;

+ (Orientation * ) orientationWithRotation: (NSUInteger) r timestamp: (NSDate *) t;
- (Orientation * ) initWithRotation: (NSUInteger) r timestamp: (NSDate *) t;

@end
