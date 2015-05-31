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
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @autoreleasepool {
            NSString *home = self.crashLogPath;
            
            NSString *path = [home stringByAppendingString:@"_folder"];
            
        
            //解析整个crash log日志,分成单条日志
            NSArray *crashArrays = nil;
 
            NSString *crashString = [NSString stringWithContentsOfFile:home encoding:NSUTF8StringEncoding error:nil];
            crashArrays = [crashString componentsSeparatedByString:@"\n"];

            
            // 解析想要的版本的crash日志
            NSArray *versions = @[@"460",@"461",@"470"];       //添加想要的版本号到此即可.如：470
            NSMutableDictionary *resultDiction = [NSMutableDictionary dictionary];
            for (NSString *version in versions)
            {
                [resultDiction setObject:[NSMutableArray array] forKey:version];
            }

            // 按版本分开
            for (NSString *aCrash in crashArrays)
            {
                [resultDiction enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray * obj, BOOL *stop)
                {
                    NSString *fromValue = [NSString stringWithFormat:@"60%@93012",key];
                    if ([aCrash containsString:fromValue])
                    {
                        NSString *resultString = [aCrash stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                        [obj addObject:resultString];
                        *stop = YES;
                    }
                }];
            }
            
            // 提起crash
            [resultDiction enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray * obj, BOOL *stop)
             {
                 [self handleCrashLogs:obj forVersion:key withHomePath:path];
             }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSAlert *alert = [NSAlert alertWithMessageText:@"Complete" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Complete"];
            NSUInteger action = [alert runModal];
        });
    });
}

- (NSArray*)getFromValueArrayFromVersionArray:(NSArray*)versionArray
{
    NSMutableArray *fromValueArray = [NSMutableArray array];
    for (NSString *version in versionArray)
    {
        [fromValueArray addObject:[NSString stringWithFormat:@"60%@93012",version]];
    }
    return fromValueArray;
}

- (void)handleCrashLogs:(NSMutableArray*)crashLogs forVersion:(NSString*)version withHomePath:(NSString*)homePath
{
    if ([crashLogs count] > 0 && [version length] > 0 && [homePath length] > 0)
    {
        // 保证路径存在
        NSString *newPath = [homePath stringByAppendingPathComponent:version];
        [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        // 保存整体crash log
        [self saveCrashLogs:crashLogs forVersion:version withHomePath:newPath withSaveName:@"all"];
        
        // 分crash类型保存
        NSMutableArray *resultSVP = [NSMutableArray array];
        NSMutableArray *resultFeed = [NSMutableArray array];
        NSMutableArray *resultSogou = [NSMutableArray array];
        NSMutableArray *resultFixed = [NSMutableArray array];
        for (NSString *aCrash in crashLogs)
        {
            if ([aCrash containsString:@"SVPPlayerController"] || [aCrash containsString:@"AVPlayerItem"] || [aCrash containsString:@"AVPlayer"])
            {
                [resultSVP addObject:aCrash];
            }
            else if ([aCrash containsString:@"BaseDataSource"] || [aCrash containsString:@"NewsBaseViewController"])
            {
                [resultFeed addObject:aCrash];
            }
            else if ([aCrash containsString:@"SogouInput"])
            {
                [resultSogou addObject:aCrash];
            }
            else if ([aCrash containsString:@"preloadSibling"] || [aCrash containsString:@"offlineDidGetAbstractsList"] || [aCrash containsString:@"Supported orientations"] || [aCrash containsString:@"contains NaN"] || [aCrash containsString:@"SNLMatchLive setTeamA"])
            {
                //已经解决
                [resultFixed addObject:aCrash];
            }
        }
        
        // 其它crash类型
        NSMutableArray *resultOther = [NSMutableArray arrayWithArray:crashLogs];
        [resultOther removeObjectsInArray:resultSVP];
        [resultOther removeObjectsInArray:resultFeed];
        [resultOther removeObjectsInArray:resultSogou];
        [resultOther removeObjectsInArray:resultFixed];
        
        //其它
        [self saveCrashLogs:resultOther forVersion:version withHomePath:newPath withSaveName:@"其他"];
        
        //SVP
        [self saveCrashLogs:resultSVP forVersion:version withHomePath:newPath withSaveName:@"视频"];
        
        //Feed
        [self saveCrashLogs:resultFeed forVersion:version withHomePath:newPath withSaveName:@"feed"];
        
        //Sogou
        [self saveCrashLogs:resultSogou forVersion:version withHomePath:newPath withSaveName:@"输入法"];
        
        //已解决
        [self saveCrashLogs:resultFixed forVersion:version withHomePath:newPath withSaveName:@"已解决"];
    }

}

- (void)saveCrashLogs:(NSMutableArray*)crashLogs forVersion:(NSString*)version withHomePath:(NSString*)homePath withSaveName:(NSString*)name
{
    if ([crashLogs count] > 0 && [version length] > 0 && [homePath length] > 0)
    {
        NSMutableArray *writeLogs = [NSMutableArray arrayWithArray:crashLogs];
        NSString * totalCount = [NSString stringWithFormat:@"Version Number:%@.  Total Crash Count is:%ld",version,[writeLogs count]];
        [writeLogs insertObject:totalCount atIndex:0];
        
        NSString *handledString = [writeLogs componentsJoinedByString:@"\n"];
        NSString *newFilePath = [homePath stringByAppendingFormat:@"/%@.txt",name];
        [handledString writeToFile:newFilePath  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

@end
