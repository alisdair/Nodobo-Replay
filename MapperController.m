//
//  MapperController.m
//
//  Created by Stephen Bell on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapperController.h"

@implementation MapperController

@synthesize mapView;
@synthesize session;
@synthesize locations;

- (void) setSession: (Session *) s
{
    [session autorelease];
    session = [s retain];
    
    NSPredicate * sp = [NSPredicate predicateWithFormat: @"class = %@", [Location class]];
    locations = [[self.session.interactions filteredArrayUsingPredicate: sp] retain];
    [self setHtmlFromTemplate];
}

- (void) setHtmlFromTemplate
{
    NSString * mapHtmlPath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    NSString * mapHtml = [NSString stringWithContentsOfFile:mapHtmlPath encoding:NSUTF8StringEncoding error:nil];
    [[self.mapView mainFrame] loadHTMLString:mapHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    id scriptObject = [self.mapView windowScriptObject];
    
    Location * firstLocation = [self.locations objectAtIndex:0];
    [scriptObject callWebScriptMethod:@"set_center" withArguments:[NSArray arrayWithObjects: firstLocation.latitude, firstLocation.longitude, nil]];

    if (!([frame.name rangeOfString:@"frame9"].location == NSNotFound))
    {
        for (Location * location in self.locations)
        {   
            [scriptObject callWebScriptMethod:@"create_marker" withArguments:[NSArray arrayWithObjects: location.latitude, location.longitude, nil]];
        }
        
    }
}

- (void) showMarkerAtLocation: (Location * ) location
{
    id scriptObject = [self.mapView windowScriptObject];
    [scriptObject callWebScriptMethod:@"show_marker" withArguments:[NSArray arrayWithObjects: location.latitude, location.longitude, nil]];

    NSLog(@"Show marker at location. Location data: %@", location.data);
}
    
@end
