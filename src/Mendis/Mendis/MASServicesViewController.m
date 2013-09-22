//
//  MASServicesViewController.m
//  Mendis
//
//  Created by Jerry on 8/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MASServicesViewController.h"
#import "PCNavigationController.h"

@interface MASServicesViewController ()

@end

@implementation MASServicesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // NSString *nibName = PCNameForDevice(@"MASServicesViewController");
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MASServicesViewController"];
     
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Services";
       // [self createBackButton];
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_blank.png"];
        
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

- (IBAction)slnBtnPress:(id)sender {
    
    PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:@"173" andArticleTitle:[NSString stringWithFormat:@"Our Targeted Approach %d",[sender tag]] andCompanyId:@"17" andBackButtonHiddenFirst:NO]autorelease];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}
- (IBAction)rejuvenationPressed:(id)sender {
    
    PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:@"32"andGroupListTitle:@"Rejuvenation" andCompanyId:@"17" andChangeNavigationBackground:NO]autorelease];
    
    [self.navigationController pushViewController:modelTableViewController animated:YES];
    
}
- (IBAction)tighteningPressed:(id)sender {
    
    PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:@"37"andGroupListTitle:@"Tightening" andCompanyId:@"17" andChangeNavigationBackground:NO]autorelease];
    
    [self.navigationController pushViewController:modelTableViewController animated:YES];
    
    
}
- (IBAction)facialPressed:(id)sender {
    
    PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:@"33"andGroupListTitle:@"Facial Sculpting" andCompanyId:@"17" andChangeNavigationBackground:NO]autorelease];
    
    [self.navigationController pushViewController:modelTableViewController animated:YES];
    
    
}
- (IBAction)bodyShapePressed:(id)sender {
    
    PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:@"34"andGroupListTitle:@"Body Shaping" andCompanyId:@"17" andChangeNavigationBackground:NO]autorelease];
    
    [self.navigationController pushViewController:modelTableViewController animated:YES];
    
}
- (IBAction)concernPressed:(id)sender {
    
    PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:@"36"andGroupListTitle:@"Aesthetic Concern" andCompanyId:@"17" andChangeNavigationBackground:NO]autorelease];
    
    [self.navigationController pushViewController:modelTableViewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
