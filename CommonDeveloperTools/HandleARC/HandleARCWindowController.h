//
//  HandleARCWindowController.h
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/2.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HandleARCWindowController : NSWindowController

@property (assign) IBOutlet NSTextField *pathTextField;

@property (assign) IBOutlet NSProgressIndicator *indicator;

- (IBAction)changePathBtnClick:(NSButton *)sender;

- (IBAction)beginHandle:(NSButton *)sender;

@end
