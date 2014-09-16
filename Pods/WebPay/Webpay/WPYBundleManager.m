//
//  WPYBundleManager.m
//  Webpay
//
//  Created by yohei on 5/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYBundleManager.h"

#import "WPYDeviceSettings.h"

NSString *const WPYLocalizedStringTable = @"WebpayiOSTokenizer";
NSString *const WPYBundleName = @"WebPay";

@implementation WPYBundleManager
+ (NSBundle *)sharedBundle
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WebPay" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}

+ (NSBundle *)localizationBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *webpayBundle = nil;
    dispatch_once(&onceToken, ^{
        NSString *language = [WPYDeviceSettings isJapanese] ? @"ja" : @"en";
        NSString *path = [NSString stringWithFormat:@"Localization/%@", language];
        webpayBundle = [NSBundle bundleWithPath:[[self sharedBundle] pathForResource:path ofType:@"lproj"]];
    });
    return webpayBundle;
}


+ (UIImage *)imageNamed:(NSString *)name
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"WebPay.bundle/Images/%@", name]];
}
@end
