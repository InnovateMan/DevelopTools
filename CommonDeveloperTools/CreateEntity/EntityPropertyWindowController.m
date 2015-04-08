//
//  CreateEntityWindowController.m
//  i3-platform-sdk
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//

#import "EntityPropertyWindowController.h"

@interface EntityPropertyWindowController ()

@end

@implementation EntityPropertyWindowController
@synthesize table;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    

    NSTableColumn *classKey = [table tableColumnWithIdentifier:@"classKey"];
    NSTableColumn *classType = [table tableColumnWithIdentifier:@"classType"];
    NSTableColumn *className = [table tableColumnWithIdentifier:@"className"];
    
   
    [classKey bind:NSValueBinding
          toObject:self.arrayController
       withKeyPath:@"arrangedObjects.classKey"
           options:nil];
    [classType bind:NSValueBinding
           toObject:self.arrayController
        withKeyPath:@"arrangedObjects.classType"
            options:nil];
    [className bind:NSValueBinding
           toObject:self.arrayController
        withKeyPath:@"arrangedObjects.className"
            options:nil];
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)closeWindow:(id)sender
{
    [self.window close];
}
@end
