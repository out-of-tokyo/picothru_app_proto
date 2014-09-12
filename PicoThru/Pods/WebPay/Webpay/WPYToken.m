//
//  WPYToken.m
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYToken.h"

@implementation WPYToken

- (instancetype)initWithID:(NSString *)tokenID cardInfo:(NSDictionary *)cardInfo
{
    if (self = [super init])
    {
        _tokenId = tokenID;
        _cardInfo = cardInfo;
    }
    
    return self;
}
@end
