//
//  WPYDeviceSettings.m
//  Webpay
//
//  Created by yohei on 5/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYDeviceSettings.h"

@implementation WPYDeviceSettings
+ (BOOL)isiOS7
{
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
}
+ (NSString *)preferredLanguage
{
    return  [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
}

+ (BOOL)isJapanese
{
    return [[WPYDeviceSettings preferredLanguage] isEqualToString:@"ja"];
}
@end
