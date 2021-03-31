//
//  XHCalculator.m
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import "XHCalculator.h"

@interface XHCalculator()

@property (nonatomic, strong) XHBigInt *bigInt;

@end

@implementation XHCalculator

- (instancetype)initWithBigInt:(XHBigInt *)bigInt
{
    if (self = [super init])
    {
        self.bigInt = bigInt;
    }
    return self;
}

#define XHCALCULATOR_IMPLEMENTATION(MethodName, Type)  - (XHCalculator *(^)(Type value))MethodName\
{\
    return ^XHCalculator *(Type value){\
        self.bigInt = [self.bigInt MethodName:value];\
        return self;\
    };\
}\


#pragma mark 加：
XHCALCULATOR_IMPLEMENTATION(addByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(addByInt, NSInteger)
// 原始
//- (XHCALCULATOR *(^)(O2SBigInt *value))addByBigInt
//{
//    return ^XHCALCULATOR *(O2SBigInt *value){
//        self.bigInt = [self.bigInt addByBigInt:value];
//        return self;
//    };
//}

//- (XHCALCULATOR *(^)(NSInteger value))addByInt
//{
//    return ^XHCALCULATOR *(NSInteger value){
//        self.bigInt = [self.bigInt addByInt:value];
//        return self;
//    };
//}

#pragma mark 减：
XHCALCULATOR_IMPLEMENTATION(subByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(subByInt, NSInteger)

#pragma mark 乘：
XHCALCULATOR_IMPLEMENTATION(multiplyByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(multiplyByInt, NSInteger)

#pragma mark 除：
XHCALCULATOR_IMPLEMENTATION(divideByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(divideByInt, NSInteger)


#pragma mark 求余：
XHCALCULATOR_IMPLEMENTATION(reminderByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(reminderByInt, NSInteger)

//#pragma mark 幂运算：
XHCALCULATOR_IMPLEMENTATION(pow, NSUInteger)

#pragma mark 幂运算求余：
- (XHCalculator *(^)(XHBigInt *exponent, XHBigInt *value))powByMod
{
    return ^XHCalculator *(XHBigInt *exponent, XHBigInt *value){
        self.bigInt = [self.bigInt pow:exponent mod:value];
        return self;
    };
}

#pragma mark 异或：
XHCALCULATOR_IMPLEMENTATION(bitwiseXorByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(bitwiseXorByInt, NSInteger)

#pragma mark 或：
XHCALCULATOR_IMPLEMENTATION(bitwiseOrByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(bitwiseOrByInt, NSInteger)

#pragma mark 与：
XHCALCULATOR_IMPLEMENTATION(bitwiseAndByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(bitwiseAndByInt, NSInteger)

#pragma mark 左移：
XHCALCULATOR_IMPLEMENTATION(shiftLeft, int)

#pragma mark 右移：
XHCALCULATOR_IMPLEMENTATION(shiftRight, int)

#pragma mark 最大公约数
XHCALCULATOR_IMPLEMENTATION(gcdByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(gcdByInt, NSInteger)

#pragma mark 余逆：
XHCALCULATOR_IMPLEMENTATION(modInverseByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(modInverseByInt, NSInteger)

#pragma mark 余：
XHCALCULATOR_IMPLEMENTATION(modByBigInt, XHBigInt *)
XHCALCULATOR_IMPLEMENTATION(modByInt, NSInteger)

#define XHCALCULATOR_IMPLEMENTATION_NONEARGUMENT(MethodName)  - (XHCalculator *(^)(void))MethodName\
{\
    return ^XHCalculator *(void){\
        self.bigInt = [self.bigInt MethodName];\
        return self;\
    };\
}\

#pragma mark 平方：
XHCALCULATOR_IMPLEMENTATION_NONEARGUMENT(square)
// 原始
//- (XHCALCULATOR *(^)(void))square
//{
//    return ^XHCALCULATOR *(void){
//        self.bigInt = [self.bigInt square];
//        return self;
//    };
//}

#pragma mark 平方根：
XHCALCULATOR_IMPLEMENTATION_NONEARGUMENT(sqrt)

#pragma mark 求反：
XHCALCULATOR_IMPLEMENTATION_NONEARGUMENT(negate)

#pragma mark 绝对值：
XHCALCULATOR_IMPLEMENTATION_NONEARGUMENT(abs)

#undef XHCALCULATOR_IMPLEMENTATION

@end
