//
//  WPYCvcFieldModel.h
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPYAbstractFieldModel.h"

@interface WPYCvcFieldModel :WPYAbstractFieldModel
- (NSString *)maskedCvc;
- (BOOL)isAmex;
@end
