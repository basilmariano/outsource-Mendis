//
//  ArticleDataCheck.h
//  PICClinic
//
//  Created by Wong Johnson on 3/4/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArticleDataCheck : NSManagedObject

@property (nonatomic, retain) NSNumber * articleId;
@property (nonatomic, retain) NSSet *articleData;
@end

@interface ArticleDataCheck (CoreDataGeneratedAccessors)

- (void)addArticleDataObject:(NSManagedObject *)value;
- (void)removeArticleDataObject:(NSManagedObject *)value;
- (void)addArticleData:(NSSet *)values;
- (void)removeArticleData:(NSSet *)values;

@end
