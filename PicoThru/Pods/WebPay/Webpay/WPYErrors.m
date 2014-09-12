//
//  WPYErrors.m
//  Webpay
//
//  Created by yohei on 3/18/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYErrors.h"

#import "WPYBundleManager.h"

// apple's recommendation com.company.framework_or_app.ErrorDomain
// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/ErrorHandling/ErrorHandling.html
NSString *const WPYErrorDomain = @"com.webpay.webpay-token-ios";


NSString * WPYLocalizedDescriptionFromErrorCode(WPYErrorCode errorCode)
{
    NSBundle *bundle = [WPYBundleManager localizationBundle];
    switch (errorCode)
    {
        case WPYIncorrectNumber:
            return NSLocalizedStringFromTableInBundle(@"The card number is incorrect. Make sure you entered the correct card number.", WPYLocalizedStringTable, bundle, nil);
            
        case WPYInvalidName:
            return NSLocalizedStringFromTableInBundle(@"The name provided is invalid. Make sure the name entered matches your credit card.", WPYLocalizedStringTable, bundle, nil);
            
        case WPYInvalidExpiryMonth:
            return NSLocalizedStringFromTableInBundle(@"The expiry month provided is invalid. Make sure the expiry month entered matches your credit card.", WPYLocalizedStringTable, bundle, nil);
            
        case WPYInvalidExpiryYear:
            return NSLocalizedStringFromTableInBundle(@"The expiry year provided is invalid. Make sure the expiry year entered matches your credit card.", WPYLocalizedStringTable, bundle, nil);
            
        case WPYIncorrectExpiry:
            return NSLocalizedStringFromTableInBundle(@"The card's expiry is incorrect. Make sure you entered the correct expiration date.", WPYLocalizedStringTable, bundle, nil);
            
        case WPYInvalidCvc:
            return NSLocalizedStringFromTableInBundle(@"The security code provided is invalid. For Visa, MasterCard, JCB, and Diners Club, enter the last 3 digits on the back of your card. For American Express, enter the 4 digits printed above your number.", WPYLocalizedStringTable, bundle, nil);
            
        case WPYIncorrectCvc:
        case WPYCardDeclined:
        case WPYProcessingError:
        case WPYInvalidRequestError:
        case WPYAPIError:
            // errors that will return from server. Use error message in http response.
            return nil;
            
    }
}

NSError *WPYCreateNSError(WPYErrorCode errorCode, NSString *failureReason)
{
    NSString *localizedDescription = WPYLocalizedDescriptionFromErrorCode(errorCode);
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:localizedDescription
                                                                       forKey:NSLocalizedDescriptionKey];
    if (failureReason)
    {
        userInfo[NSLocalizedFailureReasonErrorKey] = failureReason;
    }
    
    return [[NSError alloc] initWithDomain:WPYErrorDomain code:errorCode userInfo:userInfo];
}
