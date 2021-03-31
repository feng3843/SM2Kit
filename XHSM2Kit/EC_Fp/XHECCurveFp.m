//
//  XHECCurveFp.m
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import "XHECCurveFp.h"
#import "XHECPointFp.h"
#import "XHECFieldElementFp.h"
#import "XHBigInt.h"
#import "XHSMxUtils.h"

@interface XHECCurveFp()

@property (nonatomic, strong) XHBigInt *q;
@property (nonatomic, strong) XHECFieldElementFp *a;
@property (nonatomic, strong) XHECFieldElementFp *b;
@property (nonatomic, strong) XHECPointFp *infinity;
@property (nonatomic, assign) NSUInteger pointLen;

@end

@implementation XHECCurveFp

+ (XHBigInt *)Three
{
    static XHBigInt *three;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        three = [[XHBigInt alloc] initWithInt:3];
    });
    return three;
}

- (instancetype)initWithQ:(XHBigInt *)q
                        a:(XHBigInt *)a
                        b:(XHBigInt *)b
                 pointLen:(NSUInteger)len
{
    if (self = [super init])
    {
        self.q = q;
        self.a = [self fromBigInteger:a];
        self.b = [self fromBigInteger:b];
        
        self.infinity =  [[XHECPointFp alloc] initWithCurve:self
                                                            x:nil
                                                            y:nil
                                                            z:nil];
        
        self.pointLen = len;
    }
    return self;
}

/// 判断两个椭圆曲线是否相等
/// @param other .
- (BOOL)equals:(XHECCurveFp *) other
{
    @autoreleasepool {
        if (self == other)
        {
            return YES;
        }
    
        return [self.q compare:other.q] == NSOrderedSame && [self.a equals:other.a] && [self.b equals:other.b];
    }
}

/// 生成椭圆曲线域元素
/// @param x .
- (XHECFieldElementFp *)fromBigInteger:(XHBigInt *)x
{
    return [[XHECFieldElementFp alloc] initWithQ:self.q x:x];
}

#pragma mark - 椭圆曲线点的压缩与解压缩

/// 解析 16 进制串为椭圆曲线点 坐标点压缩 压缩格式：若公钥y坐标最后一位为0，则首字节为0x02，否则为0x03。非压缩格式：公钥首字节为0x04
/// @param s .
- (XHECPointFp *)decodePointHex:(NSString *)s
{
    if (s.length < 2)
    {
        return nil;
    }
    NSRange range = (NSRange){0,2};
    unsigned long outVal = strtoul([[s substringWithRange:range] UTF8String], 0, 16);
    switch (outVal) {
        case 0:
            return self.infinity;
            break;
        case 2:
        case 3:
        {
            // 已知椭圆方程式y^2 = x^3 + ax + b，和已知的点的坐标x值，求点的坐标y值
            NSUInteger len = ([s length] - 2 );
            if (len != self.pointLen/2)
            {
//                NSAssert(NO, @"decode point error");
                return nil;
            }
            NSRange range = (NSRange){2,len};
            NSString *xHex = [s substringWithRange:range];
            XHBigInt *x = [[XHBigInt alloc] initWithString:xHex radix:16];

            XHECFieldElementFp *x_fe = [self fromBigInteger:x];
            XHECFieldElementFp *rhs =  [[x_fe square] multiply:x_fe];
            rhs = [rhs add:[self.a multiply:x_fe]];
            rhs = [rhs add:self.b];

            XHECFieldElementFp *y_fe = [rhs modsqrt];//modsqrt(),这里是[y^2 mod q = (x^3 + ax + b) mod q]求y(模平方根)
            unsigned long yp = outVal & 1;

            if ([[[y_fe toBigInteger] bitwiseAndByInt:1] compare:[[XHBigInt alloc] initWithInt:yp]] == NSOrderedSame)
            {
                return [[XHECPointFp alloc] initWithCurve:self x:x_fe  y:y_fe z:nil];
            }
            else
            {
                XHECFieldElementFp *field = [[XHECFieldElementFp alloc] initWithQ:self.q x:self.q];
                y_fe = [field subtract:y_fe];
                return [[XHECPointFp alloc] initWithCurve:self x:x_fe  y:y_fe z:nil];
            }
            
//            NSAssert(NO, @"decode point error");
            return nil;
        }
            break;
        case 4:
        case 6:
        case 7:
        {
            NSUInteger len = ([s length] - 2 ) / 2;
            if (len != self.pointLen/2)
            {
//                NSAssert(NO, @"decode point error");
                return nil;
            }
        
            NSRange range = (NSRange){2,len};
            NSString *xHex = [s substringWithRange:range];
            XHBigInt *x = [[XHBigInt alloc] initWithString:xHex radix:16];
            XHECFieldElementFp *x_fe = [self fromBigInteger:x];
            
            range.location = len + 2;
            NSString *yHex = [s substringWithRange:range];
            XHBigInt *y = [[XHBigInt alloc] initWithString:yHex radix:16];
            XHECFieldElementFp *y_fe = [self fromBigInteger:y];
            
            return [[XHECPointFp alloc] initWithCurve:self x:x_fe  y:y_fe z:nil];
        }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSString *)encodePoint:(XHECPointFp *)point compressed:(BOOL)compressed
{
    if (compressed == NO)
    {
        //04
        NSString *pointX = [XHSMxUtils leftPad:[[[point getX] toBigInteger] toString:16] num:self.pointLen/2];
        NSString *pointY = [XHSMxUtils leftPad:[[[point getY] toBigInteger] toString:16] num:self.pointLen/2];
        NSString *pointHex = [NSString stringWithFormat:@"04%@%@", pointX, pointY];
        return pointHex;
    }
    else
    {
        //02 03
        NSString *pointX = [XHSMxUtils leftPad:[[[point getX] toBigInteger] toString:16] num:self.pointLen/2];
        
        XHBigInt *y = [[point getY] toBigInteger];
        XHBigInt *py = [y bitwiseAndByInt:1];
        XHBigInt *pc = [py bitwiseOrByInt:0x02];
        NSString *pcStr = [XHSMxUtils leftPad:[pc toString:16] num:2];
        NSRange range = (NSRange){pcStr.length - 2, 2};
        pcStr = [pcStr substringWithRange:range];
        
        NSString *pointHex = [NSString stringWithFormat:@"%@%@", pcStr, pointX];
        return pointHex;
    }
}

- (NSString *)toString
{
    return [NSString stringWithFormat:@"\"Fp\": y^2 = x^3 + %@*x + %@ over %@",[self.a.toBigInteger toString:10],[self.b.toBigInteger toString:10],[self.q toString:10]];
}

@end
