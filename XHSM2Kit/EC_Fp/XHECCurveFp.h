//
//  XHECCurveFp.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Fp(素数域)上的椭圆曲线 y^2 = x^3 + ax + b
//椭圆曲线E (Fp )上的点按照下面的加法运算规则，构成一个交换群:
//a) O+O=O;
//b) ∀P = (x,y) ∈ E(Fp)\{O}，P+O = O+P = P;
//c) ∀P = (x,y) ∈ E(Fp)\{O}，P的逆元素−P = (x,−y)，P+(−P) = O;
//d) 两个非互逆的不同点相加的规则:
//   设P1 = (x1,y1) ∈ E(Fp)\{O}，P2 = (x2,y2) ∈ E(Fp)\{O}，且x1 ≠ x2，
//   设P3 = (x3,y3)=P1+P2，则
//         x3 =λ^2 − x1 − x2,
//         y3 =λ(x1 − x3) − y1
//     其中
//                y2 − y1
//            λ = ———————  ;
//                x2 − x1
//e) 倍点规则:
//   设P1 = (x1,y1) ∈ E(Fp)\{O}，且y1 ≠ 0，P3 = (x3,y3) = P1 +P1，则
//         x3 =λ^2−2x1,
//         y3 =λ(x1−x3)−y1,
//     其中
//                 3x1^2 + a
//             λ = —————————  。
//                    2y1


@class XHECFieldElementFp;
@class XHECPointFp;
@class XHBigInt;

NS_ASSUME_NONNULL_BEGIN

/// 椭圆曲线 y^2 = x^3 + ax + b
@interface XHECCurveFp : NSObject

@property (nonatomic, strong, readonly) XHBigInt *q;
@property (nonatomic, strong, readonly) XHECPointFp *infinity;
@property (nonatomic, strong, readonly) XHECFieldElementFp *a;

@property (nonatomic, assign, readonly) NSUInteger pointLen;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithQ:(XHBigInt *)q
                        a:(XHBigInt *)a
                        b:(XHBigInt *)b
                 pointLen:(NSUInteger)len;

+ (XHBigInt *)Three;

- (XHECFieldElementFp *)fromBigInteger:(XHBigInt *)x;

- (XHECPointFp *)decodePointHex:(NSString *)s;
- (NSString *)encodePoint:(XHECPointFp *)point compressed:(BOOL)compressed;

- (NSString *)toString;

@end

NS_ASSUME_NONNULL_END
