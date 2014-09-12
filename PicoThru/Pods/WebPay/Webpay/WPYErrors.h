//
//  WPYErrors.h
//  Webpay
//
//  Created by yohei on 3/18/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WPYErrorDomain;


// https://webpay.jp/docs/api/curl
// Webpay returns 3 types of errors: card error, invalid request error, and api error
// error code 1xx is assigned to card error, 2xx to invalid request error, and 3xx to api error


typedef NS_ENUM(int, WPYErrorCode){
    // card errors
    WPYIncorrectNumber = 101,
    WPYInvalidName = 102,
    WPYInvalidExpiryMonth = 103,
    WPYInvalidExpiryYear = 104,
    WPYIncorrectExpiry = 105,
    WPYInvalidCvc = 106,
    WPYIncorrectCvc = 107,
    WPYCardDeclined = 108,
    WPYProcessingError = 109,
    
    // invalid request error
    WPYInvalidRequestError = 200,
    
    // api error
    WPYAPIError = 300
};

// HELPER: returns nserror from error code and failure reason
FOUNDATION_EXPORT NSError *WPYCreateNSError(WPYErrorCode errorCode, NSString *failureReason);
