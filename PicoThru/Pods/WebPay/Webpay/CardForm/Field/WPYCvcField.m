//
//  WPYCvcField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcField.h"

#import "WPYTextField.h"
#import "WPYCvcExplanationView.h"
#import "WPYCvcFieldModel.h"
#import "WPYBundleManager.h"

@interface WPYCvcField () <UITextFieldDelegate>
@property(nonatomic, strong) WPYCvcFieldModel *model;
@property(nonatomic, strong) UIButton *transparentButton;
@end

@implementation WPYCvcField


#pragma mark override methods: initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[WPYTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"123";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearsOnBeginEditing = NO;
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents: UIControlEventEditingChanged];
    textField.delegate = self;
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightView.userInteractionEnabled = YES;
    return rightView;
}

- (void)setupWithCard:(WPYCreditCard *)card
{
    self.model = [[WPYCvcFieldModel alloc] initWithCard:card];
    [self assignText:[self.model formattedTextFieldValue]];
    
    self.transparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.transparentButton.frame = CGRectMake(170, 0, 40, 44);
    [self.transparentButton addTarget:self action:@selector(showCvcInfoView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.transparentButton];
    
    [self showQuestionIcon];
}

- (void)setText:(NSString *)text
{
    [self.model setCardValue:text];
    [self assignText:[self.model formattedTextFieldValue]];
}



#pragma mark textField
- (void)textFieldDidFocus
{
    [self showQuestionIcon];
    
    // avoid firing textFieldDidChange
    self.textField.text = [self.model rawCardValue];
}

- (void)textFieldValueChanged
{
    [self.model setCardValue:self.textField.text];
}

- (void)textFieldWillLoseFocus
{
    // avoid firing textFieldDidChange so that masks will not be assigned to card value.
    [self assignText:[self.model maskedCvc]];
    
    if (![self.model shouldValidateOnFocusLost])
    {
        return;
    }
    
    NSError *error = nil;
    BOOL isValid = [self.model validate:&error];
    
    [self updateViewToValidity:isValid];
    [self toggleRightView:isValid];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    return [self.model canInsertNewValue:newValue];
}



#pragma mark right view
- (void)toggleRightView:(BOOL)valid
{
    if (valid)
    {
        [self showCheckMark];
    }
    else
    {
        [self showQuestionIcon];
    }
}

- (void)showCheckMark
{
    [self.rightView setImage:[WPYBundleManager imageNamed:@"checkmark"]];
    self.transparentButton.enabled = NO;
}

- (void)showQuestionIcon
{
    [self.rightView setImage:[WPYBundleManager imageNamed:@"question"]];
    self.transparentButton.enabled = YES;
}



#pragma mark cvc info
- (void)showCvcInfoView
{
    if ([self.model isAmex])
    {
        [WPYCvcExplanationView showAmexCvcExplanation];
    }
    else
    {
        [WPYCvcExplanationView showNonAmexCvcExplanation];
    }
}

@end
