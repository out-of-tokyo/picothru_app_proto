//
//  WPYCardFormView.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPYCreditCard;
@protocol WPYCardFormViewDelegate <NSObject>
@optional
// validation is called every time card value changes.
// card value changes when the textfield is edited
- (void)invalidFormWithError:(NSError *)error;

// called only when the whole form is valid
- (void)validFormWithCard:(WPYCreditCard *)creditCard;
@end


@interface WPYCardFormView : UIView
@property(nonatomic, weak) id <WPYCardFormViewDelegate> delegate;
// designated initializer
// pass card to prefill the fields
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card;
- (void)setFocusToFirstNotfilledField;
@end
