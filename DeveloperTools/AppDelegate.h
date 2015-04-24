//
//  AppDelegate.h
//  CreateEntity
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CreateEntityWindowController.h"
#import "HandleARCForThirdWindowController.h"
#import "HandleARCWindowController.h"
#import "HandleMRCWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{

    CreateEntityWindowController *createEntityWindowController;
	HandleARCWindowController    *_arcWindowController;
	HandleARCForThirdWindowController *_arcForThirdWindowController;
    HandleMRCWindowController *_mrcWindowController;


}
@property (assign) IBOutlet NSWindow *window;


@end
