//
//  WPYExpiryAccessoryView.m
//  Webpay
//
//  Created by yohei on 4/25/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryAccessoryView.h"

#import "WPYBundleManager.h"
#import "WPYDeviceSettings.h"

@interface WPYExpiryAccessoryView ()
@end

@implementation WPYExpiryAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
        toolbar.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        
        if ([WPYDeviceSettings isiOS7])
        {
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, frame.size.height - 0.5, frame.size.width, 0.5f);
            bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
            
            [toolbar.layer addSublayer:bottomBorder];
        }
        
        NSString *title = NSLocalizedStringFromTableInBundle(@"Done", WPYLocalizedStringTable, [WPYBundleManager localizationBundle], nil);
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped:)];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSArray *items = @[flex, doneButton];
        
        toolbar.items = items;
        
        [self addSubview:toolbar];
    }
    return self;
}

- (void)doneTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneButtonTapped)])
    {
        [self.delegate doneButtonTapped];
    }
}

@end
