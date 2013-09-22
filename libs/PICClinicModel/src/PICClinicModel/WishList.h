//
//  WishList.h
//  PICClinicModel
//
//  Created by Basil Mariano on 9/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WishList : NSManagedObject

@property (nonatomic, retain) NSNumber * createdDate;
@property (nonatomic, retain) NSString * productCategory;
@property (nonatomic, retain) NSString * productID;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productPrice;
@property (nonatomic, retain) NSString * articleId;

+ (WishList *)NewWishList;
+ (NSArray *) WishListList;

@end
