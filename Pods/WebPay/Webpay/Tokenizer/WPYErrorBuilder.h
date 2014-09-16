//
//  WPYErrorBuilder.h
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//


// This class is responsible for creating NSError from error json returned
// from Webpay API.

#import <Foundation/Foundation.h>

@interface WPYErrorBuilder : NSObject
- (NSError *)buildErrorFromData:(NSData *)data error:(NSError * __autoreleasing *)outError;
@end
