//
//  HandleARCForThirdWindowController.m
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/2.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import "HandleARCForThirdWindowController.h"

@interface HandleARCForThirdWindowController ()

@end

@implementation HandleARCForThirdWindowController



- (void)windowDidLoad
{
    [super windowDidLoad];
    self.indicator.hidden = YES;

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)changeProjectPath:(NSButton *)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result)
     {
         
         if(result == 0)
             return ;
         self.projectPath.stringValue = [panel.URL path];
         
     }];
}

- (IBAction)changeThirdPartPath:(NSButton *)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result)
     {
         
         if(result == 0)
             return ;
         self.thirdPartPath.stringValue = [panel.URL path];
         
     }];
}


- (NSArray *)serarchFileArrayFromHome:(NSString *)home extString:(NSString *)fileExt
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    
    @autoreleasepool
    {
        NSFileManager *manager;
        manager = [NSFileManager defaultManager];
        
        //将路径字符串传递给文件管理器
        NSDirectoryEnumerator *direnum;
        direnum = [manager enumeratorAtPath:home];
        
        //准备工作就绪 现在开始循环
        NSString *filename;
        filename = [direnum nextObject];
        while(filename)
        {
            NSString *filePath = [home stringByAppendingPathComponent :filename];
            
            if([filename hasSuffix: fileExt])
            {
                [files addObject:filePath];
            }
            filename = [direnum nextObject];
        }
    }
    return files;
    
}

- (IBAction)beginHandle:(NSButton *)sender
{
    if ([self.thirdPartPath.stringValue length] == 0 ||
        [self.projectPath.stringValue length] == 0 )
    {
        return;
    }
    
    self.indicator.hidden = NO;
    [self.indicator startAnimation:nil];
    
    
    @autoreleasepool {
        NSString *home = self.thirdPartPath.stringValue;
        
        NSLog(@"home dir :%@",home);
        
        
        NSMutableArray *files = [NSMutableArray array];
        
        @autoreleasepool
        {
            NSFileManager *manager;
            manager = [NSFileManager defaultManager];
            
            //将路径字符串传递给文件管理器
            NSDirectoryEnumerator *direnum;
            direnum = [manager enumeratorAtPath:home];
            
            //准备工作就绪 现在开始循环
            NSString *filename;
            filename = [direnum nextObject];
            while(filename)
            {
//                NSString *filePath = [home stringByAppendingPathComponent :filename];
                [files addObject:[filename lastPathComponent]];
                filename = [direnum nextObject];
            }
        }
        
        
        NSEnumerator *filenum;
        NSString *filename;
//        NSArray *projectPathArray = serarchFileArray(self.projectPath.stringValue, @"project.pbxproj");
        
        NSArray *projectPathArray =  [self serarchFileArrayFromHome:self.projectPath.stringValue
                                                            extString: @"project.pbxproj"];
        
        if ([projectPathArray count] == 0)
        {
            [self.indicator startAnimation:nil];
            self.indicator.hidden = YES;
            
            NSAlert *alert = [NSAlert alertWithMessageText:@"未找到指定的工程文件"
                                             defaultButton:nil
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@""];
            [alert runModal];
            
            return;
        }
        
        NSString *projectString;
        NSString *projectPath;
        
        
        //将路径字符串传递给文件管理器
        NSEnumerator *projectFileEnum = [projectPathArray objectEnumerator];
        
        while(projectPath = [projectFileEnum nextObject])
        {
            
            projectString = [NSString stringWithContentsOfFile:projectPath
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
            filenum = [files objectEnumerator];
            while(filename=[filenum nextObject])
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
            }
            [projectString writeToFile:projectPath  atomically:YES encoding:4 error:nil];

        }
  
    }
    
    [self.indicator startAnimation:nil];
    self.indicator.hidden = YES;
 
}
@end
