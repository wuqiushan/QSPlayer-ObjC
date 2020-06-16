//
//  NSString+iOS.m
//  Mall
//
//  Created by apple on 2018/9/23.
//  Copyright © 2018年 wuqiushan. All rights reserved.
//

#import "NSString+iOS.h"

@implementation NSString (iOS)

+ (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHS %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/** 原价格显示删除线，如果不显示，可能与系统有关参考https://www.jianshu.com/p/f85165b8fc49 */
/**
+ (NSMutableAttributedString *)getDeleteLineStr {
    NSDictionary *attibtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attibtDic];
    return attribtStr;
} */

/** 根据字体类型和长度返回，需要宽度 */
-(CGFloat)widthWithFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

/** 根据字体类型和长度返回，需要宽度 */
-(CGFloat)heightWithFont:(UIFont *)font size:(CGSize)maxSize  {
    //CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}

/** 根据字体(含有换行)类型和长度返回，需要宽度 */
- (CGFloat)heightWithEnterFont:(UIFont *)font size:(CGSize)maxSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary * attributes = @{
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName: paragraphStyle
                                  };
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                           attributes:attributes
                              context:nil].size.height;
            
}


// 13719182375 -> 137 1918 2375
- (NSString *)formatMobileNumber {
    
    NSString *orgStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (orgStr.length <= 3) {
        NSString *str1 = [orgStr substringWithRange:NSMakeRange(0, orgStr.length)];
        return str1;
    }
    else if (orgStr.length <= 7) {
        NSString *str1 = [orgStr substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [orgStr substringWithRange:NSMakeRange(3, (orgStr.length - 3))];
        return [NSString stringWithFormat:@"%@ %@", str1, str2];
    }
    else if (orgStr.length <= 11) {
        NSString *str1 = [orgStr substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [orgStr substringWithRange:NSMakeRange(3, 4)];
        NSString *str3 = [orgStr substringWithRange:NSMakeRange(7, (orgStr.length - 7))];
        return [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    }
    else if (orgStr.length > 11) {
        NSString *str1 = [orgStr substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [orgStr substringWithRange:NSMakeRange(3, 4)];
        NSString *str3 = [orgStr substringWithRange:NSMakeRange(7, 4)];
        return [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    }
    
    return @"";
}

// 137 1918 2375 -> 13719182375
- (NSString *)normalMobileNumber {
    NSString *reslutStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return reslutStr;
}


// 有汉字编码
- (NSString *)codeingString {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

// 有汉字解码
- (NSString *)decodingString {
    return [self stringByRemovingPercentEncoding];
}

// 返回字节长度，汉字占2个字节
- (NSInteger)byteLength {
    NSStringEncoding encding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *byteData = [self dataUsingEncoding:encding];
    return byteData.length;
    
//    NSInteger strlength = 0;
//    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        }
//        else {
//            p++;
//        }
//    }
//    return strlength;
}

//从字符串中截取指定字节数
- (NSString *)subStringByByteWithIndex:(NSInteger)index{
    
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    
    for(int i = 0; i<[self length]; i++){
        
        unichar strChar = [self characterAtIndex:i];
        
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum >= index) {
            
            subStr = [self substringToIndex:i+1];
            return subStr;
        }
    }
    return subStr;
}

//从字符串中截取指定字符数（汉字为一个字符）
- (NSString *)subStringByCharWithIndex:(NSInteger)index{
    
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    
    for(int i = 0; i<[self length]; i++){
        
        unichar strChar = [self characterAtIndex:i];
        
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 1;
        }
        if (sum >= index) {
            
            subStr = [self substringToIndex:i+1];
            return subStr;
        }
    }
    return subStr;
}
@end
