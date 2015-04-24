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
	
	if (_arcWindowController)
	{
		[_arcWindowController release];
	}
	
	if (_arcForThirdWindowController)
	{
		[_arcForThirdWindowController release];
	}
    
    if (createEntityWindowController)
    {
        [createEntityWindowController release];
    }
    if (_mrcWindowController)
    {
        [_mrcWindowController release];
    }

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

- (IBAction)addARCConfig:(id)sender 
{
	if (!_arcWindowController)
	{
		_arcWindowController = [[HandleARCWindowController alloc] initWithWindowNibName:@"HandleARCWindowController"];
		
	}
	
	[[_arcWindowController window] makeKeyAndOrderFront:nil];
}


- (IBAction)addARCConfigForThirdPart:(id)sender 
{
	if (!_arcForThirdWindowController)
	{
		_arcForThirdWindowController = [[HandleARCForThirdWindowController alloc] initWithWindowNibName:@"HandleARCForThirdWindowController"];
	}
	[[_arcForThirdWindowController window] makeKeyAndOrderFront:nil];
	
}

- (IBAction)addMrcConfig:(id)sender
{
 
        if (!_mrcWindowController)
        {
            _mrcWindowController = [[HandleMRCWindowController alloc] initWithWindowNibName:@"HandleMRCWindowController"];
        }
        [[_mrcWindowController window] makeKeyAndOrderFront:nil];
}

@end
