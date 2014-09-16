//
//  WPYPaymentViewControllerSubclass.h
//  Webpay
//
//  Created by yohei on 5/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYPaymentViewController.h"

@interface WPYPaymentViewController ()
@property(nonatomic, strong) WPYCreditCard *card;
@property(nonatomic, copy) WPYPaymentViewCallback callback;

@property(nonatomic, copy) NSString *priceTag;

@property(nonatomic) BOOL isKeyboardDisplayed;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *contentViews;

@property(nonatomic, strong) UIButton *payButton;
@property(nonatomic, strong) UIActivityIndicatorView *indicator;

- (CGRect)fieldFrame;

- (UIView *)createPriceView;
- (UIButton *)createPayButton;
- (void)payButtonPushed:(id)sender;
- (void)startIndicator;
- (void)stopIndicator;

- (void)subscribeToKeyboardNotification;
- (void)unsubscribeToKeyboardNotification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)dismissKeyboard;

- (void)subscribeToCardChange;
- (void)unsubscribeToCardChange;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;

- (void)validate;
- (void)validForm;
- (void)invalidFormWithError:(NSError *)error;

@end
