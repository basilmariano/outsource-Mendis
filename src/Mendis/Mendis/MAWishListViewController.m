//
//  MAWishListViewController.m
//  Mendis
//
//  Created by Jerry on 8/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MAWishListViewController.h"
#import "WishListCell.h"
#import "WishList.h"

//#import "PCAppointmentViewController.h"

@interface MAWishListViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *wishList;
@property (nonatomic, retain) UIButton *backButton;

@end

@implementation MAWishListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  //  NSString *nibName =  [[XCDeviceManager manager] xibNameForDevice:@"MAWishListViewController"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   //   self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"WishList";
        self.wishList = [[[NSMutableArray alloc] init] autorelease];
        
        NSString *addImageNormalName = nil;
        UIView *customViewAdd = [[[UIView alloc] init] autorelease];
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            addImageNormalName = @"AddBtn-s";
            btnAdd.frame = CGRectMake(0, 0, 65, 33.5);
            customViewAdd.frame = btnAdd.frame;
            
        } else { //IPAD
            addImageNormalName = @"AddBtn-ipad-s";
            btnAdd.frame = CGRectMake(0, 18, 129, 64.0f);
            customViewAdd.frame = CGRectMake(0, 0, 129, 64.0f);
        }
        
        UIImage *addImageNormal = [UIImage imageNamed:addImageNormalName];
        [btnAdd setBackgroundImage:addImageNormal forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(onAddAppointmentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [customViewAdd addSubview:btnAdd];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:customViewAdd];
        self.navigationItem.rightBarButtonItem = doneButton;
        
    }
    return self;
}

- (void) dealloc
{
    [_tableView release];
    [super dealloc];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wishList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WishListCell";
    
    WishListCell *tbCell = (WishListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    if(self.wishList.count == 0)
        return tbCell;
    
    WishList *appointment = (WishList *) [self.wishList objectAtIndex:indexPath.row];
    
//    NSDate *appointmentTime = [NSDate dateWithTimeIntervalSince1970:[appointment.appointmentTime doubleValue]];
//    NSDateFormatter *appointmentTimeFormatter =[[[NSDateFormatter alloc] init] autorelease];
//    appointmentTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [appointmentTimeFormatter setDateFormat:@"hh:mm aa"];
//    NSString *appointmentTimeString = [appointmentTimeFormatter stringFromDate:appointmentTime];
    
    NSDate *appointmentDate = [NSDate dateWithTimeIntervalSince1970:[appointment.createdDate doubleValue]];
    NSDateFormatter *appointmentDateFomatter = [[[NSDateFormatter alloc] init] autorelease];
    [appointmentDateFomatter setDateFormat:@"dd/MM/yyyy"];
    NSString *appointmentDateString = [appointmentDateFomatter stringFromDate:appointmentDate];
    
    tbCell.productNameTxt.text = appointment.productName;
    tbCell.productPriceTxt.text = appointment.productPrice;
 //   tbCell.createdTxt.text = appointmentDateString;
   // tbCell.scheduleTime.text =  appointmentTimeString;
    
    return tbCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WishList *appointment = (WishList *) [self.appointmentList objectAtIndex:indexPath.row];
//    PCAppointmentViewController *appointmentViewController = [[[PCAppointmentViewController alloc] initWithNavigationTitle:@"Appointment" andAppointment:appointment] autorelease];
//    [self.navigationController pushViewController:appointmentViewController animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   // Wishlist *wishlist = (Wishlist *) [self.wishList objectAtIndex:indexPath.row];
// //   NSDate *dateTime = [NSDate date];
//    
////    if([appointment.fireDate doubleValue] < [dateTime timeIntervalSince1970]) {
////        cell.backgroundColor = [UIColor grayColor];
////    }
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishList *wishlist = (WishList *) [self.wishList objectAtIndex:indexPath.row];
    [self.wishList removeObject:wishlist];
  //  [[PCLocalNotification sharedInstance] deleteNotificationWithAppointment:appointment fromNotification:nil];
    NSManagedObject *object = wishlist;
    [[[PCModelManager sharedManager] managedObjectContext] deleteObject:object];
    [[PCModelManager sharedManager] saveContext];
    [self retrieveAppointmentList];
}

#pragma mark createdFunctions

- (void) sortAppointments
{
    if(self.wishList.count >= 2 || self.wishList.count == 0) {
        [_wishList sortUsingComparator:^NSComparisonResult(WishList *a1, WishList *a2) {
            
            NSComparisonResult result = [a1.createdDate compare:a2.createdDate];
            if (result != NSOrderedSame) return result;
            return [a1.createdDate compare:a2.createdDate];
        }];
        
        [_tableView reloadData];
    }
}

- (void) retrieveAppointmentList
{
    NSArray *wishlist = [WishList WishListList];
    NSLog(@"%i" , wishlist.count);
    
    if(wishlist.count == 0) {
        [_tableView reloadData];
        return;
    }
    
    for(WishList *app in wishlist) {
        WishList *appHandler = nil;
        for(WishList *app2 in self.wishList) {
            if([app isEqual:app2]) {
                appHandler = app;
            }
        }
        
        if(!appHandler)
            [self.wishList addObject:app];
    }
    
    [self sortAppointments];
    
    [_tableView reloadData];
}

#pragma mark viewLifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [self retrieveAppointmentList];
}

- (void) onAddAppointmentButtonClicked
{
//    PCAppointmentViewController *appointmentViewController = [[PCAppointmentViewController alloc] initWithNavigationTitle:@"Add Appointment" andAppointment:nil];
//    [self.navigationController pushViewController:appointmentViewController animated:YES];
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



@end
