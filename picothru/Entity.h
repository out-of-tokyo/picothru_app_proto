//
//  Entity.h
//  picothru
//
//  Created by 谷村元気 on 2014/09/18.
//  Copyright (c) 2014年 Masaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * names;
@property (nonatomic, retain) NSNumber * prices;
@property (nonatomic, retain) NSData * prodacts;
@property (nonatomic, retain) NSNumber * number;

@end
