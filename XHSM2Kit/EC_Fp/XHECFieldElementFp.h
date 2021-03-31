//
//  XHECFieldElementFp.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XHBigInt;

NS_ASSUME_NONNULL_BEGIN

/// 椭圆曲线域元素
@interface XHECFieldElementFp : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithQ:(XHBigInt *)q
                        x:(XHBigInt *)x;

/// 判断相等
/// @param other .
- (BOOL)equals:(XHECFieldElementFp *)other;

/// 返回具体数值
- (XHBigInt *)toBigInteger;

/// 取反
- (XHECFieldElementFp *)negate;

/// 相加
/// @param b 16进制字符串如: 0A477E
- (XHECFieldElementFp *)add:(XHECFieldElementFp *)b;

/// 相减
/// @param b .
- (XHECFieldElementFp *)subtract:(XHECFieldElementFp *)b;

/// 相乘
/// @param b .
- (XHECFieldElementFp *)multiply:(XHECFieldElementFp *)b;

/// 相除
/// @param b .
- (XHECFieldElementFp *)divide:(XHECFieldElementFp *)b;

/// 平方
- (XHECFieldElementFp *)square;

#pragma mark - 点压缩 (y^2) mod n = a mod n,求y
///平方根
- (XHECFieldElementFp *)modsqrt;

@end

NS_ASSUME_NONNULL_END
