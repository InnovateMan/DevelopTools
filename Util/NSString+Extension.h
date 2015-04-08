//
//  NSString+Extension.h
//  i3-platform-sdk
//
//  Created by Sun Yu on 13-3-22.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b;

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts;

- (BOOL)containsString:(NSString*)aString;


- (NSString *)trim;

- (BOOL)empty;
- (BOOL)notEmpty;

- (NSString *)md5HashDigest;


- (NSString *)letters;
@end
