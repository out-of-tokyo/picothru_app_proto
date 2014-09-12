//
//  WPYAbstractCardField.m
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// didFocus
// 1. set color to normal color
// 2. hide checkmark if necessary

// new input ** setting value to textfield is the responsibility of subclass **
// if automatic update
//   textFieldDidChanged: will be called
// else
//   subclass will update the textfield value
//   subclass will call textFieldDidChanged:

// LostFocus
// 1. if shouldValidate validate
// 2. change text color
// 3. change validity view
// 4. if error show error animation

#import "WPYAbstractCardFieldSubclass.h"



static float const WPYShakeWidth = 1.0f;
static float const WPYShakeDuration = 0.03f;
static NSInteger const WPYMaxShakes = 8;


@interface WPYAbstractCardField ()
@end

@implementation WPYAbstractCardField

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // textfield
        _textField = [self createTextFieldWithFrame:frame];
        [self setupTextField];
        [self addSubview:_textField];
        
        [self setupWithCard:card];
    }
    return self;
}



#pragma mark abstract class methods
- (void)setFocus:(BOOL)focus
{
    if (focus)
    {
        [self.textField becomeFirstResponder];
    }
    else
    {
        [self.textField resignFirstResponder];
    }
}

- (void)updateViewToValidity:(BOOL)valid
{
    if (valid)
    {
        [self setNormalColor];
    }
    else
    {
        [self setErrorColor];
        [self startErrorAnimation];
    }
}



#pragma mark protected method
- (void)updateText:(NSString *)text
{
    if (text)
    {
        self.textField.text = text;
        // assigning text directly does NOT fire textFieldDidChange, so fire manually
        [self textFieldValueChanged];
    }
}

- (void)assignText:(NSString *)text
{
    if (text)
    {
        self.textField.text = text;
    }
}



#pragma mark expected to overriden in subclass
#pragma mark initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIImageView *)createRightView
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setupWithCard:(WPYCreditCard *)card
{

}

- (void)setText:(NSString *)text
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}



#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setNormalColor];
    [self textFieldDidFocus];
}

- (void)textFieldDidChanged:(UITextField *)textField
{
    [self textFieldValueChanged];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldWillLoseFocus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark subclass methods: textfield event handler
- (void)textFieldDidFocus
{
}

- (void)textFieldValueChanged
{
}

- (void)textFieldWillLoseFocus
{
}



#pragma mark private methods
- (void)setErrorColor
{
    self.textField.textColor = [UIColor redColor];
}

- (void)setNormalColor
{
    self.textField.textColor = [UIColor colorWithRed:0.01 green:0.04 blue:0.1 alpha:1.0];
}

- (UIFont *)font
{
    return [UIFont fontWithName:@"Avenir-Roman" size:16.0f];
}

- (void)setupTextField
{
    self.textField.font = [self font];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // rightview
    self.rightView = [self createRightView];
    _textField.rightView = self.rightView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
}




#pragma mark error notification animation
- (void)startErrorAnimation
{
    [self shake:WPYMaxShakes
      direction:1
       duration:WPYShakeDuration
     shakeWidth:WPYShakeWidth
  currentShakes:0];
}

- (void)shake:(NSInteger)times
    direction:(NSInteger)direction
     duration:(float)duration
   shakeWidth:(float)width
currentShakes:(NSInteger)shaked
{
    [UIView animateWithDuration:duration
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(width * direction, 0);
                     }
                     completion:^(BOOL finished){
                         if (shaked == times)
                         {
                             self.transform = CGAffineTransformIdentity;
                             return;
                         }
                         
                         [self shake:times
                           direction:direction * -1
                            duration:duration
                          shakeWidth:width
                       currentShakes:shaked + 1];
    }];
}

@end
