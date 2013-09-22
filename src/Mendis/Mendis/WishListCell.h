//
//  WishListCell.h
//  PICClinicModel
//
//  Created by Jerry on 8/29/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *productNameTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *productPriceTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *productThumbnail;

@end
