//
//  XHECPointFp.m
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import "XHECPointFp.h"
#import "XHECCurveFp.h"
#import "XHECFieldElementFp.h"
#import "XHBigInt.h"

@interface XHECPointFp ()

@property (nonatomic, weak) XHECCurveFp *curve;
@property (nonatomic, strong) XHECFieldElementFp *x;
@property (nonatomic, strong) XHECFieldElementFp *y;
@property (nonatomic, strong) XHBigInt *z;
@property (nonatomic, strong) XHBigInt *zinv;

@end

@implementation XHECPointFp

- (instancetype)initWithCurve:(XHECCurveFp *)curve
                            x:(XHECFieldElementFp *)x
                            y:(XHECFieldElementFp *)y
                            z:(XHBigInt *)z
{
    if (self = [super init])
    {
        self.curve = curve;
        self.x = x;
        self.y = y;
        // 标准射影坐标系：zinv == null 或 z * zinv == 1
        self.z = z == nil ? XHBigInt.one : z;
        
        self.zinv = nil;
    }
    return self;
}

- (XHECFieldElementFp *)getX
{
    @autoreleasepool {
        if (self.zinv == nil)
        {
            self.zinv = [self.z modInverseByBigInt:self.curve.q];
        }
        XHBigInt *tmp = [[[self.x toBigInteger] multiplyByBigInt:self.zinv] modByBigInt:self.curve.q];
        return [self.curve fromBigInteger:tmp];
    }
}

- (XHECFieldElementFp *)getY
{
    @autoreleasepool {
        if (self.zinv == nil)
        {
            self.zinv = [self.z modInverseByBigInt:self.curve.q];
        }
        XHBigInt *tmp = [[[self.y toBigInteger] multiplyByBigInt:self.zinv] modByBigInt:self.curve.q];
        return [self.curve fromBigInteger:tmp];
    }
}

/// 判断相等
/// @param other .
- (BOOL)equals:(XHECPointFp *) other
{
    @autoreleasepool {
        if (self == other)
        {
            return true;
        }
        
        if ([self isInfinity])
        {
            return [other isInfinity];
        }
        if ([other isInfinity])
        {
            return [self isInfinity];
        }
        
        // u = y2 * z1 - y1 * z2
        XHBigInt *u = [[[[other.y toBigInteger] multiplyByBigInt:self.z] subByBigInt:([[self.y toBigInteger] multiplyByBigInt:other.z])] modByBigInt:self.curve.q];
        if ([u compare:XHBigInt.zero] != NSOrderedSame)
        {
            return NO;
        }
        // v = x2 * z1 - x1 * z2
        XHBigInt *v = [[[[other.x toBigInteger] multiplyByBigInt:self.z] subByBigInt:([[self.x toBigInteger] multiplyByBigInt:other.z])] modByBigInt:self.curve.q];
        return [v compare:XHBigInt.zero] == NSOrderedSame;
    }
}

/// 是否是无穷远点
- (BOOL)isInfinity
{
    @autoreleasepool {
        if (self.x == nil && self.y == nil)
        {
            return true;
        }
    
        return [self.z compare:XHBigInt.zero] == NSOrderedSame && !([[self.y toBigInteger] compare:XHBigInt.zero]);
    }
}

/// 取反，x 轴对称点
- (XHECPointFp *)negate
{
    @autoreleasepool {
        return [[XHECPointFp alloc] initWithCurve:self.curve x:self.x y:[self.y negate] z:self.z];
    }
}


/// 相加
/// 标准射影坐标系
/// λ1 = x1 * z2
/// λ2 = x2 * z1
/// λ3 = λ1 − λ2
/// λ4 = y1 * z2
/// λ5 = y2 * z1
/// λ6 = λ4 − λ5
/// λ7 = λ1 + λ2
/// λ8 = z1 * z2
/// λ9 = λ3^2
/// λ10 = λ3 * λ9
/// λ11 = λ8 * λ6^2 − λ7 * λ9
/// x3 = λ3 * λ11
/// y3 = λ6 * (λ9 * λ1 − λ11) − λ4 * λ10
/// z3 = λ10 * λ8
/// @param b .
- (XHECPointFp *)add:(XHECPointFp *)b
{
    @autoreleasepool {
        if ([self isInfinity])
        {
            return b;
        }
        
        if ([b isInfinity]) {
            return self;
        }
        
        XHBigInt *x1 = [self.x toBigInteger];
        XHBigInt *y1 = [self.y toBigInteger];
        XHBigInt *z1 = self.z;
        XHBigInt *x2 = [b.x toBigInteger];
        XHBigInt *y2 = [b.y toBigInteger];
        XHBigInt *z2 = b.z;
        XHBigInt *q = self.curve.q;
        
        XHBigInt *w1 = [[x1 multiplyByBigInt:z2] modByBigInt:q];
        XHBigInt *w2 = [[x2 multiplyByBigInt:z1] modByBigInt:q];
        XHBigInt *w3 = [w1 subByBigInt:w2];
        XHBigInt *w4 = [[y1 multiplyByBigInt:z2] modByBigInt:q];
        XHBigInt *w5 = [[y2 multiplyByBigInt:z1] modByBigInt:q];
        XHBigInt *w6 = [w4 subByBigInt:w5];
        
        if ([XHBigInt.zero compare:w3] == NSOrderedSame)
        {
            if ([XHBigInt.zero compare:w6] == NSOrderedSame)
            {
                return [self twice];
            }
            return self.curve.infinity;
        }
        
        XHBigInt *w7 = [w1 addByBigInt:w2];
        XHBigInt *w8 = [[z1 multiplyByBigInt:z2] modByBigInt:q];
        XHBigInt *w9 = [[w3 square] modByBigInt:q];
        XHBigInt *w10 = [[w3 multiplyByBigInt:w9] modByBigInt:q];
        XHBigInt *w11 = [[[w8 multiplyByBigInt:[w6 square]] subByBigInt:[w7 multiplyByBigInt:w9]] modByBigInt:q];
        
        XHBigInt *x3 = [[w3 multiplyByBigInt:w11] modByBigInt:q];
        XHBigInt *y3 = [[[w6 multiplyByBigInt:[[w9 multiplyByBigInt:w1] subByBigInt:w11]] subByBigInt:[w4 multiplyByBigInt:w10]] modByBigInt:q];
        XHBigInt *z3 = [[w10 multiplyByBigInt:w8] modByBigInt:q];
    
        return [[XHECPointFp alloc] initWithCurve:self.curve x:[self.curve fromBigInteger:x3] y:[self.curve fromBigInteger:y3] z:z3];
    }
    
}



/// 自加
/// 标准射影坐标系：
///  λ1 = 3 * x1^2 + a * z1^2
///  λ2 = 2 * y1 * z1
///  λ3 = y1^2
///  λ4 = λ3 * x1 * z1
///  λ5 = λ2^2
///  λ6 = λ1^2 − 8 * λ4
///  x3 = λ2 * λ6
///  y3 = λ1 * (4 * λ4 − λ6) − 2 * λ5 * λ3
///  z3 = λ2 * λ5
///
- (XHECPointFp *)twice
{
    @autoreleasepool {
        if ([self isInfinity])
        {
            return self;
        }
        if (![[self.y toBigInteger] signum]) {
            return self.curve.infinity;
        }
        
        XHBigInt *x1 = [self.x toBigInteger];
        XHBigInt *y1 = [self.y toBigInteger];
        XHBigInt *z1 = self.z;
        XHBigInt *q = self.curve.q;
        XHBigInt *a = [self.curve.a toBigInteger];
        
        XHBigInt *w1 = [[[[x1 square] multiplyByBigInt:XHECCurveFp.Three] addByBigInt:[a multiplyByBigInt:[z1 square]]] modByBigInt:q];
        XHBigInt *w2 = [[[y1 shiftLeft:1] multiplyByBigInt:z1] modByBigInt:q];
        XHBigInt *w3 = [[y1 square] modByBigInt:q];
        XHBigInt *w4 = [[[w3 multiplyByBigInt:x1] multiplyByBigInt:z1] modByBigInt:q];
        XHBigInt *w5 = [[w2 square] modByBigInt:q];
        XHBigInt *w6 = [[[w1 square] subByBigInt:[w4 shiftLeft:3]] modByBigInt:q];
        
        XHBigInt *x3 = [[w2 multiplyByBigInt:w6] modByBigInt:q];
        XHBigInt *y3 = [[[w1 multiplyByBigInt:[[w4 shiftLeft:2] subByBigInt:w6]] subByBigInt:[[w5 shiftLeft:1] multiplyByBigInt:w3]] modByBigInt:q];
        XHBigInt *z3 = [[w2 multiplyByBigInt:w5] modByBigInt:q];
        
        return [[XHECPointFp alloc] initWithCurve:self.curve x:[self.curve fromBigInteger:x3] y:[self.curve fromBigInteger:y3] z:z3];
    }
}


/// 倍点计算 kG
/// @param k .
- (XHECPointFp *)multiply:(XHBigInt *)k
{
    @autoreleasepool {
        if ([self isInfinity])
        {
            return self;
        }
        if (![k signum]) {
            return self.curve.infinity;
        }
        
        XHBigInt *k3 = [k multiplyByBigInt:XHECCurveFp.Three];
        XHECPointFp *neg = [self negate];
        XHECPointFp *Q = self;
        for (uint64_t i = [k3 bitLength] - 2; i > 0; i--)
        {
            Q = [Q twice];
            
            BOOL k3Bit = [k3 testBit:i];
            BOOL kBit = [k testBit:i];
            
            if (k3Bit != kBit)
            {
                Q = [Q add:(k3Bit? self : neg)];
            }
        }

        return Q;
    }
}

@end
