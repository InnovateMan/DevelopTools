//
//  AppDelegate.m
//  CreateEntity
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//

#import "AppDelegate.h"
#import "CreateEntityWindowController.h"
@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [createEntityWindowController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)openCreateEntityView:(id)sender 
{
    if (!createEntityWindowController) 
    {
        createEntityWindowController = [[CreateEntityWindowController alloc] initWithWindowNibName:@"CreateEntityWindowController"];
		createEntityWindowController.bundle = [NSBundle mainBundle];
    }
    
    [[createEntityWindowController window] makeKeyAndOrderFront:nil];

  
}


@end
