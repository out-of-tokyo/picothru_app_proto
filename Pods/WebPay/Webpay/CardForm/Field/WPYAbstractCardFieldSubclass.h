//
//  WPYAbstractCardFieldSubclass.h
//  Webpay
//
//  Created by yohei on 5/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYAbstractCardField.h"

@interface WPYAbstractCardField ()
// setText: setter for client.
// udpateText: setter for subclasses. It calls textFieldValueChanged
- (void)updateText:(NSString *)text;

// assignText: setter for subclasses. It just sets text
- (void)assignText:(NSString *)text;
@end
