//
//  HandleARCWindowController.m
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/2.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import "HandleARCWindowController.h"
#import "NSString+Extension.h"
#import "FileSearch.h"
@interface HandleARCWindowController ()

@end

@implementation HandleARCWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.indicator.hidden = YES;
}



- (IBAction)changePathBtnClick:(NSButton *)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result)
     {
         
         if(result == 0)
             return ;
         self.pathTextField.stringValue = [panel.URL path];
         
     }];
}

- (IBAction)beginHandle:(NSButton *)sender
{
    if (!self.indicator.hidden)
    {
        return;
    }
    self.indicator.hidden = NO;
    [self.indicator startAnimation:nil];
    
    
    @autoreleasepool {
        NSString *home = self.pathTextField.stringValue;
        
        NSLog(@"home dir :%@",home);
        NSArray *files = [FileSearch fileArrayInDir:home];
        NSLog(@"找到ARCfile %lu 个！！",(unsigned long)[files count]);
        
        NSEnumerator *filenum;
        NSString *filename;
        NSArray *projectPathArray = [FileSearch fileArrayInDir:home withExt:@"project.pbxproj"];
        NSString *projectString;
        NSString *projectPath;
        
        
        //将路径字符串传递给文件管理器
        NSEnumerator *projectFileEnum = [projectPathArray objectEnumerator];

        projectPath = [projectFileEnum nextObject];
        while(projectPath)
        {
            
            projectString = [NSString stringWithContentsOfFile:projectPath
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
            filenum = [files objectEnumerator];
            filename=[filenum nextObject];
            while(filename)
            {
                NSString *findString = [NSString stringWithFormat: @"/* %@ in Sources */ = {isa = PBXBuildFile; fileRef =",filename];
                
                NSRange range = [projectString rangeOfString:findString];
                NSString *temp = [NSString stringWithFormat:@"/* %@ */; ",filename];
                NSString *replaceString = [NSString stringWithFormat:@"/* %@ */; settings = {COMPILER_FLAGS = \"-fobjc-arc\";};",filename];
                
                if ([projectString rangeOfString:replaceString].length == 0 && range.length > 0)
                {
                    NSRange newRange = {range.location,[projectString length] - range.location};
                    projectString = [projectString stringByReplacingOccurrencesOfString:temp withString:replaceString options:0 range:newRange];
                }
                filename=[filenum nextObject];
            }
            [projectString writeToFile:projectPath  atomically:YES encoding:4 error:nil];


            projectPath = [projectFileEnum nextObject];
        }
        
        
    }
    
    [self.indicator startAnimation:nil];
    self.indicator.hidden = YES;
    

}
@end
