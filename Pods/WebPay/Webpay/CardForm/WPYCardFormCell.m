//
//  WPYCardFormCell.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCardFormCell.h"

#import "WPYDeviceSettings.h"

@interface WPYCardFormCell ()
@property(nonatomic, strong) UILabel *titleLabel;// default textlabel of cell has weird behaviors with frame size.
@end

@implementation WPYCardFormCell
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        contentView:(UIView *)contentView
              title:(NSString *)title
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cell
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        // text label
        float x = [WPYDeviceSettings isiOS7] ? 15 : 10;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 1, 80, 48)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0];
        _titleLabel.font = [self textFont];
        
        // adjust line height
        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setLineSpacing:5];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [title length])];
        _titleLabel.attributedText = attributedString;
        
        [self.contentView addSubview:_titleLabel];
        
        [self.contentView addSubview: contentView];
    }
    return self;
}

- (UIFont *)textFont
{
    if ([WPYDeviceSettings isJapanese])
    {
        return [UIFont fontWithName:@"HiraKakuProN-W3" size:13.0f];
    }
    else
    {
        return [UIFont fontWithName:@"Avenir-Roman" size:16.0f];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
