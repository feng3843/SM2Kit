//
//  XHSM3Digest.h
//  XHSM2Kit
//
//  Created by 朱鑫华 on 2021/3/31.
//  Copyright © 2021 朱鑫华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSM3Digest : NSObject

+ (NSData *)KDF:(NSData *)z keylen:(int)keylen;

+ (NSData *)hash:(NSString *)message;

+ (NSData *)hashData:(NSData *)data;

@end
