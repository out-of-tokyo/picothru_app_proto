//
//  WPYCvcExplanationView.m
//  Webpay
//
//  Created by yohei on 5/8/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//


#import "WPYCvcExplanationView.h"

#import "WPYBundleManager.h"

static float const WPYAnimationDuration = 0.2f;
static float const WPYOverlayOpacity = 0.7f;

@interface WPYCvcExplanationView ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation WPYCvcExplanationView

#pragma mark public methods
+ (void)showAmexCvcExplanation
{
    WPYCvcExplanationView *cvcView = [self sharedView];
    [cvcView.imageView setImage:[WPYBundleManager imageNamed:@"cvcamex"]];
    [self showOverlay:cvcView];
}

+ (void)showNonAmexCvcExplanation
{
    WPYCvcExplanationView *cvcView = [self sharedView];
    [cvcView.imageView setImage:[WPYBundleManager imageNamed:@"cvc"]];
    [self showOverlay:cvcView];
}

+ (void)showOverlay:(WPYCvcExplanationView *)overlay
{
    [[UIApplication sharedApplication].keyWindow addSubview: overlay];
    overlay.layer.opacity = 0.0f;
    
    [UIView animateWithDuration:WPYAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(){
        overlay.layer.opacity = 1.0f;
    } completion:^(BOOL finished){
    }];
}



#pragma mark private methods
// singleton
+ (WPYCvcExplanationView *)sharedView
{
    static dispatch_once_t once;
    static WPYCvcExplanationView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return sharedView;
}

- (void)dismissOverlay
{
    WPYCvcExplanationView *view = [WPYCvcExplanationView sharedView];
    view.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:WPYAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(){
        view.layer.opacity = 0.0f;
    } completion:^(BOOL finished){
        if (finished)
        {
            [view removeFromSuperview];
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:WPYOverlayOpacity];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 130, 280, 168)];
        [self addSubview:self.imageView];
        
        // add gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlay)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}
@end
