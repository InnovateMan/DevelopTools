//
//  HandleCrashLog.m
//  CommonDeveloperTools
//
//  Created by frost on 15/5/20.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import "HandleCrashLog.h"
#import "FileSearch.h"

@interface HandleCrashLog ()

@property (nonatomic, strong) NSString *crashLogPath;

@end

@implementation HandleCrashLog

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (IBAction)changePathBtnClick:(NSButton *)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = NO;
    panel.canChooseFiles = YES;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result)
     {
         
         if(result == 0)
             return ;
         self.crashLogPath = [panel.URL path];
         
     }];
}

- (IBAction)beginHandle:(NSButton *)sender
{

    self.indicator.hidden = NO;
    [self.indicator startAnimation:nil];
    
    
    @autoreleasepool {
        NSString *home = self.crashLogPath;
        
        NSString *crashString = [NSString stringWithContentsOfFile:home encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *crashArrays = [crashString componentsSeparatedByString:@"\r\n"];
        NSMutableArray *resultArray = [NSMutableArray array];
        
        for (NSString *aCrash in crashArrays)
        {
            if ([aCrash containsString:@"6043093012"])
            {
                [resultArray addObject:resultArray];
            }
        }
        
        NSString *handleString = [resultArray componentsJoinedByString:@"\r\n"];
        
        NSString *newFile = [home stringByAppendingString:@"handle.txt"];
        
        [handleString writeToFile:newFile  atomically:YES encoding:4 error:nil];
    }
    
        
    
    [self.indicator startAnimation:nil];
    self.indicator.hidden = YES;
    
    
}

@end
