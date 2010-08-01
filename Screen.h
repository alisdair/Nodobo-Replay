//
//  Screen.h
//  Nodobo Replay
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Interaction.h"


@interface Screen : Interaction {
    NSString * path;
    NSImage * image;
}

+ (Screen *) screenWithPath: (NSString *) p;
- (Screen *) initWithPath: (NSString *) p;

@property(readonly) NSString * path;
@property(readonly) NSImage * image;

@end
