//
//  ArticleVersionCheck.h
//  PICClinic
//
//  Created by Wong Johnson on 2/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArticleVersionCheck : NSManagedObject

@property (nonatomic, retain) NSString * articles;
@property (nonatomic, retain) NSSet *articleVersionData;
@end

@interface ArticleVersionCheck (CoreDataGeneratedAccessors)

- (void)addArticleVersionDataObject:(NSManagedObject *)value;
- (void)removeArticleVersionDataObject:(NSManagedObject *)value;
- (void)addArticleVersionData:(NSSet *)values;
- (void)removeArticleVersionData:(NSSet *)values;

@end
