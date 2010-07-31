//
//  Frame.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Frame : NSObject {
    NSString * path;
    NSDate * timestamp;
    NSImage * image;
}

+ (Frame *) frameWithPath: (NSString *) p;
- (Frame *) initWithPath: (NSString *) p;

@property(copy) NSString * path;
@property(readonly) NSDate * timestamp;

@end
