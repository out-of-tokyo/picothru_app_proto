//
//  WPYTokenBuilder.m
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYTokenBuilder.h"

#import "WPYToken.h"

@implementation WPYTokenBuilder

- (WPYToken *)buildTokenFromData:(NSData *)data error:(NSError * __autoreleasing *)outError
{
    NSError *serializeError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&serializeError];
    
    if (object == nil)
    {
        if (outError)
        {
            *outError = serializeError;
        }
        return nil;
    }
    
    if ([object isKindOfClass:[NSDictionary class]])
    {
        // build WPYToken from json
        NSDictionary *json = object;
        
        WPYToken *token = [[WPYToken alloc] initWithID:json[@"id"]
                                              cardInfo:json[@"card"]];
        
        return token;
    }
    
    return nil;
}

@end