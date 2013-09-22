//
//  SOcialShareViewController.h
//  PICClinicModel
//
//  Created by Sil on 6/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"

@interface SOcialShareViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *btnFacebook;
@property (nonatomic, retain) IBOutlet UIButton *btnTwitter;
@property (nonatomic, retain) IBOutlet UIButton *btnSms;
@property (nonatomic, retain) NSObject *parent;
@property (nonatomic, retain) FPPopoverController *popOverController;

-(IBAction)onBtnFacebookClicked:(id)sender;
-(IBAction)onBtnTwitterClicked:(id)sender;
-(IBAction)onBtnSmsClicked:(id)sender;

@end
