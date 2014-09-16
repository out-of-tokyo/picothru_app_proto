//
//  WPYExpiryFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryFieldModel.h"

@implementation WPYExpiryFieldModel

#pragma mark helper
static NSString *removeAllWhitespaces(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}



#pragma mark accessor
- (void)setCardValue:(NSString *)value
{
    NSString *canonicalizedExpiry = removeAllWhitespaces(value);
    NSRange range = [canonicalizedExpiry rangeOfString:@"/"];
    NSUInteger location = range.location;
    if (canonicalizedExpiry.length > 0 && location != NSNotFound)
    {
        self.card.expiryMonth = [[canonicalizedExpiry substringToIndex:location] integerValue];
        self.card.expiryYear = [[canonicalizedExpiry substringFromIndex:location + 1] integerValue];
    }
}

- (NSString *)rawCardValue
{
    return [self.card expiryInString];
}



#pragma mark textfield
- (NSString *)formattedTextFieldValue
{
    return [self rawCardValue];
}



#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    NSString *expiry = [self rawCardValue];
    return expiry.length == 9; // don't valid if both not selected
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    return [self.card validateExpiryYear:self.card.expiryYear month:self.card.expiryMonth error:error];
}

@end
