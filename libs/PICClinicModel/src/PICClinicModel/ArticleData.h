//
//  ArticleData.h
//  PICClinic
//
//  Created by Wong Johnson on 3/4/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ArticleDataCheck;

@interface ArticleData : NSManagedObject

@property (nonatomic, retain) NSNumber * articleIdVersion;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * folderPath;
@property (nonatomic, retain) NSNumber * articleId;
@property (nonatomic, retain) ArticleDataCheck *articleDataCheck;

@end
