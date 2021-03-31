//
//  XHBigInt.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBigInt : NSObject

#pragma mark - 大数对象 初始化

/// 初始化大数对象
/// @return 大数对象
- (instancetype)init;

/// 初始化大数对象
/// @param value 整型数据
/// @return 大数对象
- (instancetype)initWithInt:(NSInteger)value;

/// 初始化大数对象
/// @param value 大数对象
/// @return 大数对象
- (instancetype)initWithBigInteger:(XHBigInt *)value;

/// 初始化大数对象
/// @param valueString 数值字符串
/// @return 大数对象
- (instancetype)initWithString:(NSString *)valueString;

/// 初始化大数对象
/// @param valueString 数值字符串
/// @param radix       进制
/// @return 大数对象
- (instancetype)initWithString:(NSString *)valueString radix:(int)radix;

/// 初始化大数对象
/// @param bits 大素数位数
/// @return 大数对象
- (instancetype)initWithRandomPremeBits:(int)bits;

/// 初始化大数对象
/// @param bits 位数
/// @return 大数对象
- (instancetype)initWithRandomBits:(int)bits;

/// 初始化大数对象
/// @param bytes 字节流
/// @param size  长度
/// @return 大数对象
- (instancetype)initWithBytes:(const void *)bytes size:(int)size;

/// 初始化大数对象
/// @param bytes 无符号字节流
/// @param size  长度
/// @return 大数对象
- (instancetype)initWithUnsignedBytes:(const void *)bytes size:(int)size;

#pragma mark - 特殊大数对象 0，1

/// 获取 0
/// @return 大数对象
+ (XHBigInt *)zero;

/// 获取 1
/// @return 大数对象
+ (XHBigInt *)one;

#pragma mark - 大数运算

#pragma mark 加:

/// 大数相加
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)addByBigInt:(XHBigInt *)value;

/// 大数相加
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)addByInt:(NSInteger)value;

#pragma mark 减：

/// 大数相减
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)subByBigInt:(XHBigInt *)value;

/// 大数相减
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)subByInt:(NSInteger)value;

#pragma mark 乘：

/// 大数相乘
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)multiplyByBigInt:(XHBigInt *)value;

/// 大数相乘
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)multiplyByInt:(NSInteger)value;

#pragma mark 除：

/// 大数相除
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)divideByBigInt:(XHBigInt *)value;

/// 大数相除
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)divideByInt:(NSInteger)value;

#pragma mark 求余：

/// 大数求余
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)reminderByBigInt:(XHBigInt *)value;

/// 大数求余
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)reminderByInt:(NSInteger)value;

#pragma mark 幂运算：

/// 大数幂运算
/// @param exponent 指数
/// @return 大数对象
- (XHBigInt *)pow:(NSUInteger)exponent;

#pragma mark 幂运算求余：

/// 大数幂运算求余
/// @param exponent 指数
/// @param value    模数
/// @return 大数对象
- (XHBigInt *)pow:(XHBigInt *)exponent mod:(XHBigInt *)value;

#pragma mark 平方：

/// 大数平方运算
/// @return 大数对象
- (XHBigInt *)square;

#pragma mark 平方根：

/// 大数平方根运算
/// @return 大数对象
- (XHBigInt *)sqrt;

#pragma mark 求反：

/// 大数求反
/// @return 大数对象
- (XHBigInt *)negate;

#pragma mark 绝对值：

/// 大数绝对值
/// @return 大数对象
- (XHBigInt *)abs;

#pragma mark 异或：

/// 大数位异或
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)bitwiseXorByBigInt:(XHBigInt *)value;

/// 大数位异或
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)bitwiseXorByInt:(NSInteger)value;

#pragma mark 或：

/// 大数或
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)bitwiseOrByBigInt:(XHBigInt *)value;

/// 大数或
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)bitwiseOrByInt:(NSInteger)value;

#pragma mark 与：

/// 大数与
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)bitwiseAndByBigInt:(XHBigInt *)value;

/// 大数与
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)bitwiseAndByInt:(NSInteger)value;

#pragma mark 左移：

/// 左移
/// @param num 左移位数
/// @return 大数对象
- (XHBigInt *)shiftLeft:(int)num;

#pragma mark 右移：

/// 右移
/// @param num 右移位数
/// @return 大数对象
- (XHBigInt *)shiftRight:(int)num;

#pragma mark 最大公约数：

/// 最大公约数
/// @param value 大数对象
/// @return 大数对象
- (XHBigInt *)gcdByBigInt:(XHBigInt *)value;

/// 最大公约数
/// @param value 整数
/// @return 大数对象
- (XHBigInt *)gcdByInt:(NSInteger)value;

#pragma mark 余逆：

/// 大数求余逆
/// @param n 阶数
/// @return 大数对象
- (XHBigInt *)modInverseByBigInt:(XHBigInt *)n;

/// 大数求余逆
/// @param n 阶数
/// @return 大数对象
- (XHBigInt *)modInverseByInt:(NSInteger)n;

#pragma mark 余：

/// 大数求余
/// @param n 阶数
/// @return 大数对象
- (XHBigInt *)modByBigInt:(XHBigInt *)n;

/// 大数求余
/// @param n 阶数
/// @return 大数对象
- (XHBigInt *)modByInt:(NSInteger)n;

#pragma mark - Other

/// 比较
/// @param value 大数对象
/// @return 比较结果
- (NSComparisonResult)compare:(XHBigInt *)value;

/// 转换为字符串
/// @return 数值字符串
- (NSString *)toString;

/// 转换为字符串
/// @param radix 进制
/// @return 字符串
- (NSString *)toString:(int)radix;

/// 获取字节流
/// @param bytes  字节流
/// @param length 长度
- (void)getBytes:(void **)bytes length:(int *)length;

/// 获取无符号字节流
/// @param bytes  字节流
/// @param length 长度
- (void)getUnsignBytes:(void **)bytes length:(int *)length;

- (int)signum;

- (uint64_t)bitLength;

- (BOOL)testBit:(uint64_t)index;

@end


/// 商数和余数
@interface XHBigInt_QuotientAndRemainder : NSObject

/// 商
@property (nonatomic, strong) XHBigInt *quotient;

/// 余数
@property (nonatomic, strong) XHBigInt *reminder;

- (instancetype)initWithQuotient:(XHBigInt *)quotient
                        reminder:(XHBigInt *)reminder;

@end
