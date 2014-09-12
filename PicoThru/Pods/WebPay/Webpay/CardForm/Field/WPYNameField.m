//
//  WPYNameField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameField.h"

#import "WPYTextField.h"
#import "WPYNameFieldModel.h"
#import "WPYBundleManager.h"

@interface WPYNameField () <UITextFieldDelegate>
@property(nonatomic, strong) WPYNameFieldModel *model;
@end

@implementation WPYNameField

#pragma mark override methods: initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[WPYTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"TARO YAMADA";
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents: UIControlEventEditingChanged];
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
    self.model = [[WPYNameFieldModel alloc] initWithCard:card];
    [self assignText: [self.model formattedTextFieldValue]];
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

@end
