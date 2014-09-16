//
//  Entity.h
//  picothru
//
//  Created by Masaru Iwasa on 2014/09/12.
//  Copyright (c) 2014年 Masaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Scanitems : NSManagedObject

@property (nonatomic, retain) NSString * prodacts;
@property (nonatomic, retain) NSString * names;
@property (nonatomic, retain) NSString * prices;

@end
