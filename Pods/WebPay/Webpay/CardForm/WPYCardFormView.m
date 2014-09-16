//
//  WPYCardFormView.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// Responsibility: create subviews

#import "WPYCardFormView.h"

#import "WPYCreditCard.h"

#import "WPYCardFormCell.h"

#import "WPYAbstractCardField.h"
#import "WPYNumberField.h"
#import "WPYExpiryField.h"
#import "WPYCvcField.h"
#import "WPYNameField.h"

#import "WPYBundleManager.h"


@interface WPYCardFormView () <UITableViewDataSource,UITableViewDelegate>
// card info holder
@property(nonatomic, strong) WPYCreditCard *creditCard;

// tableview
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *contentViews;
@end

static float const WPYFieldRightMargin = 10.0f; // for leaving right margin to rightview
static float const WPYFieldLeftMargin = 100.0f;
static float const WPYFieldTopMargin = 4.0f;
static float const WPYFieldWidth = 320.0f - WPYFieldLeftMargin - WPYFieldRightMargin;
static float const WPYFieldHeight = 45.0f;

static float const WPYCellHeight = 50.0f;


@implementation WPYCardFormView
#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card
{
    if (self = [super initWithFrame:frame])
    {
        _creditCard = card ? card : [[WPYCreditCard alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        NSBundle *bundle = [WPYBundleManager localizationBundle];
        _titles = @[NSLocalizedStringFromTableInBundle(@"Number", WPYLocalizedStringTable, bundle, nil),
                    NSLocalizedStringFromTableInBundle(@"Expiry", WPYLocalizedStringTable, bundle, nil),
                    NSLocalizedStringFromTableInBundle(@"CVC", WPYLocalizedStringTable, bundle, nil),
                    NSLocalizedStringFromTableInBundle(@"Name", WPYLocalizedStringTable, bundle, nil)
                    ];
        
        // contentViews
        CGRect fieldFrame = CGRectMake(WPYFieldLeftMargin, WPYFieldTopMargin, WPYFieldWidth, WPYFieldHeight);
        WPYAbstractCardField *numberField = [[WPYNumberField alloc] initWithFrame:fieldFrame card:_creditCard];
        WPYAbstractCardField *expiryField = [[WPYExpiryField alloc] initWithFrame:fieldFrame card:_creditCard];
        WPYAbstractCardField *cvcField = [[WPYCvcField alloc] initWithFrame:fieldFrame card:_creditCard];
        WPYAbstractCardField *nameField = [[WPYNameField alloc] initWithFrame:fieldFrame card:_creditCard];
        
        _contentViews = @[numberField, expiryField, cvcField, nameField];
        
        [self subscribe];
    }
    return self;
}

// override designated initializer of superclass
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame card:nil];
}

- (void)dealloc
{
    [self unsubscribe];
}



#pragma mark kvo
- (void)subscribe
{
    [self.creditCard addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(name))
                         options:NSKeyValueObservingOptionInitial
                         context:nil];
    
    [self.creditCard addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(number))
                         options:NSKeyValueObservingOptionInitial
                         context:nil];
    
    [self.creditCard addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(cvc))
                         options:NSKeyValueObservingOptionInitial
                         context:nil];
    
    [self.creditCard addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(expiryMonth))
                         options:NSKeyValueObservingOptionInitial
                         context:nil];
    
    [self.creditCard addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(expiryYear))
                         options:NSKeyValueObservingOptionInitial
                         context:nil];
}

- (void)unsubscribe
{
    [self.creditCard removeObserver:self forKeyPath:NSStringFromSelector(@selector(name))];
    [self.creditCard removeObserver:self forKeyPath:NSStringFromSelector(@selector(number))];
    [self.creditCard removeObserver:self forKeyPath:NSStringFromSelector(@selector(cvc))];
    [self.creditCard removeObserver:self forKeyPath:NSStringFromSelector(@selector(expiryMonth))];
    [self.creditCard removeObserver:self forKeyPath:NSStringFromSelector(@selector(expiryYear))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self validate];
}

- (void)validate
{
    NSError *error = nil;
    if ([self.creditCard validate: &error])
    {
        [self notifyDelegateValidForm:self.creditCard];
    }
    else
    {
        [self notifyDelegateError:error];
    }
}



#pragma mark public method
- (void)setFocusToFirstNotfilledField
{
    [self.contentViews enumerateObjectsUsingBlock:^(WPYAbstractCardField *field, NSUInteger idx, BOOL *stop){
        if (field.textField.text.length == 0)
        {
            [field setFocus:YES];
            *stop = YES;
        }
    }];
}



#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (WPYCardFormCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WPYCardFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WPYCardFormCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier
                                          contentView:self.contentViews[indexPath.row]
                                                title:self.titles[indexPath.row]];
                
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WPYCellHeight;
}



#pragma mark notify delegate
- (void)notifyDelegateValidForm:(WPYCreditCard *)creditCard
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(validFormWithCard:)])
    {
        [self.delegate validFormWithCard:creditCard];
    }
}

- (void)notifyDelegateError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(invalidFormWithError:)])
    {
        [self.delegate invalidFormWithError:error];
    }
}



#pragma mark hide keyboards
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
