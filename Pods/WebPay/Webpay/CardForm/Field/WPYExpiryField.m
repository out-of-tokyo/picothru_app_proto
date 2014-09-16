//
//  WPYExpiryField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryField.h"

#import "WPYExpiryPickerView.h"
#import "WPYExpiryAccessoryView.h"
#import "WPYMenuDisabledTextField.h"
#import "WPYExpiryFieldModel.h"
#import "WPYBundleManager.h"

@interface WPYExpiryField () <UITextFieldDelegate, WPYExpiryPickerViewDelegate, WPYExpiryAccessoryViewDelegate>
@property(nonatomic, strong) WPYExpiryFieldModel *model;
@property(nonatomic, strong) WPYExpiryPickerView *expiryPickerView;
@end

@implementation WPYExpiryField



#pragma mark override methods: initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    self.expiryPickerView = [[WPYExpiryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.expiryPickerView.expiryDelegate = self;
        
    WPYExpiryAccessoryView *accessoryView = [[WPYExpiryAccessoryView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 44)];
    accessoryView.delegate = self;
        
    UITextField *textField = [[WPYMenuDisabledTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"01 / 2018";
    
    textField.inputView = self.expiryPickerView;
    textField.inputAccessoryView = accessoryView;
    
    textField.delegate = self;
        
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [checkMarkView setImage:[WPYBundleManager imageNamed:@"checkmark"]];
    checkMarkView.hidden = YES;
    
    return checkMarkView;
}

- (void)setupWithCard:(WPYCreditCard *)card
{
    self.model = [[WPYExpiryFieldModel alloc] initWithCard:card];
    [self assignText:[self.model formattedTextFieldValue]];
}

- (void)setText:(NSString *)text
{
    [self.model setCardValue:text];
    [self assignText:[self.model formattedTextFieldValue]];
}


#pragma mark override methods: textfield
- (void)textFieldDidFocus
{
    self.rightView.hidden = YES;
}

- (void)textFieldValueChanged
{
    [self.model setCardValue:self.textField.text];
}

- (void)textFieldWillLoseFocus
{
    [self setText:[self.expiryPickerView selectedExpiry]];
    
    if (![self.model shouldValidateOnFocusLost])
    {
        return;
    }
    
    NSError *error = nil;
    BOOL isValid = [self.model validate:&error];
    
    [self updateViewToValidity:isValid];
    [self toggleCheckMark:isValid];
}

- (void)toggleCheckMark:(BOOL)valid
{
    self.rightView.hidden = !valid;
}



#pragma mark expiry picker delegate
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month
{
    NSString *expiry = [NSString stringWithFormat:@"%@ / %@", month, year];
    [self setText:expiry];
}



#pragma mark expiry accessory view delegate
- (void)doneButtonTapped
{
    [self setText:[self.expiryPickerView selectedExpiry]];
    [self.textField resignFirstResponder];
}


@end
