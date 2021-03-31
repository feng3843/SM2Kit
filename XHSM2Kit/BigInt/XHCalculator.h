//
//  XHCalculator.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBigInt.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHCalculator : NSObject

@property (nonatomic, strong, readonly) XHBigInt *bigInt;

- (instancetype)initWithBigInt:(nonnull XHBigInt *)bigInt;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark 加：
@property (nonatomic, strong, readonly) XHCalculator* (^addByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^addByInt)(NSInteger value);

#pragma mark 减：
@property (nonatomic, strong, readonly) XHCalculator* (^subByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^subByInt)(NSInteger value);

#pragma mark 乘：
@property (nonatomic, strong, readonly) XHCalculator* (^multiplyByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^multiplyByInt)(NSInteger value);

#pragma mark 除：
@property (nonatomic, strong, readonly) XHCalculator* (^divideByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^divideByInt)(NSInteger value);

#pragma mark 求余：
@property (nonatomic, strong, readonly) XHCalculator* (^reminderByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^reminderByInt)(NSInteger value);

#pragma mark 幂运算：
@property (nonatomic, strong, readonly) XHCalculator* (^pow)(NSUInteger value);

#pragma mark 幂运算求余：
@property (nonatomic, strong, readonly) XHCalculator* (^powByMod)(XHBigInt *exponent, XHBigInt *value);

#pragma mark 异或：
@property (nonatomic, strong, readonly) XHCalculator* (^bitwiseXorByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^bitwiseXorByInt)(NSInteger value);

#pragma mark 或：
@property (nonatomic, strong, readonly) XHCalculator* (^bitwiseOrByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^bitwiseOrByInt)(NSInteger value);

#pragma mark 与：
@property (nonatomic, strong, readonly) XHCalculator* (^bitwiseAndByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^bitwiseAndByInt)(NSInteger value);

#pragma mark 左移：
@property (nonatomic, strong, readonly) XHCalculator* (^shiftLeft)(int value);

#pragma mark 右移：
@property (nonatomic, strong, readonly) XHCalculator* (^shiftRight)(int value);

#pragma mark 最大公约数
@property (nonatomic, strong, readonly) XHCalculator* (^gcdByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^gcdByInt)(NSInteger value);

#pragma mark 余逆：
@property (nonatomic, strong, readonly) XHCalculator* (^modInverseByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^modInverseByInt)(NSInteger value);

#pragma mark 余：
@property (nonatomic, strong, readonly) XHCalculator* (^modByBigInt)(XHBigInt *value);
@property (nonatomic, strong, readonly) XHCalculator* (^modByInt)(NSInteger value);

#pragma mark 平方：
@property (nonatomic, strong, readonly) XHCalculator* (^square)(void);

#pragma mark 平方根：
@property (nonatomic, strong, readonly) XHCalculator* (^sqrt)(void);

#pragma mark 求反：
@property (nonatomic, strong, readonly) XHCalculator* (^negate)(void);

#pragma mark 绝对值：
@property (nonatomic, strong, readonly) XHCalculator* (^abs)(void);

@end

NS_ASSUME_NONNULL_END
