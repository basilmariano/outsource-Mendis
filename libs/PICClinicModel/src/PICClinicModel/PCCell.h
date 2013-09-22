//
//  PCCell.h
//  PICClinic
//
//  Created by Wong Johnson on 3/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCell : UITableViewCell
@property (nonatomic, assign) IBOutlet PCAsyncImageView *asyncImageView;
@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) IBOutlet UIView *dimmerView;

@end
