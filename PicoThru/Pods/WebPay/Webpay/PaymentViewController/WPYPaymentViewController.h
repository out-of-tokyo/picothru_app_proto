//
//  WPYPaymentViewController.h
//  Webpay
//
//  Created by yohei on 4/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPYToken;
@class WPYCreditCard;
@class WPYPaymentViewController;
typedef void (^WPYPaymentViewCallback)(WPYPaymentViewController *paymentViewController, WPYToken *token, NSError *error);


@interface WPYPaymentViewController : UIViewController
{
    WPYCreditCard *_card;
    WPYPaymentViewCallback _callback;

    BOOL _isKeyboardDisplayed;
    NSArray *_titles;
    UITableView *_tableView;
    NSMutableArray *_contentViews;

    NSString *_priceTag;
    
    UIButton *_payButton;
    UIActivityIndicatorView *_indicator;
}


// designated initializer
- (instancetype)initWithPriceTag:(NSString *)priceTag // price tag should include currency unit. i.e) $1.00
                            card:(WPYCreditCard *)card // card properties will be used to populate textfield
                        callback:(WPYPaymentViewCallback)callback;

// If you don't need to provide initial values for form fields, use this initializer
- (instancetype)initWithPriceTag:(NSString *)priceTag
                        callback:(WPYPaymentViewCallback)callback;

- (void)setPayButtonComplete;
- (void)dismissAfterDelay:(NSTimeInterval)delay;
- (void)popAfterDelay:(NSTimeInterval)delay;
@end
