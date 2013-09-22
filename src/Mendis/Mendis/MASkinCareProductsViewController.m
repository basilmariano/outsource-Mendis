//
//  MASkinCareProductsViewController.m
//  Mendis
//
//  Created by Basil Mariano on 9/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MASkinCareProductsViewController.h"
#import "WishList.h"
#import "LSMainCell.h"
#import "PCModelWebViewController.h"
#import <MessageUI/MessageUI.h>

@interface MASkinCareProductsViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) UIButton *wishBtn;
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSString *companyId;

@end

@implementation MASkinCareProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = PCNameForDevice(@"MASkinCareProductsViewController");
    self = [super initWithNibName:nibName bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    if (self) {
        // Custom initialization
    }
    
    self.navigationItem.title = @"WishList - List";
    self.navigationItem.rightBarButtonItem = [self rightBarButton];
    self.navigationItem.leftBarButtonItem = [self leftBarButton];
    
    return self;
}

- (UIBarButtonItem *) rightBarButton
{
    UIView *contentView = [[[UIView alloc]init]autorelease];
    
    self.wishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"iphone_AddContacts-s.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"iphone_AddContacts-ss.png"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _wishBtn.frame = CGRectMake(0.0f, 0.0f, 70.0f, 34.5f);
        contentView.frame = _wishBtn.frame;
    } else {
        buttonImage = [UIImage imageNamed:@"ipad_AddContacts-s.png"];
        buttonImagePressed = [UIImage imageNamed:@"ipad_AddContacts-ss.png"];
        
        _wishBtn.frame = CGRectMake(650, 11, 158.0f, 75.5f);
        contentView.frame = _wishBtn.frame;
    }
    
    [_wishBtn addTarget:self action:@selector(onContactsTap) forControlEvents:UIControlEventTouchUpInside];
    [_wishBtn setImage:buttonImage forState:UIControlStateNormal];
    [_wishBtn setImage:buttonImagePressed forState:UIControlStateSelected];
    
    [contentView addSubview:self.wishBtn];
    
    UIBarButtonItem *navigationBarBackButton = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    return navigationBarBackButton;
}

- (UIBarButtonItem *) leftBarButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *contentView = [[[UIView alloc]init]autorelease];
    NSString *backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        contentView.frame = CGRectMake(0, 0.0f, 420.0f, 44.0f);
        backButton.frame = CGRectMake(0.0f, 5.5f, 55.0f, 32.5f);
        
    } else { //IPAD
        contentView.frame = CGRectMake(0, 0.0f, 768, 44.0f);
        backButton.frame = CGRectMake(0.0f, 9.0f, 97.0f, 64.0f);
    }
    UIImage *customNavigationBarBackButtonImage = [UIImage imageNamed:backImageName];
    [backButton setImage:customNavigationBarBackButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backButton];
    
    UIBarButtonItem *navigationBarBackButton = [[[UIBarButtonItem alloc] initWithCustomView:contentView]autorelease] ;
    return navigationBarBackButton;
}

#pragma mark View Life Cycle

- (void) viewWillAppear:(BOOL)animated
{
    if (!self.products) {
        self.products = [[[NSMutableArray alloc] initWithArray:[WishList WishListList]] autorelease];
    } else {
        NSArray *wishListList = [WishList WishListList];
        [self.products removeAllObjects];
        for (WishList *wishList in wishListList) {
            [self.products addObject:wishList];
        }
    }
    
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_tableView release];
    [_wishBtn release];
    [_products release];
    [super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LSMainCell";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellIdentifier = @"LSMainCell~ipad";
    }
    
    LSMainCell *cell = (LSMainCell *) [tableView dequeueReusableCellWithIdentifier:@"LSMainCell"];
    if (cell == nil) {
        cell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"LSMainCell" owner:self options:nil]objectAtIndex:0];
        
    }
    
    cell.arrowImage.hidden = TRUE;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.products.count == 0) {
        return cell;
    }
    
    WishList *wislist = (WishList *) [self.products objectAtIndex:indexPath.row];
    cell.diseaseLabel.text = wislist.productName;
    
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishList *treatmentToDelete = (WishList *) [self.products objectAtIndex:indexPath.row];
    
    [self.products removeObject:treatmentToDelete];
    [[[PCModelManager sharedManager] managedObjectContext] deleteObject:treatmentToDelete];
    [[PCModelManager sharedManager] saveContext];
    
    [tableView reloadData];
    
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 60.0f;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rowHeight = 135.0f;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected index %ld", (long)indexPath.row);
    WishList *w = (WishList *) [self.products objectAtIndex:indexPath.row];
    
    PCModelWebViewController *web = [[[PCModelWebViewController alloc] initWithArticleId:w.articleId andArticleTitle:w.productName andCompanyId:@"17" andBackButtonHiddenFirst:NO]autorelease ];
    
    [self.navigationController pushViewController:web animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //change the BG of the selected cell
   /* NSString *imageName = @"PICClinicModel.bundle/iphone_DP-Dental_ListView1_640x90.jpg";
    if (indexPath.row % 2 == 0) {
        imageName = @"PICClinicModel.bundle/iphone_DP-Dental_ListView2_640x90.jpg";
    }
    UIImageView *celBG = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
    cell.backgroundView = celBG;*/
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self activateMail];
    } else {
        [self call];
    }
}

#pragma mark Email
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
            // alert.message = @"Message Canceled";
            break;
        case MessageComposeResultSent:
            alert.message = @"Message Sent";
            
            [alert show];
            
            break;
        case MessageComposeResultFailed:
            //  alert.message = @"Message Failed";
            break;
        default:
            //  alert.message = @"Message Not Sent";
            break;
    }
    [alert release];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            alert.message = @"Message Canceled";
            break;
        case MFMailComposeResultSaved:
            alert.message = @"Message Saved";
            break;
        case MFMailComposeResultSent:
            alert.message = @"Message Sent";
            
            [alert show];
            
            break;
        case MFMailComposeResultFailed:
            alert.message = @"Message Failed";
            break;
        default:
            alert.message = @"Message Not Sent";
            break;
    }
    [alert release];
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark Private Functions
- (void) onContactsTap
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]autorelease ];
    
    [actionSheet buttonTitleAtIndex: [actionSheet addButtonWithTitle:@"Email"]];
    [actionSheet buttonTitleAtIndex: [actionSheet addButtonWithTitle:@"Call 12345678"]];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)activateMail
{
    NSMutableString *emailMessage = [NSMutableString string];
    NSString *emailSubject = @"Your Subject Here";
    NSString *emailTo = @"Email to here";
    
    for (WishList *product in self.products) {
        [emailMessage appendFormat:@"%@ \n", product.productName ];
    }
    
    emailSubject = [emailSubject stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setMessageBody: emailMessage isHTML:NO];
        [mfViewController setSubject:emailSubject];
        NSArray *recipients = [[NSArray alloc]initWithObjects:emailTo, nil];
        [mfViewController setToRecipients:recipients];
        [recipients release];
        [self presentModalViewController:mfViewController animated:YES];
        [mfViewController release];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
    [_tableView reloadData];
    
}

- (void) call
{
    NSString *phoneNumber = @"09166247686"; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}
@end
