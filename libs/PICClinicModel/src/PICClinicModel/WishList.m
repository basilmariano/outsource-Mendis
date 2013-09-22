//
//  WishList.m
//  PICClinicModel
//
//  Created by Basil Mariano on 9/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "WishList.h"


@implementation WishList

@dynamic createdDate;
@dynamic productCategory;
@dynamic productID;
@dynamic productName;
@dynamic productPrice;
@dynamic articleId;

+ (WishList *)NewWishList
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"WishList" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    WishList *newWishList = [[[WishList alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]] autorelease];
    return newWishList;
}

+ (NSArray *) WishListList
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WishList" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}

@end
