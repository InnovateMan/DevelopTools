//
//  StringUtil.m
//  i3-platform-sdk
//
//  Created by SunYu on 14-1-21.
//
//

#import "StringUtil.h"

@implementation StringUtil

+ (NSString *)uppercaseFirstChar:(NSString *)sourceString
{
    return [NSString stringWithFormat:@"%@%@",[[sourceString substringToIndex:1] uppercaseString],[sourceString substringWithRange:NSMakeRange(1, sourceString.length-1)]];
}

+ (NSString *)lowercaseFirstChar:(NSString *)sourceString
{
    return [NSString stringWithFormat:@"%@%@",[[sourceString substringToIndex:1] lowercaseString],[sourceString substringWithRange:NSMakeRange(1, sourceString.length-1)]];
}

@end
