//
//  WPYCreditCard.m
//  Webpay
//
//  Created by yohei on 3/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCreditCard.h"
#import "WPYErrors.h"

NSString *const WPYVisa = @"Visa";
NSString *const WPYMasterCard = @"MasterCard";
NSString *const WPYAmex = @"American Express";
NSString *const WPYDiscover = @"Discover";
NSString *const WPYJCB = @"JCB";
NSString *const WPYDiners = @"Diners";
NSString *const WPYUnknown = @"Unknown";

@implementation WPYCreditCard

#pragma mark helpers
static void handleValidationError(NSError * __autoreleasing * error, WPYErrorCode errorCode, NSString *failureReason)
{
    if (error)
    {
        *error = WPYCreateNSError(errorCode, failureReason);
    }
}

static BOOL isLuhnValidString(NSString *string)
{
    int sum = 0;
    NSString *reversedStr = reverseString(string);
    for (int i = 0; i < reversedStr.length; i++)
    {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedStr characterAtIndex:i]] intValue];
        if (i % 2 != 0)
        {
            digit *= 2;
            if (digit > 9)
            {
                digit -= 9;
            }
        }
        
        sum += digit;
    }
    
    return (sum % 10 == 0);
}

static BOOL isNumericOnlyString(NSString *string)
{
    NSCharacterSet *setOfNumbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *setFromString = [NSCharacterSet characterSetWithCharactersInString: string];
    return [setOfNumbers isSupersetOfSet: setFromString];
}

static BOOL isMatchWithRegex(NSString *string, NSString *regex)
{
    NSRange range = [string rangeOfString:regex options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

// trim whitespace from first and last character
static NSString *stripWhitespaces(NSString *string)
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

static NSString *canonicalizeCardNumber(NSString *string)
{
    return removeHyphens(removeAllWhitespaces(string));
}

// remove all occurences of whitespace
static NSString *removeAllWhitespaces(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

static NSString *removeHyphens(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

static NSString *reverseString(NSString *string)
{
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                            [reversedString appendString:substring];
                                        }];
    
    return reversedString;
}



#pragma mark class methods
+ (NSString *)brandNameFromPartialNumber:(NSString *)number
{
    if (number == nil || number.length < 2)
    {
        return WPYUnknown;
    }
    
    NSInteger prefix = [[number substringWithRange:NSMakeRange(0, 2)] integerValue];
    
    if (40 <= prefix && prefix < 50)
    {
        return WPYVisa;
    }
    
    if (50 <= prefix && prefix <= 55)
    {
        return WPYMasterCard;
    }
    
    if (prefix == 34 || prefix == 37)
    {
        return WPYAmex;
    }
    
    if (prefix == 30 || prefix == 36 || prefix == 38 || prefix == 39)
    {
        return WPYDiners;
    }
    
    if (prefix == 35)
    {
        return WPYJCB;
    }
    
    if (prefix == 60 || prefix == 62 || prefix == 64 || prefix == 65)
    {
        return WPYDiscover;
    }
    
    return WPYUnknown;
}

+ (BOOL)isSupportedBrand:(NSString *)brand
{
    NSArray *supportedBrands = @[WPYVisa, WPYAmex, WPYMasterCard, WPYJCB, WPYDiners];
    return [supportedBrands containsObject:brand];
}


#pragma mark public methods
- (void)setNumber:(NSString *)number
{
    _number = canonicalizeCardNumber(number);
}

- (NSString *)brandName
{
    NSString *cardNumber = self.number;
    if (!cardNumber)
    {
        return nil;
    }
    
    NSDictionary *brandIdentifiers =
    @{
        WPYVisa            : @"4[0-9]{12}(?:[0-9]{3})?",
        WPYAmex            : @"3[47][0-9]{13}",
        WPYMasterCard      : @"5[1-5][0-9]{14}",
        WPYDiscover        : @"6(?:011|5[0-9]{2})[0-9]{12}",
        WPYJCB             : @"(?:2131|1800|35\\d{3})\\d{11}",
        WPYDiners          : @"3(?:0[0-5]|[68][0-9])[0-9]{11}"
    };
    
    __block NSString *brandName = nil;
    
    [brandIdentifiers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if (isMatchWithRegex(cardNumber, obj))
        {
            brandName = key;
            *stop = YES;
        }
    }];
    return brandName ? brandName : WPYUnknown;
}

- (NSString *)expiryInString
{
    if (self.expiryYear && self.expiryMonth)
    {
        return [NSString stringWithFormat:@"%02u / %@", self.expiryMonth, @(self.expiryYear)];
    }
    
    return nil;
}



#pragma mark validation methods
- (BOOL)validateName:(__autoreleasing id *)ioValue error:(NSError *__autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        handleValidationError(outError, WPYInvalidName, @"Name should not be nil.");
        return NO;
    }
    
    NSString *trimmedStr = stripWhitespaces((NSString *) *ioValue);
    if (trimmedStr.length == 0)
    {
        handleValidationError(outError, WPYInvalidName, @"Name should not be empty.");
        return NO;
    }
    
    return YES;
}


- (BOOL)validateNumber:(__autoreleasing id *)ioValue error:(NSError *__autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        handleValidationError(outError, WPYIncorrectNumber, @"Number should not be nil.");
        return NO;
    }
    
    NSString *cleansedStr = canonicalizeCardNumber((NSString *) *ioValue);
    
    if (!(isNumericOnlyString(cleansedStr)))
    {
        handleValidationError(outError, WPYIncorrectNumber, @"Number should be numeric only.");
        return NO;
    }
    
    if (cleansedStr.length < 13 || cleansedStr.length > 16)
    {
        handleValidationError(outError, WPYIncorrectNumber, @"Number should be 13 digits to 16 digits.");
        return NO;
    }
    
    if (!isLuhnValidString(cleansedStr))
    {
        handleValidationError(outError, WPYIncorrectNumber, @"This number is not Luhn valid string.");
        return NO;
    }
    
    return YES;
}


- (BOOL)validateCvc:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        handleValidationError(outError, WPYInvalidCvc, @"cvc should not be nil.");
        return NO;
    }
    
    NSString *trimmedStr = stripWhitespaces((NSString *) *ioValue);
    if (!(isNumericOnlyString(trimmedStr)))
    {
        handleValidationError(outError, WPYInvalidCvc, @"cvc should be numeric only.");
        return NO;
    }
    
    NSString *brand = [self brandName];
    BOOL isAmex = [brand isEqualToString:WPYAmex];
    
    if (!brand)
    {
        if (trimmedStr.length < 3 || 4 < trimmedStr.length)
        {
            handleValidationError(outError, WPYInvalidCvc, @"cvc should be 3 or 4 digits.");
            return NO;
        }
    }
    else
    {
        if (isAmex && trimmedStr.length != 4)
        {
            handleValidationError(outError, WPYInvalidCvc, @"cvc for amex card should be 4 digits.");
            return NO;
        }
        
        if (!isAmex && trimmedStr.length != 3)
        {
            handleValidationError(outError, WPYInvalidCvc, @"cvc for non amex card should be 3 digits.");
            return NO;
        }
    }
    
    return YES;
}


- (BOOL)validateExpiryMonth:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        handleValidationError(outError, WPYInvalidExpiryMonth, @"Expiry month should not be nil.");
        return NO;
    }
    
    NSUInteger expiryMonth = [(NSNumber *) *ioValue intValue];
    if (expiryMonth < 1 || 12 < expiryMonth)
    {
        handleValidationError(outError, WPYInvalidExpiryMonth, @"Expiry month should be a number between 1 to 12.");
        return NO;
    }
    return YES;
}


- (BOOL)validateExpiryYear:(__autoreleasing id *)ioValue error:(NSError *__autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        handleValidationError(outError, WPYInvalidExpiryYear, @"Expiry year should not be nil.");
        return NO;
    }
    
    return YES;
}


- (BOOL)validateExpiryYear:(NSUInteger)year month:(WPYMonth)month error:(NSError * __autoreleasing *)error;
{
    // first day of expiry month's next month
    // i.e if expiry is 2014/2, expiryDate is 2014/3/1
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:year];
    [dateComps setMonth:month + 1];
    [dateComps setDay: 1];

    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *expiryDate = [gregorianCal dateFromComponents:dateComps];
    NSDate *now = [NSDate date];

    if (!([now compare: expiryDate] == NSOrderedAscending))
    {
        handleValidationError(error, WPYIncorrectExpiry, @"This card is expired.");
        return NO;
    }
    return YES;
}

- (BOOL)validateBrand:(NSString *)brand error:(NSError * __autoreleasing *)error
{
    if (![self.class isSupportedBrand:brand])
    {
        handleValidationError(error, WPYIncorrectNumber, @"This brand is not supported by Webpay.");
        return NO;
    }
    return YES;
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *name = self.name;
    NSString *number = self.number;
    NSString *cvc = self.cvc;
    NSNumber *expiryYear = @(self.expiryYear);
    NSNumber *expiryMonth = @(self.expiryMonth);
    
    // number check must come before brand check so that developer gets more appropriate error message
    return [self validateName:&name error:error]
        && [self validateNumber:&number error:error]
        && [self validateCvc:&cvc error:error]
        && [self validateExpiryYear:&expiryYear error:error]
        && [self validateExpiryMonth:&expiryMonth error:error]
        && [self validateExpiryYear:self.expiryYear month:self.expiryMonth error:error]
        && [self validateBrand:[self brandName] error:error];
}


@end
