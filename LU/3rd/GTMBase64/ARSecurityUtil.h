#import <Foundation/Foundation.h>

@interface ARSecurityUtil : NSObject

+ (NSString*)encodeBase64:(NSString *)input;

+ (NSString*)decodeBase64:(NSString* )input;

@end
