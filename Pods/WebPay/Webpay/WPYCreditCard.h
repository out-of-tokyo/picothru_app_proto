//
//  WPYCreditCard.h
//  Webpay
//
//  Created by yohei on 3/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WPYVisa;
FOUNDATION_EXPORT NSString *const WPYMasterCard;
FOUNDATION_EXPORT NSString *const WPYAmex;
FOUNDATION_EXPORT NSString *const WPYDiscover;
FOUNDATION_EXPORT NSString *const WPYJCB;
FOUNDATION_EXPORT NSString *const WPYDiners;
FOUNDATION_EXPORT NSString *const WPYUnknown;

typedef NS_ENUM(NSUInteger, WPYMonth) {
    WPYJanuary = 1,
    WPYFebruary,
    WPYMarch,
    WPYApril,
    WPYMay,
    WPYJune,
    WPYJuly,
    WPYAugust,
    WPYSeptember,
    WPYOctober,
    WPYNovember,
    WPYDecember
};

@interface WPYCreditCard : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *cvc;
@property(nonatomic, assign) NSInteger expiryMonth;
@property(nonatomic, assign) NSInteger expiryYear;

+ (NSString *)brandNameFromPartialNumber:(NSString *)number;
+ (BOOL)isSupportedBrand:(NSString *)brand;

- (NSString *)brandName;
- (NSString *)expiryInString;

// validate each property
- (BOOL)validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL)validateNumber:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL)validateCvc:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL)validateExpiryMonth:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL)validateExpiryYear:(id *)ioValue error:(NSError * __autoreleasing *)outError;

// validate expiry
- (BOOL)validateExpiryYear:(NSUInteger)year month:(WPYMonth)month error:(NSError * __autoreleasing *)error;

// validate the card
- (BOOL)validate:(NSError * __autoreleasing *)error;
@end
