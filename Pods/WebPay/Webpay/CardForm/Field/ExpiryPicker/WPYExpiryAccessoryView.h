//
//  WPYExpiryAccessoryView.h
//  Webpay
//
//  Created by yohei on 4/25/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPYExpiryAccessoryViewDelegate <NSObject>
- (void)doneButtonTapped;
@end

@interface WPYExpiryAccessoryView : UIView
@property(nonatomic, weak) id <WPYExpiryAccessoryViewDelegate> delegate;
@end
