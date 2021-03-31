//
//  XHECFieldElementFp.m
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import "XHECFieldElementFp.h"
#import "XHECCurveFp.h"
#import "XHECPointFp.h"
#import "XHBigInt.h"

@interface XHECFieldElementFp ()

@property (nonatomic, weak) XHBigInt *q;
@property (nonatomic, strong) XHBigInt *x;

@end

@implementation XHECFieldElementFp


- (instancetype)initWithQ:(XHBigInt *)q x:(XHBigInt *)x
{
    if (self = [super init])
    {
        self.q = q;
        self.x = x;
    }
    return self;
}

/// 判断相等
/// @param other .
- (BOOL)equals:(XHECFieldElementFp *)other
{
    @autoreleasepool {
        if (self == other)
        {
            return YES;
        }
        
        return ([self.q compare:other.q] == NSOrderedSame &&
                [self.x compare:other.x] == NSOrderedSame);
    }
    
}

/// 返回具体数值
- (XHBigInt *)toBigInteger
{
    return self.x;
}

/// 取反
- (XHECFieldElementFp *)negate
{
    @autoreleasepool {
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[self.x negate] modByBigInt:self.q]];
    }
}

/// 相加
/// @param b .
- (XHECFieldElementFp *)add:(XHECFieldElementFp *)b
{
    @autoreleasepool {
        XHBigInt *tmp = [b toBigInteger];
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[self.x addByBigInt:tmp] modByBigInt:self.q]];
    }
}

/// 相减
/// @param b .
- (XHECFieldElementFp *)subtract:(XHECFieldElementFp *)b
{
    @autoreleasepool {
        XHBigInt *tmp = [b toBigInteger];
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[self.x subByBigInt:tmp] modByBigInt:self.q]];
    }
}


/// 相乘
/// @param b .
- (XHECFieldElementFp *)multiply:(XHECFieldElementFp *)b
{
    @autoreleasepool {
        XHBigInt *tmp = [b toBigInteger];
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[self.x multiplyByBigInt:tmp] modByBigInt:self.q]];
    }
}

/// 相除
/// @param b .
- (XHECFieldElementFp *)divide:(XHECFieldElementFp *)b
{
    @autoreleasepool {
        XHBigInt *tmp = [[b toBigInteger] modInverseByBigInt:self.q];
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[self.x multiplyByBigInt:tmp] modByBigInt:self.q]];
    }
}

/// 平方
- (XHECFieldElementFp *)square
{
    @autoreleasepool {
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[self.x square] modByBigInt:self.q]];
    }
}


#pragma mark - 点压缩 (y^2) mod n = a mod n,求y
// https://blog.csdn.net/qq_41746268/article/details/98730749
//对于给定的奇质数p，和正整数x,存在y满足1≤y≤p−1，且x≡y^2(mod p)x，则称y为x的模平方根
//对于正整数m,若同余式,若同余式x^2≡a(mod m)有解，则称a为模m的平方剩余，否则称为模m平方非剩余。
//是否存在模平方根
//根据欧拉判别条件:
//设p是奇质数，对于x^2≡a(mod p)
//a是模p的平方剩余的充要条件是(a^((p−1)/2)) % p = 1
//a是模p的平方非剩余的充要条件是(a^((p−1)/2)) % p = -1
//给定a,na,na,n(n是质数)，求x^2≡a(mod n)的最小整数解x
//代码复杂度O(log2(n))

///平方根
- (XHECFieldElementFp *)modsqrt
{
    @autoreleasepool {
        XHBigInt *b,*i,*k,*y;
        
        XHBigInt *n = _q;
        XHBigInt *a = _x;
        //n==2
        if ([n compare:[[XHBigInt alloc] initWithInt:2]] == NSOrderedSame)
        {
            //a%n
            return [[XHECFieldElementFp alloc] initWithQ:self.q x:[a modByBigInt:n]];
        }
        //qpow(a,(n-1)/2,n) == 1
        if ([[self _qpow:a b:[[n subByInt:1] divideByInt:2] p:n] compare:XHBigInt.one] == NSOrderedSame)
        {
            //n%4 == 3
            if ([[n modByInt:4] compare:[[XHBigInt alloc] initWithInt:3]] == NSOrderedSame)
            {
                //y=qpow(a,(n+1)/4,n)
                y = [self _qpow:a b:[[n addByInt:1] divideByInt:4] p:n];
            }
            else
            {
                //for(b=1,qpow(b,(n-1)/2,n) == 1,b++)
                for (b = XHBigInt.one; [[self _qpow:b b:[[n subByInt:1] divideByInt:2] p:n] compare:XHBigInt.one] == NSOrderedSame;)
                {
                    b = [b addByInt:1];
                }
                //i=(n-1)/2
                i = [[n subByInt:1] divideByInt:2];
                //k=0
                k = XHBigInt.zero;
                //while(i%2==0)
                while ([[i modByInt:2] compare:XHBigInt.zero] == NSOrderedSame)
                {
                    //i /= 2
                    i = [i divideByInt:2];
                    //k /= 2
                    k = [k divideByInt:2];
                    //t1=qpow(a,i,n)
                    XHBigInt *t1 = [self _qpow:a b:i p:n];
                    //t2=qpow(b,k,n)
                    XHBigInt *t2 = [self _qpow:b b:k p:n];
                    //(t1*t2+1)%n == 0
                    if ([[[[t1 multiplyByBigInt:t2] addByInt:1] modByBigInt:n] compare:XHBigInt.zero] == NSOrderedSame)
                    {
                        //k+=(n-1)/2
                        k = [k addByBigInt:[[n subByInt:1] divideByInt:2]];
                    }
                }
                //tt1=qpow(a,(i+1)/2,n)
                XHBigInt *tt1 = [self _qpow:a b:[[i addByInt:1] divideByInt:2] p:n];
                //tt2=qpow(b,k/2,n)
                XHBigInt *tt2 = [self _qpow:b b:[k divideByInt:2] p:n];
                //y=tt1*tt2%n
                y = [[tt1 multiplyByBigInt:tt2] modByBigInt:n];
            }
            //y*2>n
            if ([[y multiplyByInt:2] compare:n] == NSOrderedDescending)
            {
                //y = n - y
                y = [n subByBigInt:y];
            }
            return [[XHECFieldElementFp alloc] initWithQ:self.q x:y];
        }
        return [[XHECFieldElementFp alloc] initWithQ:self.q x:[[XHBigInt alloc] initWithInt:-1]];
    }
}

- (XHBigInt *)_qpow:(XHBigInt *)a b:(XHBigInt *)b p:(XHBigInt *)p
{
    @autoreleasepool {
        XHBigInt *ans = XHBigInt.one;
        //b != 0
        while ([b compare:XHBigInt.zero] != NSOrderedSame)
        {
            //b&1
            if ([[b bitwiseAndByBigInt:XHBigInt.one] compare:XHBigInt.zero] != NSOrderedSame)
            {
                //ans = ans*a%p
                ans = [[ans multiplyByBigInt:a] modByBigInt:p];
            }
            //a=a*a%p
            a = [[a multiplyByBigInt:a] modByBigInt:p];
            //b>>=1
            b = [b shiftRight:1];
        }
        return ans;
    }
}

@end
