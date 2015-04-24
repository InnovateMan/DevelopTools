//
//  FileSearch.h
//  CommonDeveloperTools
//
//  Created by Suny on 15/4/24.
//  Copyright (c) 2015年 CTTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSearch : NSObject
+ (NSArray *) fileArrayInDir:(NSString *)filePath;

+ (NSArray *)fileArrayInDir:(NSString *)home withExt: (NSString *)fileExt;
@end
