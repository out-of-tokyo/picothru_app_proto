//
//  WPYCardFormCell.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPYCardFormCell : UITableViewCell

// designated initializer
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        contentView:(UIView *)contentView
              title:(NSString *)title;
@end
