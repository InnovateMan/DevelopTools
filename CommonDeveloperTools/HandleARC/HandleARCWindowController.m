//
//  HandleARCWindowController.m
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/2.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import "HandleARCWindowController.h"

@interface HandleARCWindowController ()

@end

@implementation HandleARCWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.indicator.hidden = YES;
}


NSArray * serachARCFileInDir(NSString *filePath)
{
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        NSFileManager *manager;
        manager = [NSFileManager defaultManager];
        
        NSString *home = filePath;
        
        //将路径字符串传递给文件管理器
        NSDirectoryEnumerator *direnum;
        direnum = [manager enumeratorAtPath:home];
        
        //准备工作就绪 现在开始循环
        NSString *filename;
        while(filename = [direnum nextObject])
        {
            NSString *filePath = [home stringByAppendingPathComponent :filename];
            
            //如果文件的扩展名是 @"jpg" 添加到数组
            if([filename hasSuffix: @".m"])
            {
                NSString *string = [NSString stringWithContentsOfFile:filePath
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
                NSString *firstLine = [[string componentsSeparatedByString:@"\n"] firstObject];
                
                if ([firstLine containsString:@"ARC"])
                {
                    [array addObject:[filename lastPathComponent]];
                }
            }
            else
            {
            }
        }
        
    }
    
    return array;
    
}

NSArray * serarceFileArray(NSString *home,NSString *fileExt)
{
    NSMutableArray *files = [NSMutableArray array];
    
    @autoreleasepool {
        NSFileManager *manager;
        manager = [NSFileManager defaultManager];
        
        //将路径字符串传递给文件管理器
        NSDirectoryEnumerator *direnum;
        direnum = [manager enumeratorAtPath:home];
        
        //准备工作就绪 现在开始循环
        NSString *filename;
        while(filename = [direnum nextObject])
        {
            NSString *filePath = [home stringByAppendingPathComponent :filename];
            //如果文件的扩展名是 @"jpg" 添加到数组
            if([filename hasSuffix: fileExt])
            {
                [files addObject:filePath];
            }
        }
    }
    return files;
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
        NSArray *files = serachARCFileInDir(home);
        NSLog(@"找到ARCfile %lu 个！！",(unsigned long)[files count]);
        
        NSEnumerator *filenum;
        NSString *filename;
        NSArray *projectPathArray = serarceFileArray(home, @"project.pbxproj");
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
