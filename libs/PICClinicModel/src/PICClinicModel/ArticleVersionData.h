//
//  ArticleVersionData.h
//  PICClinic
//
//  Created by Wong Johnson on 2/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ArticleVersionCheck;

@interface ArticleVersionData : NSManagedObject

@property (nonatomic, retain) NSNumber * articleId;
@property (nonatomic, retain) NSNumber * articleVersion;
@property (nonatomic, retain) ArticleVersionCheck *articleVersionCheck;

@end
