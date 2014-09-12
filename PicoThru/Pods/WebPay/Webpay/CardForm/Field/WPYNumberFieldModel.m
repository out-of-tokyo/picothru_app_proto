//
//  WPYNumberFieldModel.m
//  Webpay
//
//  Created by yohei on 5/4/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberFieldModel.h"

#import "WPYCreditCard.h"
#import "WPYBundleManager.h"

static NSUInteger const WPYNonAmexNumberMaxLength = 16;
static NSUInteger const WPYAmexNumberMaxLength = 15;
static NSUInteger const WPYDinersNumberMaxLength = 14;

@implementation WPYNumberFieldModel

#pragma mark helpers
static NSString *stripWhitespaces(NSString *string)
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

static NSString *removeAllWhitespaces(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

static NSString *addSpacesPerFourCharacters(NSString *string)
{
    NSMutableString *spacedString = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:(NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
                                {
                                        int place = (int)substringRange.location + 1;
                                        if (place % 4 == 0 && place != WPYNonAmexNumberMaxLength)
                                        {
                                            [spacedString appendString:[NSString stringWithFormat:@"%@ ", substring]];
                                        }
                                        else
                                        {
                                            [spacedString appendString:substring];
                                        }
                                }
    ];
    
    return spacedString;
}

static NSString *addSpacesToAmexAndDinersNumber(NSString *number)
{
    NSMutableString *spacedString = [NSMutableString stringWithCapacity:number.length];
    [number enumerateSubstringsInRange:NSMakeRange(0, number.length)
                               options:(NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         int place = (int)substringRange.location + 1;
         if (place == 4 || place == 10)
         {
             [spacedString appendString:[NSString stringWithFormat:@"%@ ", substring]];
         }
         else
         {
             [spacedString appendString:substring];
         }
     }
     ];
    
    return spacedString;
}

static BOOL isValidLength(NSString *number)
{
    NSString *canonicalizedNumber = removeAllWhitespaces(number);
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:WPYAmex])
    {
        return canonicalizedNumber.length <= WPYAmexNumberMaxLength;
    }
    else if([brand isEqualToString:WPYDiners])
    {
        return canonicalizedNumber.length <= WPYDinersNumberMaxLength;
    }
    else
    {
        return canonicalizedNumber.length <= WPYNonAmexNumberMaxLength;
    }
}

static NSString *addPaddingToNumber(NSString *number)
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:WPYAmex] || [brand isEqualToString:WPYDiners])
    {
        return addSpacesToAmexAndDinersNumber(number);
    }
    else
    {
        return addSpacesPerFourCharacters(number);
    }
}



#pragma mark brand
+ (UIImage *)brandLogoFromNumber:(NSString *)number
{
    NSString *brandName = [self brandFromNumber:number];
    return [WPYNumberFieldModel imageOfBrand:brandName];
}

+ (NSString *)brandFromNumber:(NSString *)number
{
    return [WPYCreditCard brandNameFromPartialNumber:number];
}

+ (UIImage *)imageOfBrand:(NSString *)brand
{
    if (![WPYCreditCard isSupportedBrand:brand])
    {
        return nil;
    }
    return [WPYBundleManager imageNamed:removeAllWhitespaces(brand)];
}

+ (NSString *)reformatNumber:(NSString *)number position:(NSUInteger)position isDeleted:(BOOL)isDeleted
{
    NSString *rawNumber = number;
    
    BOOL isSpaceDeleted = isDeleted && [self isSpaceWithNumber:number position:position];
    if (isSpaceDeleted)
    {
        // remove digit right before space
        // 1234_5678 will be 123_5678
        rawNumber = [NSString stringWithFormat:@"%@%@", [rawNumber substringToIndex:position - 1],[rawNumber substringFromIndex:position]];
    }
    
    NSString *canonicalizedNumber = removeAllWhitespaces(rawNumber);
    NSString *paddedNumber = addPaddingToNumber(canonicalizedNumber);
    if (isDeleted)
    {
        paddedNumber = stripWhitespaces(paddedNumber);
    }
    
    return paddedNumber;
}


+ (BOOL)isDigitAfterSpace:(NSString *)number position:(NSUInteger)position
{
    if (position == 0 )
    {
        return NO;
    }
    
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:WPYAmex] || [brand isEqualToString:WPYDiners])
    {
        return (position == 5 || position == 12);
    }
    else
    {
        return (position % 5 == 0 && position != 20);
    }
}

+ (BOOL)isSpaceWithNumber:(NSString *)number position:(NSUInteger)position
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:WPYAmex] || [brand isEqualToString:WPYDiners])
    {
        return (position == 4 || position == 11);
    }
    else
    {
        return (position % 5 == 4 && position != 19);
    }
}

+ (BOOL)isDigitBeforeSpace:(NSString *)number position:(NSUInteger)position
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:WPYAmex] || [brand isEqualToString:WPYDiners])
    {
        return (position == 3 || position == 10);
    }
    else
    {
        return (position % 5 == 3 && position != 18);
    }
}


#pragma mark accessors
- (void)setCardValue:(NSString *)value
{
    self.card.number = removeAllWhitespaces(value);
}

- (NSString *)rawCardValue
{
    return self.card.number;
}

#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    return self.card.number.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *number = self.card.number;
    return [self.card validateNumber:&number error:error];
}



#pragma mark textfield
- (NSString *)formattedTextFieldValue
{
    if (self.card.number)
    {
        return addPaddingToNumber(self.card.number);
    }
    return nil;
}

- (BOOL)canInsertNewValue:(NSString *)newValue
{
    return isValidLength(newValue);
}

@end
