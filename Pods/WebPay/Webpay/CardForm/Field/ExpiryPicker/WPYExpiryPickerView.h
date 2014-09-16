//
//  WPYExpiryPickerView.h
//  Webpay
//
//  Created by yohei on 4/14/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPYExpiryPickerViewDelegate <NSObject>
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month;
@end

@interface WPYExpiryPickerView : UIPickerView
@property(nonatomic, weak) id <WPYExpiryPickerViewDelegate> expiryDelegate;
- (NSString *)selectedExpiry;
@end
