//
//  PCAppointmentViewController.m
//  PICClinic
//
//  Created by Panfilo Mariano Jr. on 5/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCAppointmentTableViewController.h"
#import "PCAppointmentCell.h"
#import "PCAppointmentViewController.h"
#import "PCLocalNotification.h"

@interface PCAppointmentTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *appointmentList;

@end

@implementation PCAppointmentTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName =  [[XCDeviceManager manager] xibNameForDevice:@"PCAppointmentTableViewController"];
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Appointments";
        self.appointmentList = [[[NSMutableArray alloc] init] autorelease];
        
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
    return self.appointmentList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *CellIdentifier = @"PCAppointmentCell";
    
    PCAppointmentCell *tbCell = (PCAppointmentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    if(self.appointmentList.count == 0)
        return tbCell;
    
    Appointment *appointment = (Appointment *) [self.appointmentList objectAtIndex:indexPath.row];
    
    NSDate *appointmentTime = [NSDate dateWithTimeIntervalSince1970:[appointment.appointmentTime doubleValue]];
    NSDateFormatter *appointmentTimeFormatter =[[[NSDateFormatter alloc] init] autorelease];
    appointmentTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [appointmentTimeFormatter setDateFormat:@"hh:mm aa"];
    NSString *appointmentTimeString = [appointmentTimeFormatter stringFromDate:appointmentTime];
    
    NSDate *appointmentDate = [NSDate dateWithTimeIntervalSince1970:[appointment.appointmentDate doubleValue]];
    NSDateFormatter *appointmentDateFomatter = [[[NSDateFormatter alloc] init] autorelease];
    [appointmentDateFomatter setDateFormat:@"dd/MM/yyyy"];
    NSString *appointmentDateString = [appointmentDateFomatter stringFromDate:appointmentDate];
    
    tbCell.clientName.text = appointment.clientName;
    tbCell.scheduleDate.text = appointmentDateString;
    tbCell.scheduleTime.text =  appointmentTimeString;
    
    return tbCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Appointment *appointment = (Appointment *) [self.appointmentList objectAtIndex:indexPath.row];
    PCAppointmentViewController *appointmentViewController = [[[PCAppointmentViewController alloc] initWithNavigationTitle:@"Appointment" andAppointment:appointment] autorelease];
    [self.navigationController pushViewController:appointmentViewController animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Appointment *appointment = (Appointment *) [self.appointmentList objectAtIndex:indexPath.row];
    NSDate *dateTime = [NSDate date];
    
    if([appointment.fireDate doubleValue] < [dateTime timeIntervalSince1970]) {
        cell.backgroundColor = [UIColor grayColor];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Appointment *appointment = (Appointment *) [self.appointmentList objectAtIndex:indexPath.row];
    [self.appointmentList removeObject:appointment];
    [[PCLocalNotification sharedInstance] deleteNotificationWithAppointment:appointment fromNotification:nil];
    NSManagedObject *object = appointment;
    [[[PCModelManager sharedManager] managedObjectContext] deleteObject:object];
    [[PCModelManager sharedManager] saveContext];
    [self retrieveAppointmentList];
}

#pragma mark createdFunctions

- (void) sortAppointments
{
    if(self.appointmentList.count >= 2 || self.appointmentList.count == 0) {
    [_appointmentList sortUsingComparator:^NSComparisonResult(Appointment * a1, Appointment * a2) {
        NSComparisonResult result = [a1.appointmentDate compare:a2.appointmentDate];
        if (result != NSOrderedSame) return result;
        return [a1.appointmentTime compare:a2.appointmentTime];
    }];
    
    [_tableView reloadData];
    }
}

- (void) retrieveAppointmentList
{
    NSArray *appointments = [Appointment appointmentList];
    if(appointments.count == 0) {
        [_tableView reloadData];
        return;
    }
    
    for(Appointment *app in appointments) {
        Appointment *appHandler = nil;
        for(Appointment *app2 in self.appointmentList) {
            if([app isEqual:app2]) {
                appHandler = app;
            }
        }
        
        if(!appHandler)
            [self.appointmentList addObject:app];
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
    PCAppointmentViewController *appointmentViewController = [[PCAppointmentViewController alloc] initWithNavigationTitle:@"Add Appointment" andAppointment:nil];
    [self.navigationController pushViewController:appointmentViewController animated:YES];
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
