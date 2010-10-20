//
//  MapperController.h
//
//  Created by Stephen Bell on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "Session.h"
#import "Location.h"

@interface MapperController : NSObject/* Specify a superclass (eg: NSObject or NSView) */ {
    WebView * mapView;
    Session * session;
    NSArray * locations;
}

@property(assign) IBOutlet WebView * mapView;

@property(retain) Session * session;
@property(readonly) NSArray * locations;

- (void) setSession: (Session * ) s;
- (void) setHtmlFromTemplate;
- (void) showMarkerAtLocation: (Location * ) location;

@end
