//
//  NSString+Extension.m
//  i3-platform-sdk
//
//  Created by Sun Yu on 13-3-22.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Extension.h"

@implementation NSString (Extension)


- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b 
{
	NSRange r;
	r.location = a;
	r.length = b - a;
	return [self substringWithRange:r];
}

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts 
{
	NSRange r;
	r.location = starts;
	r.length = [self length] - r.location;
	
	NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
	if (index.location == NSNotFound) {
		return -1;
	}
	return index.location + index.length;
}

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (BOOL)empty
{
	return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
	return [self length] > 0 ? YES : NO;
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)md5HashDigest
{
    const char *original = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original, strlen(original), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)letters
{
    NSMutableString *letterString = [NSMutableString string];
    int len = [self length];
    for (int i = 0;i < len;i++)
    {
        NSString *oneChar = [[self substringFromIndex:i] substringToIndex:1];
        if (![oneChar canBeConvertedToEncoding:NSASCIIStringEncoding])
		{
            NSArray *temA = makePinYin2([oneChar characterAtIndex:0]);
            oneChar = [temA objectAtIndex:0];
            
        }
        [letterString appendString:oneChar];
    }
    return letterString;
}

@end
