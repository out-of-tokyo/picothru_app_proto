//
//  WPYTokenBuilder.h
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPYToken;
@interface WPYTokenBuilder : NSObject
- (WPYToken *)buildTokenFromData:(NSData *)data error:(NSError * __autoreleasing *)outError;
@end
