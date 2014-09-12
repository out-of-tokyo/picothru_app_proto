//
//  WPYHTTPRequestSerializer.h
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// During a request, NSURLConnection maintains a strong reference to its delegate.
#import <Foundation/Foundation.h>

@class WPYCreditCard;

typedef void (^WPYCommunicatorCompBlock)(NSURLResponse *, NSData *, NSError *);

@interface WPYCommunicator : NSObject
- (void)requestTokenWithPublicKey:(NSString *)publicKey
                             card:(WPYCreditCard *)card
                   acceptLanguage:(NSString *)acceptLanguage
                  completionBlock:(WPYCommunicatorCompBlock)compBlock;

@end
