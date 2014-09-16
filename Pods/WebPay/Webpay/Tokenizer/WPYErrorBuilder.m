//
//  WPYErrorBuilder.m
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// Why different class for building error?
// Creating a NSError instance requires knowledge of error json format
// returned by server.



#import "WPYErrorBuilder.h"

#import "WPYErrors.h"

@implementation WPYErrorBuilder

static NSInteger const WPYCodeNotFound = -1;

#pragma mark helper
static WPYErrorCode errorCodeFromTypeAndCode(NSString *type, NSString *code)
{
    if ([type isEqualToString:@"invalid_request_error"])
    {
        return WPYInvalidRequestError;
    }
    else if([type isEqualToString:@"api_error"])
    {
        return WPYAPIError;
    }
    else if([type isEqualToString:@"card_error"])
    {
        NSDictionary *errorCodeIdentifiers =
        @{
            @"incorrect_number"    : @(WPYIncorrectNumber),
            @"invalid_name"        : @(WPYInvalidName),
            @"invalid_expiry_month": @(WPYInvalidExpiryMonth),
            @"invalid_expiry_year" : @(WPYInvalidExpiryYear),
            @"incorrect_expiry"    : @(WPYIncorrectExpiry),
            @"invalid_cvc"         : @(WPYInvalidCvc),
            @"incorrect_cvc"       : @(WPYIncorrectCvc),
            @"card_declined"       : @(WPYCardDeclined),
            @"processing_error"    : @(WPYProcessingError)
        };
        
        __block WPYErrorCode errorCode = WPYCodeNotFound;
        [errorCodeIdentifiers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            if ([code isEqualToString:key])
            {
                errorCode = [(NSNumber *)obj intValue];
                *stop = YES;
            }
        }];
        
        return errorCode;
    }
    
    return WPYCodeNotFound;
}



- (NSError *)buildErrorFromData:(NSData *)data error:(NSError * __autoreleasing *)outError
{
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:outError];
    
    if (object == nil)
    {
        return nil;
    }
    
    if ([object isKindOfClass:[NSDictionary class]])
    {
        // build error from json
        NSDictionary *json = object;
        NSDictionary *errorDic = json[@"error"];
        
        NSString *type = errorDic[@"type"];
        NSString *code = errorDic[@"code"];
        WPYErrorCode errorCode = errorCodeFromTypeAndCode(type, code);
        
        NSString *errorMessage = errorDic[@"message"];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:errorMessage
                                                                           forKey:NSLocalizedDescriptionKey];
        
        return [[NSError alloc] initWithDomain:WPYErrorDomain code:errorCode userInfo:userInfo];
    }
    
    return nil;
}

@end
