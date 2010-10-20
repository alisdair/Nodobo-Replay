//
//  Location.h
//  Nodobo Replay
//
//  Created by Stephen Bell on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Clue.h"

@interface Location : Clue {
    NSString * latitude;
    NSString * longitude;
}

@property(readonly) NSString * latitude;
@property(readonly) NSString * longitude;

+ (Location * ) locationWithLatitude: (NSString * ) lat longitude: (NSString * ) lon timestamp: (NSDate * ) t;
- (Location * ) initWithLatitude: (NSString * ) lat longitude: (NSString * ) lon timestamp: (NSDate * ) t;

@end
