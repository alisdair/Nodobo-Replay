//
//  Session.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Session : NSObject {
    NSString * path;
    NSArray * interactions;
}

@property(copy) NSString * path;

+ (Session *) sessionWithPath: (NSString *) p;
- (Session *) initWithPath: (NSString *) p;
- (void) readInteractions;

@end
