//
//  FileSearch.m
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/24.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import "FileSearch.h"

@implementation FileSearch



+ (NSArray *) fileArrayInDir:(NSString *)filePath
{
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool
    {
        NSFileManager *manager;
        manager = [NSFileManager defaultManager];
        
        NSString *home = filePath;
        
        //将路径字符串传递给文件管理器
        NSDirectoryEnumerator *direnum;
        direnum = [manager enumeratorAtPath:home];
        
        //准备工作就绪 现在开始循环
        NSString *filename;
        filename = [direnum nextObject];
        while(filename)
        {
            NSString *path = [home stringByAppendingPathComponent:filename];
            
            //如果文件的扩展名是 @"jpg" 添加到数组
            if([filename hasSuffix: @".m"])
            {
                NSString *string = [NSString stringWithContentsOfFile:path
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
            filename = [direnum nextObject];
        }
        
    }
    
    return array;
    
}



+ (NSArray *)fileArrayInDir:(NSString *)home withExt: (NSString *)fileExt
{
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

@end
