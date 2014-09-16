//
//  WPYTokenizer.h
//  Webpay
//
//  Created by yohei on 3/30/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPYToken;
@class WPYCreditCard;

@interface WPYTokenizer : NSObject

typedef void (^WPYTokenizerCompletionBlock)(WPYToken *token, NSError *error);

+ (void)setPublicKey:(NSString *)key;
+ (NSString *)publicKey;

// completion block will return nil if there's any error.
+ (void)createTokenFromCard:(WPYCreditCard *)card
            completionBlock:(WPYTokenizerCompletionBlock)completionBlock;

// By default, Accept-Language will be decided by device's language settings.
// ja if device's language is japanese, and en for any other language.
// If you want to override Accept-Language, use this method.
+ (void)createTokenFromCard:(WPYCreditCard *)card
             acceptLanguage:(NSString *)acceptLanguage
            completionBlock:(WPYTokenizerCompletionBlock)completionBlock;


@end