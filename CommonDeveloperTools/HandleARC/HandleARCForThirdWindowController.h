//
//  HandleARCForThirdWindowController.h
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/2.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import "HandleARCWindowController.h"

@interface HandleARCForThirdWindowController : NSWindowController
@property (assign) IBOutlet NSProgressIndicator *indicator;
@property (assign) IBOutlet NSTextField *thirdPartPath;
@property (assign) IBOutlet NSTextField *projectPath;
- (IBAction)changeProjectPath:(NSButton *)sender;

- (IBAction)changeThirPartPath:(NSButton *)sender;
- (IBAction)beginHandle:(NSButton *)sender;
@end
