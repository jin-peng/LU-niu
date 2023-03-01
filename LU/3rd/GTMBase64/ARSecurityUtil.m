#import "ARSecurityUtil.h"
#import "GTMBase64.h"

@implementation ARSecurityUtil

+ (NSString *)encodeBase64:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    Byte *byte = (Byte *)[data bytes];
    char chKey = 0x6e;
    int i;
    for (i = 0; i < [data length]; i++) {
        byte[i] = byte[i] ^ chKey;
    }
    
    NSData *data1 = [[NSData alloc] init];
    
    data1 = [GTMBase64 encodeBytes:byte length:i];
    
    NSString *base64String = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64:(NSString* )input {
    
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 decodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)decodeBase64Data:(NSData*)data {
    
    data = [GTMBase64 decodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

@end
