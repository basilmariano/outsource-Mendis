//
//  MASkinQuizViewController.m
//  Mendis
//
//  Created by Wong Johnson on 6/28/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MASkinQuizViewController.h"
#import "PCNavigationController.h"

@interface MASkinQuizViewController ()

@end

@implementation MASkinQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MASkinQuizViewController"];
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
    self.navigationItem.title = @"Skin Quiz";
        [self createBackButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PCNavigationController *nav = (PCNavigationController *)self.navigationController;
    nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_blank.png"];
    // Do any additional setup after loading the view from its nib.
}

- (void)createBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *contentView = [[[UIView alloc]init]autorelease];
    NSString *backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        backButton.frame = CGRectMake(0.0f, 0.0f, 53.0f, 33.5f);
        contentView.frame = backButton.frame;
        
    } else { //IPAD
        
        backButton.frame = CGRectMake(0.0f, 18.0f, 97.0f, 64.0f);
        contentView.frame = CGRectMake(0.0f, 0.0f, 97.0f, 64.0f);
    }
    
    UIImage *customNavigationBarBackButtonImage = [UIImage imageNamed:backImageName];
    [backButton setImage:customNavigationBarBackButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backButton];
    
    UIBarButtonItem *navigationBarBackButton = [[[UIBarButtonItem alloc] initWithCustomView:contentView]autorelease] ;
    self.navigationItem.leftBarButtonItem = navigationBarBackButton;
    
}

- (void)backButtonPressed
{
    PCNavigationController *nav = (PCNavigationController *)self.navigationController;
    nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_Mendis.png"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
