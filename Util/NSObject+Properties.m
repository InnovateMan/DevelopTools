//
//  NSObject+Properties.m
//  SqlitePersisteObjectTest
//
//  Created by SunYu on 12/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Properties.h"

#import <Foundation/Foundation.h>   
#import <objc/runtime.h>   

@implementation NSObject (PropertyListing)   

- (NSDictionary *)properties_aps {   
    NSMutableDictionary *props = [NSMutableDictionary dictionary];   
    unsigned int outCount, i;   
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);   
    for (i = 0; i < outCount; i++) {   
        objc_property_t property = properties[i];   
        NSString *propertyName = [[[NSString alloc] initWithCString:property_getName(property)] autorelease];   
        id propertyValue = [self valueForKey:(NSString *)propertyName];   
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];   
    }   
    free(properties);   
    return props;   
}   



+ (NSDictionary *)getPropertys
{
    NSMutableArray* pronames = [NSMutableArray array];
    NSMutableArray* protypes = [NSMutableArray array];
    NSDictionary* props = [NSDictionary dictionaryWithObjectsAndKeys:pronames,@"name",protypes,@"type",nil];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [pronames addObject:propertyName];
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char
         i int
         l long
         s short
         d double
         f float
         @ id //指针 对象
         ...  BOOL 获取到的表示 方式是 char
         .... ^i 表示  int*  一般都不会用到
         */
        if ([propertyType hasPrefix:@"T@"]) {
            propertyType = [propertyType substringWithRange:NSMakeRange(3, [propertyType rangeOfString:@","].location-4)];
            [protypes addObject:propertyType];
        }
        if ([propertyType hasPrefix:@"Ti"]) {
            [protypes addObject:@"int"];
        }
        if ([propertyType hasPrefix:@"Tf"]) {
            [protypes addObject:@"float"];
        }
        NSLog(@"%@,%@",propertyName,propertyType);
        
    }
    free(properties);
    
    return props;
}



@end 