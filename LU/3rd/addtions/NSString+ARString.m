#import "NSString+ARString.h"

@implementation NSString (ARString)

- (NSString *) replaceCharacter:(NSString *)oStr withString:(NSString *)nStr
{
    if (oStr && nStr) {
        NSMutableString *_str = [NSMutableString stringWithString:self];
        [_str replaceOccurrencesOfString:oStr withString:nStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, _str.length)];
        return _str;
    }
    else
        return oStr;
}

@end
