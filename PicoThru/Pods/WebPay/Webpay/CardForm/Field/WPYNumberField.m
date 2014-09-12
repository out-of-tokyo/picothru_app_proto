//
//  WPYNumberField.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberField.h"

#import "WPYTextField.h"
#import "WPYCreditCard.h"
#import "WPYNumberFieldModel.h"


@interface WPYNumberField () <UITextFieldDelegate>
@property(nonatomic, strong) WPYNumberFieldModel *model;
@end

@implementation WPYNumberField

#pragma mark initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[WPYTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"1234 5678 9012 3456";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *brandView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    return brandView;
}

- (void)setupWithCard:(WPYCreditCard *)card
{
    self.model = [[WPYNumberFieldModel alloc] initWithCard:card];
    
    [self assignText:[self.model formattedTextFieldValue]];
}

- (void)setText:(NSString *)text
{
    [self.model setCardValue:text];
    [self assignText:[self.model formattedTextFieldValue]];
    [self updateBrand];
}


#pragma mark textfield
- (void)textFieldValueChanged
{
    [self.model setCardValue:self.textField.text];
    [self updateBrand];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    BOOL isDigitDeleted = replacementString.length == 0;
    
    NSUInteger location = range.location;
    if ([self.model canInsertNewValue:newValue])
    {
        [self updateText:[WPYNumberFieldModel reformatNumber:newValue position:location isDeleted:isDigitDeleted]];
        
        
        // adjust cursor position when a characted added or deleted from the middle of text
        BOOL isSpace = [WPYNumberFieldModel isSpaceWithNumber:newValue position:location];
        if (isDigitDeleted)
        {
            // check if cursor is at end to determine digit in the middle was deleted or not
            BOOL isDigitAfterSpace = [WPYNumberFieldModel isDigitAfterSpace:newValue position:location];
            
            // location is the position of deleted digit.
            // if digit after space is deleted, space will be deleted as well
            NSUInteger currentCursorLocation = isDigitAfterSpace ? location - 2 : location - 1;
            BOOL isEmpty = textField.text.length == 0;
            BOOL isCursorAtEnd = (currentCursorLocation == self.textField.text.length - 1 || isEmpty); //position is 0 based
            if (!isCursorAtEnd) // deleted digit in the middle
            {
                // location of cursor is usually same is the deleted digit location
                // 123|4 -> 12|4 (deleted digit location:2, correct cursor position 2)
                // if digit after space is deleted, space will be deleted so -1
                // if space is deleted, the digit before space will be deleted so -1
                NSUInteger correctCusrorLocation = (isDigitAfterSpace || isSpace) ? location - 1 : location;
                
                UITextRange *cursorRange = [textField selectedTextRange];
                UITextPosition *correctPosition = [textField positionFromPosition:cursorRange.start offset:correctCusrorLocation - textField.text.length];
                textField.selectedTextRange = [textField textRangeFromPosition:correctPosition toPosition:correctPosition];
            }
        }
        else
        {
            BOOL isDigitBeforeSpace = [WPYNumberFieldModel isDigitBeforeSpace:newValue position:range.location];
            
            // if digitBeforeSpace text will be padded
            NSUInteger currentCursorLocation = isDigitBeforeSpace ? location + 1 : location;
            BOOL isCursorAtEnd = currentCursorLocation == self.textField.text.length - 1; //location is 0 based.
            if (!isCursorAtEnd)
            {
                // usually add one to current location since it's added(12|4 -> 123|4)
                // if at space(1234| -> 1234 5|) or before space(123|4 5 -> 1230 |45) add 2
                NSUInteger cursorLocation = (isDigitBeforeSpace || isSpace) ? location + 2 : location + 1;
                UITextRange *cursorRange = [textField selectedTextRange];
                UITextPosition *correctPosition = [textField positionFromPosition:cursorRange.start offset:cursorLocation - textField.text.length];
                textField.selectedTextRange = [textField textRangeFromPosition:correctPosition toPosition:correctPosition];
            }
        }
    }
    
    return NO;
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
    
    if (!isValid)
    {
        [self hideBrandLogo];
    }
}



#pragma mark brand animation
// brand logo also work as checkmark.
- (void)updateBrand
{
    UIImage *brandLogo = [WPYNumberFieldModel brandLogoFromNumber: self.textField.text];
    if (brandLogo)
    {
        [self showBrandLogo:brandLogo];
    }
    else
    {
        [self hideBrandLogo];
    }
}

- (void)showBrandLogo:(UIImage *)logo
{
    self.rightView.hidden = NO;
    [self.rightView setImage:logo];
}

- (void)hideBrandLogo
{
    self.rightView.hidden = YES;
}

@end
