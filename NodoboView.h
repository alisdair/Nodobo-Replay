//
//  NodoboView.h
//
//  Created by Alisdair McDiarmid on 30/07/2010.
//  Copyright 2010 Nodobo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Screen.h"
#import "Touch.h"

@interface NodoboView : NSView {
    Screen * screen;
    Touch * touch;
}

@property(retain) Screen * screen;
@property(retain) Touch * touch;

- (void) resizeWindow;

@end
