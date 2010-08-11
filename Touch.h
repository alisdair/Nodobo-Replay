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
    CGFloat pressure;
}

@property(readonly) NSPoint point;
@property(readonly) CGFloat pressure;

+ (Touch *) touchWithPoint: (NSPoint) p pressure: (CGFloat) pr timestamp: (NSDate * ) t;
- (Touch *) initWithPoint: (NSPoint) p pressure: (CGFloat) pr timestamp: (NSDate * ) t;

@end
