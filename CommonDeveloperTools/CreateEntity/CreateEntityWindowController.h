//
//  CreateEntityWindowController.h
//  i3-platform-sdk
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EntityPropertyWindowController.h"


@interface CreateEntityWindowController : NSWindowController
{
    NSString *_fileSavePath;

    NSDictionary *_dataTypeConfigDictionary;

    NSArrayController *array;

    EntityPropertyWindowController *propertyWindowController;
    
    
    NSMutableDictionary *rawVariablesMDic;
    
}
@property (nonatomic,retain) NSBundle *bundle;
@property (nonatomic,retain) IBOutlet NSTextView *mainContentTestView;
@property (nonatomic,retain) IBOutlet NSTextField *classNameField;


@property (assign) IBOutlet NSButton *checkBtn;
- (IBAction)generateClass:(id)sender;
- (IBAction)checkProperty:(id)sender;
- (IBAction)clearMainContent:(id)sender;
@end