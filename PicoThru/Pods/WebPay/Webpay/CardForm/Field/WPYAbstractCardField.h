//
//  WPYAbstractCardField.h
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// This class acts as a view & a controller.

#import <UIKit/UIKit.h>


@class WPYCreditCard;
@class WPYAbstractFieldModel;

@interface WPYAbstractCardField : UIView <UITextFieldDelegate>
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIImageView *rightView;

//designated initializer
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card;

// abstract class methods(common procedures)
- (void)setFocus:(BOOL)focus;
- (void)textFieldDidChanged:(UITextField *)textField;
- (void)updateViewToValidity:(BOOL)valid;

// methods expected to be overridden by subclass
// initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame;
- (UIImageView *)createRightView;
- (void)setupWithCard:(WPYCreditCard *)card;
- (void)setText:(NSString *)text;

// template methods
- (void)textFieldDidFocus;
- (void)textFieldValueChanged;
- (void)textFieldWillLoseFocus;
@end
