//
//  HandleCrashLog.h
//  CommonDeveloperTools
//
//  Created by frost on 15/5/20.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HandleCrashLog : NSWindowController

@property (assign) IBOutlet NSTextField *pathTextField;

@property (assign) IBOutlet NSProgressIndicator *indicator;

- (IBAction)changePathBtnClick:(NSButton *)sender;

- (IBAction)beginHandle:(NSButton *)sender;

@end
