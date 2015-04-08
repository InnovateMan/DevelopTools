//
//  EntityPropertyWindowController.h
//  i3-platform-sdk
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface EntityPropertyWindowController : NSWindowController
{
    NSString *path;
}
@property (assign) IBOutlet NSTableView *table;
@property(nonatomic,strong)  NSArrayController *arrayController;

- (IBAction)closeWindow:(id)sender;



@end
