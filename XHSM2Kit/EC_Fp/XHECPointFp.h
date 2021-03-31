//
//  XHECPointFp.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XHECCurveFp;
@class XHECFieldElementFp;
@class XHBigInt;

NS_ASSUME_NONNULL_BEGIN

/// 椭圆曲线上点
@interface XHECPointFp : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCurve:(XHECCurveFp *)curve
                            x:(nullable XHECFieldElementFp *)x
                            y:(nullable XHECFieldElementFp *)y
                            z:(nullable XHBigInt *)z;


// 椭圆曲线上的X坐标值(逻辑)
- (XHECFieldElementFp *)getX;

// 椭圆曲线上的Y坐标值(逻辑)
- (XHECFieldElementFp *)getY;

// Point在椭圆上的对称点
- (XHECPointFp *)negate;

// 相同点(twice) 不同点：两点连成线与椭圆相交另一点的对称点
- (XHECPointFp *)add:(XHECPointFp *)b;

// Point切线与椭圆相交另一点的对称点
- (XHECPointFp *)twice;

// k*Point
- (XHECPointFp *)multiply:(XHBigInt *)k;

@end

NS_ASSUME_NONNULL_END
