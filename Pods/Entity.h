//
//  Entity.h
//  Pods
//
//  Created by Masaru Iwasa on 2014/09/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Scanitems : NSManagedObject

@property (nonatomic, retain) NSString * names;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * prices;
@property (nonatomic, retain) NSData * prodacts;

@end
