//
// Created by sunyu on 13-3-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSData (base64)

void *NewBase64Decode(
        const char *inputBuffer,
        size_t length,
        size_t *outputLength);

char *NewBase64Encode(
        const void *inputBuffer,
        size_t length,
bool separateLines,
        size_t *outputLength);
/*
 @method
 @author      sunyu
 @date        2013-3-22
 @description 从64位编码字符串转换为NSDATA
 @param       64位编码字符串
 @result      64位编码的NSDATA
 */
+ (NSData *)dataFromBase64String:(NSString *)aString;

/*
 @method
 @author      sunyu
 @date        2013-3-22
 @description 将传入的data进行64位编码
 @param
 @result      加密过后的字符串
 */
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi
/*
 @method
 @author      sunyu
 @date        2013-3-22
 @description 将字符串进行64位编码
 @param       是否用分割线
 @result      64位编码的字符串
 */
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end