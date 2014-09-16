//
//  WPYNameFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameFieldModel.h"

@implementation WPYNameFieldModel

#pragma mark accessor
- (void)setCardValue:(NSString *)value
{
    self.card.name = value;
}

- (NSString *)rawCardValue
{
    return self.card.name;
}


#pragma mark textfield
- (NSString *)formattedTextFieldValue
{
    return [self rawCardValue];
}



#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    NSString *name = [self rawCardValue];
    return name.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *name = [self rawCardValue];
    return [self.card validateName:&name error:error];
}

@end
