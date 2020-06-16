//
//  NSString+iOS.h
//  Mall
//
//  Created by apple on 2018/9/23.
//  Copyright © 2018年 wuqiushan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (iOS)

/** 根据字体，返回需要宽度 */
-(CGFloat)widthWithFont:(UIFont *)font;
/** 根据字体和frame大小，返回需要宽度 */
-(CGFloat)heightWithFont:(UIFont *)font size:(CGSize)maxSize;
/** 根据字体(含有换行)类型和长度返回，需要宽度 */
- (CGFloat)heightWithEnterFont:(UIFont *)font size:(CGSize)maxSize;


#pragma mark 13719182375 -> 137 1918 2375
- (NSString *)formatMobileNumber;
#pragma mark 137 1918 2375 -> 13719182375
- (NSString *)normalMobileNumber;


// 有汉字编码
- (NSString *)codeingString;
// 有汉字解码
- (NSString *)decodingString;
// 返回字节长度，汉字占2个字节
- (NSInteger)byteLength;
//从字符串中截取指定字节数
- (NSString *)subStringByByteWithIndex:(NSInteger)index;
//从字符串中截取指定字符数
- (NSString *)subStringByCharWithIndex:(NSInteger)index;

@end
