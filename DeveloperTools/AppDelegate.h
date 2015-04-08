//
//  AppDelegate.h
//  CreateEntity
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CreateEntityWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{

    CreateEntityWindowController *createEntityWindowController;

}
@property (assign) IBOutlet NSWindow *window;


@end
