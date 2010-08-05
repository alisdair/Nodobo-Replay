//
//  Touch.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 01/08/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Clue.h"


@interface Touch : Clue {
    NSPoint point;
}

@property(readonly) NSPoint point;

+ (Touch *) touchWithPoint: (NSPoint) p timestamp: (NSDate * ) t;
- (Touch *) initWithPoint: (NSPoint) p timestamp: (NSDate * ) t;

@end
