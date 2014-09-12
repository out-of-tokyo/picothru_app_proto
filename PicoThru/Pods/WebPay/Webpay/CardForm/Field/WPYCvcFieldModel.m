//
//  WPYCvcFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcFieldModel.h"

#import "WPYCreditCard.h"

static NSUInteger const WPYValidAmexCvcLength = 4;
static NSUInteger const WPYValidNonAmexCvcLength = 3;

@implementation WPYCvcFieldModel

#pragma mark public method
- (NSString *)maskedCvc
{
    NSString *dot = @"●";//unicode
    NSUInteger cvcLength = [self rawCardValue].length;
    NSMutableString *mask = [[NSMutableString alloc] init];
    for (int i = 0; i < cvcLength; i++)
    {
        [mask appendString:dot];
    }
    
    return mask;
}

- (BOOL)isAmex
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:self.card.number];
    return [brand isEqualToString:WPYAmex];
}


#pragma mark accessor
- (void)setCardValue:(NSString *)value
{
    self.card.cvc = value;
}

- (NSString *)rawCardValue
{
    return self.card.cvc;
}


#pragma mark textfield
- (NSString *)formattedTextFieldValue
{
    if ([self rawCardValue].length > 0)
    {
        return [self maskedCvc];
    }
    
    return nil;
}

- (BOOL)canInsertNewValue:(NSString *)newValue
{
    if ([self isAmex])
    {
        return newValue.length <= WPYValidAmexCvcLength;
    }
    else
    {
        return newValue.length <= WPYValidNonAmexCvcLength;
    }
}



#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    NSString *cvc = [self rawCardValue];
    return cvc.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *cvc = [self rawCardValue];
    return [self.card validateCvc:&cvc error:error];
}

@end
