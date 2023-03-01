//
//  NSString+Extension.m
//  SouthBeauty
//
//  Created by McMillen on 12-5-23.
//  Copyright (c) 2012年 dyd. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


- (NSString *)TrimHTML:(NSString *)htmlString
{
    /*
     
     if (string.IsNullOrEmpty(Htmlstring))
     {
     return string.Empty;
     }
     //删除脚本
     Htmlstring = Regex.Replace(Htmlstring, @"<script[^>]*?>.*?</script>", "",
     RegexOptions.IgnoreCase);
     //删除HTML
     Htmlstring = Regex.Replace(Htmlstring, @"<(.[^>]*)>", "",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"([\r\n])[\s]+", "",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"–>", "", RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"<!–.*", "", RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(quot|#34);", "\"",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(amp|#38);", "&",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(lt|#60);", "<",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(gt|#62);", ">",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(nbsp|#160);", "   ",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(iexcl|#161);", "\xa1",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(cent|#162);", "\xa2",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(pound|#163);", "\xa3",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&(copy|#169);", "\xa9",
     RegexOptions.IgnoreCase);
     Htmlstring = Regex.Replace(Htmlstring, @"&#(\d+);", "",
     RegexOptions.IgnoreCase);
     
     
     //替换中文点号
     Htmlstring = Regex.Replace(Htmlstring, @"&(middot|#183);", "·",
     RegexOptions.IgnoreCase);
     //替换中文双引号
     Htmlstring = Regex.Replace(Htmlstring, @"&(rdquo|#8221);", "”",
     RegexOptions.IgnoreCase);
     //替换中文单引号
     Htmlstring = Regex.Replace(Htmlstring, @"&(ldquo|#8220);", "“",
     RegexOptions.IgnoreCase);
     //替换中文省略号"…"
     Htmlstring = Regex.Replace(Htmlstring, @"&hellip;|&#8230;", "…", 
     RegexOptions.IgnoreCase);
     
     Htmlstring.Replace("<", "");
     Htmlstring.Replace("</", "");//
     Htmlstring.Replace(">", "");
     Htmlstring.Replace("\r\n", "");
     Htmlstring = HttpContext.Current.Server.HtmlEncode(Htmlstring).Trim();
     
     return Htmlstring;
     
     */
    
    return @"";
}

@end
