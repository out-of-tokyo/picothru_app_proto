//
//  WPYBundleManager.h
//  Webpay
//
//  Created by yohei on 5/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WPYLocalizedStringTable;


@interface WPYBundleManager : NSObject
+ (NSBundle *)localizationBundle;
+ (UIImage *)imageNamed:(NSString *)name;
@end
