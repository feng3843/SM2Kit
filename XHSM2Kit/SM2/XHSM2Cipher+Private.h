//
//  XHSM2Cipher+Private.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import "XHSM2Cipher.h"
#import "XHECCurveFp.h"

@class XHBigInt;
@class XHECPointFp;

@interface XHSM2Cipher ()

@property(nonatomic, copy) NSString *pHex;
@property(nonatomic, copy) NSString *aHex;
@property(nonatomic, copy) NSString *bHex;
@property(nonatomic, copy) NSString *gxHex;
@property(nonatomic, copy) NSString *gyHex;
@property(nonatomic, copy) NSString *nHex;

@property(nonatomic, strong) XHECCurveFp *curve;
@property(nonatomic, strong) XHBigInt *n;

- (XHBigInt *)randomBigIntegerK;

- (XHECPointFp *)kG:(XHBigInt *)k;

//pPointHex 非压缩点
- (XHECPointFp *)kP:(XHBigInt *)k PPointHex:(NSString *)pPointHex;
- (XHECPointFp *)kP:(XHBigInt *)k PPoint:(XHECPointFp *)pPoint;

- (NSUInteger)getPointLen;

@end
