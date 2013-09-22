//
//  PCAppointmentViewController.m
//  PICClinic
//
//  Created by Panfilo Mariano Jr. on 5/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCAppointmentViewController.h"
#import "Appointment.h"
#import "ManageObjectModel.h"
#import "PCLocalNotification.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

typedef enum
{
    PCListPicker,
    PCDatePicker,
    PCTimePicker
}
PickerType;

@interface PCAppointmentViewController () <UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic) PickerType pickerType;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) Appointment *appointment;
@property (nonatomic, retain) NSNumber *timeInSecs;
@property (nonatomic, retain) NSObject *objectClicked;

@end

@implementation PCAppointmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"PCAppointmentViewController"];
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Add Appointment";
    }
    return self;
}

- (id)initWithNavigationTitle: (NSString *)title andAppointment:(Appointment *)appointment
{
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"PCAppointmentViewController"];;
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        
        self.appointment = appointment;
        
        NSString *backImageName = nil;
        UIView *customView = [[[UIView alloc] init] autorelease];
        UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            backImageName = @"CancelBtn-s";
            btnback.frame = CGRectMake(0.0f, 0.0f, 63.5f, 33.5f);
            customView.frame = btnback.frame;
            
        } else { //IPAD
            backImageName = @"CancelBtn-ipad-s";
            btnback.frame = CGRectMake(0.0f, 18.0f, 136.0f, 64.0f);
            customView.frame = CGRectMake(0.0f, 0.0f, 136.0f, 64.0f);
        }
        
        UIImage *BackImage = [UIImage imageNamed:backImageName];
        [btnback setBackgroundImage:BackImage forState:UIControlStateNormal];
        [btnback addTarget:self action:@selector(onCancelAppointmentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [customView addSubview:btnback];
        UIBarButtonItem *bckButton = [[UIBarButtonItem alloc]initWithCustomView:customView];
        self.navigationItem.leftBarButtonItem = bckButton;
        
        NSString *doneImageNormalName = nil;
        UIView *customViewDone = [[[UIView alloc] init] autorelease];
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            doneImageNormalName = @"Done_btn-s-1";
            btnDone.frame = CGRectMake(0.0f, 0.0f, 65.0f, 33.5f);
            customViewDone.frame = btnDone.frame;
            
        } else { //IPAD
            doneImageNormalName = @"ipad_Done_btn-s";
            btnDone.frame = CGRectMake(0.0f, 18.0f, 129.0f, 64.0f);
            customViewDone.frame = CGRectMake(0.0f, 0.0f, 129.0f, 64.0f);
        }
        
        UIImage *doneImageNormal = [UIImage imageNamed:doneImageNormalName];
        [btnDone setBackgroundImage:doneImageNormal forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(onDoneAppointmentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [customViewDone addSubview:btnDone];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:customViewDone];
        self.navigationItem.rightBarButtonItem = doneButton;

        self.navigationItem.title = title;
    }
    return self;
}

- (void) dealloc
{
    [_appointmentDate release];
    [_appointmentTime release];
    [_reminderAlert release];
    [_buttonAppointmentDate release];
    [_buttonAppointmentTime release];
    [_buttonReminderAlert release];
    [_textFieldClientName release];
    [_textFieldDoctorName release];
    [_popOver release];
    [_pickerView release];
    [_actionSheet release];
    [_appointment release];
    [_timeInSecs release];
    
    [_textFieldPhoneNumber release];
    [_textViewMessage release];
    [super dealloc];
}

#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case 0: {
            return @"30 minutes";
            break;
        }
        case 1: {
            return @"1 Hour";
            break;
        }
        case 2: {
            return @"3 Hours";
            break;
        }
        case 3: {
            return @"1 Day";
            break;
        }
    }
    return nil;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textFieldClientName resignFirstResponder];
    [_textFieldDoctorName resignFirstResponder];
    return  YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark selector buttons
- (void) onDoneAppointmentButtonClicked
{
    if(([self.appointmentDate.text isEqualToString:@""] || [self.appointmentTime.text isEqualToString:@""] || [self.reminderAlert.text isEqualToString:@""] || [self.textFieldClientName.text isEqualToString:@""] || [self.textFieldDoctorName.text isEqualToString:@""])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Please fill up all fields" delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        
        NSDate *reminderTime = nil;
        NSDate *reminderDate = nil;
        NSDate *reminderfireDate = nil;
        
        NSDateFormatter *reminderDateFormatter =[[[NSDateFormatter alloc] init] autorelease];
        reminderDateFormatter.timeZone = _datePicker.timeZone;
        [reminderDateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSDateFormatter *reminderTimeFormatter =[[[NSDateFormatter alloc] init] autorelease];
        reminderTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [reminderTimeFormatter setDateFormat:@"hh:mm aa"];
        
        reminderDate = [reminderDateFormatter dateFromString:self.appointmentDate.text];
        reminderTime = [NSDate dateWithTimeIntervalSince1970:[self.timeInSecs doubleValue]];
        //reminderTime = [reminderTimeFormatter dateFromString:self.appointmentTime.text];
        reminderfireDate = [self fireDate];
        
        NSNumber *reminderDateSecs = [NSNumber numberWithDouble:[reminderDate timeIntervalSince1970]];
        NSNumber *reminderTimeSecs = [NSNumber numberWithDouble:[reminderTime timeIntervalSince1970]];
        NSNumber *fireDate         = [NSNumber numberWithDouble:[reminderfireDate timeIntervalSince1970]];
        
        if(!self.appointment) {
            
            Appointment *appointment = [Appointment appointment];
            appointment.clientName = self.textFieldClientName.text;
            appointment.doctorName = self.textFieldDoctorName.text;
            appointment.appointmentDate = reminderDateSecs;
            appointment.appointmentTime = reminderTimeSecs;
            appointment.mobileNumber = self.textFieldPhoneNumber.text;
            appointment.fireDate = fireDate;
            appointment.reminderAlert =  self.reminderAlert.text;
            appointment.notes = self.textViewMessage.text;
            
            [self activateMail:appointment];
            [[PCModelManager sharedManager] saveContext];
            [[PCLocalNotification sharedInstance] scheduleNotificationWithFireDate:reminderfireDate andMedicine:appointment];
            
        } else {
            
            self.appointment.clientName = self.textFieldClientName.text;
            self.appointment.doctorName = self.textFieldDoctorName.text;
            self.appointment.mobileNumber = self.textFieldPhoneNumber.text;
            self.appointment.appointmentDate = reminderDateSecs;
            self.appointment.appointmentTime = reminderTimeSecs;
            self.appointment.reminderAlert =  self.reminderAlert.text;
            self.appointment.notes = self.textViewMessage.text;
            
            NSDate *appointmentFireDate = [NSDate dateWithTimeIntervalSince1970:[self.appointment.fireDate doubleValue]];
            if(![reminderfireDate isEqual:appointmentFireDate]) {
                
                [[PCLocalNotification sharedInstance] cancelNotificationWithAppointment:self.appointment andFireDate:appointmentFireDate];
                self.appointment.fireDate = fireDate;
                [[PCLocalNotification sharedInstance] scheduleNotificationWithFireDate:reminderfireDate andMedicine:self.appointment];
            }
            [self activateMail:self.appointment];
            [[PCModelManager sharedManager] saveContext];
    
        }
        
        //NSString *alertMessage = [NSString stringWithFormat:@"Added appointment with %@ at %@, %@\n",self.textFieldDoctorName.text,self.appointmentDate.text,self.appointmentTime.text];
   //     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Appointment Added" message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
//        [alert buttonTitleAtIndex:[alert addButtonWithTitle:@"Ok"]];
//        [alert show];
//        [alert release];
    }
}

- (void ) onCancelAppointmentButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)okTapped:(NSObject *)sender
{
    switch (self.pickerType) {
        case PCDatePicker: {
            
            NSDate *date = self.datePicker.date;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            
            NSString *strDate = [dateFormat stringFromDate:date];
            self.appointmentDate.text = strDate;
            
            [dateFormat release];
            break;
        }
        case PCTimePicker: {
            
            NSDate *date = self.datePicker.date;
            self.timeInSecs = [NSNumber numberWithDouble:[date timeIntervalSince1970]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormat setDateFormat:@"hh:mm aa"];
            
            NSString *strTime = [dateFormat stringFromDate:date];
            self.appointmentTime.text = strTime;
            
            [dateFormat release];
            break;
        }
            
        case PCListPicker: {
            
            NSString *pickedItemList = nil;
            switch ([_pickerView selectedRowInComponent:0]) {
                case 0: {
                    pickedItemList = @"30 minutes";
                    break;
                }
                case 1: {
                    pickedItemList = @"1 Hour";
                    break;
                }
                case 2: {
                    pickedItemList = @"3 Hours";
                    break;
                }
                case 3: {
                    pickedItemList = @"1 Day";
                    break;
                }
                    
            }
            
            self.reminderAlert.text = pickedItemList;
            break;
        }
    }
    
    [self dismissResponders];
}

- (void)cancelTapped:(NSObject *)sender
{
    [self dismissResponders];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textFieldClientName resignFirstResponder];
    [self.textFieldDoctorName resignFirstResponder];
}

- (void) dismissResponders
{
    if(_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:0 animated:NO];
        self.actionSheet = nil;
    }
    
    if(_datePicker)
        self.datePicker = nil;
    if(_pickerView) {
        self.pickerView = nil;
    }
    
    if(_popOver) {
        [_popOver dismissPopoverAnimated:YES];
        self.popOver = nil;
    }
    
}

#pragma mark IBOutlets
-(IBAction)onButtonAppointmentDateClicked:(id)sender
{
    UIButton *button = (UIButton *) sender;
    self.pickerType = PCDatePicker;
    [self showPickerActionSheet:@"Appointment Date" andObjectView: button];
}
-(IBAction)onbuttonAppointmentTimeClicked:(id)sender
{
    UIButton *button = (UIButton *) sender;
    self.pickerType = PCTimePicker;
    [self showPickerActionSheet:@"Appointment Time" andObjectView: button];
}
-(IBAction)onbuttonReminderAlertClicked:(id)sender
{
    UIButton *button = (UIButton *) sender;
    self.pickerType = PCListPicker;
    [self showPickerActionSheet:@"Reminder Time" andObjectView: button];
}

#pragma mark personal fuctions
- (UIPickerView *)listPickerForActionSheet
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        return [pickerView autorelease];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 25, 700, 220)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        return [pickerView autorelease];
        
    }
    return  nil;
}

- (UIDatePicker *)datePickerForActionSheet
{
    if ([[XCDeviceManager manager] deviceType] == iPhone4_Device || [[XCDeviceManager manager] deviceType] == iPhone5_Device) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
        
        if(self.pickerType == PCDatePicker) {
            [datePicker setMinimumDate:[NSDate date]];
            datePicker.datePickerMode = UIDatePickerModeDate;
        } else if (self.pickerType == PCTimePicker) {
            datePicker.datePickerMode = UIDatePickerModeTime;
            datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        }
        
        datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
        
        return [datePicker autorelease];
    } else if ([[XCDeviceManager manager] deviceType] == iPad_Device) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10,25, 700, 220)];
        
        
        if(self.pickerType == PCDatePicker) {
            [datePicker setMinimumDate:[NSDate date]];
            datePicker.datePickerMode = UIDatePickerModeDate;
        } else if (self.pickerType == PCTimePicker) {
            datePicker.datePickerMode = UIDatePickerModeTime;
            datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        }
        
        datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
        
        return [datePicker autorelease];
    }
    
    return nil;
}

- (void)showPickerActionSheet:(NSString *)title andObjectView:(UIView *)views
{
    [_textFieldClientName resignFirstResponder];
    [_textFieldDoctorName resignFirstResponder];
    
    CGRect btnOkRect;
    CGRect btnCancelRect;
    CGRect titleLabelRect;
    UIView *view = [[UIView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIViewController *contentViewController = [[[UIViewController alloc] init] autorelease];
        contentViewController.contentSizeForViewInPopover = CGSizeMake(760.0f, 300.0f);
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
        self.popOver.delegate = self;
        view = contentViewController.view;
        [_popOver presentPopoverFromRect:views.bounds inView:views permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        titleLabelRect = CGRectMake(230.0f, -10, 278.0f, 40.0f);
        btnOkRect = CGRectMake(260.0f, 250.0f, 100.0f, 40.0f);
        btnCancelRect = CGRectMake(380.0f, 250.0f, 100.0f, 40.0f);
        
    } else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        view = actionSheet;
        
        titleLabelRect = CGRectMake(21.0f, -3, 278.0f, 40.0f);
        btnOkRect = CGRectMake(60.0f, 250.0f, 100.0f, 40.0f);
        btnCancelRect = CGRectMake(170.0f, 250.0f, 100.0f, 40.0f);
        
        [actionSheet showInView:self.view];
        actionSheet.frame = CGRectMake(0.0f, self.view.bounds.size.height - 300.0f, actionSheet.frame.size.width, 300.0f);
        self.actionSheet = actionSheet;
    }
    
    switch (self.pickerType) {
        case PCListPicker: {
            self.pickerView = [self listPickerForActionSheet];
            [view addSubview:self.pickerView];
            break;
        }
        case PCDatePicker: {
            self.datePicker = [self datePickerForActionSheet];
            self.datePicker.date = [NSDate date];
            [view addSubview:self.datePicker];
            break;
        }
        case PCTimePicker: {
            self.datePicker = [self datePickerForActionSheet];
            [view addSubview:self.datePicker];
            break;
        }
    }
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(250.0f, 0, 278.0f, 45.0f)] autorelease] ;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.frame = titleLabelRect;
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    okButton.frame = btnOkRect;
    [okButton addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    cancelButton.frame = btnCancelRect;
    [cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:okButton];
    [view addSubview:cancelButton];
    [view addSubview:titleLabel];
    [view release];
}
- (NSDate *) fireDate
{
    NSDate *reminderTime = nil;
    NSDate *reminderDate = nil;
    
    NSDateFormatter *reminderDateFormatter =[[[NSDateFormatter alloc] init] autorelease];
    reminderDateFormatter.timeZone = _datePicker.timeZone;
    [reminderDateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter *reminderTimeFormatter =[[[NSDateFormatter alloc] init] autorelease];
    reminderTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [reminderTimeFormatter setDateFormat:@"hh:mm aa"];
    
    reminderDate = [reminderDateFormatter dateFromString:self.appointmentDate.text];
    //reminderTime = [reminderTimeFormatter dateFromString:self.appointmentTime.text];
    reminderTime = [NSDate dateWithTimeIntervalSince1970:[self.timeInSecs doubleValue]];
    NSTimeInterval ti = [reminderDate timeIntervalSince1970] + [reminderTime timeIntervalSince1970];
    
    if([self.reminderAlert.text isEqualToString:@"30 minutes"]) {
        ti -= 30*60;
    } else if ([self.reminderAlert.text isEqualToString:@"1 Hour"]) {
        ti -=  60*60;
    } else if ([self.reminderAlert.text isEqualToString:@"3 Hours"]) {
        ti -= (60*3)*60;
    } else if ([self.reminderAlert.text isEqualToString:@"1 Day"]) {
        ti -= (24*60)*60;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:ti];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
          NSString *alertMessage = [NSString stringWithFormat:@"Sent appointment at %@, %@\n",self.appointmentDate.text, self.appointmentTime.text];
    
    switch (result) {
        case MessageComposeResultCancelled:
            // alert.message = @"Message Canceled";
            break;
        case MessageComposeResultSent:
            alert.message = alertMessage;
            [alert show];
            [alert release];
            
            break;
        case MessageComposeResultFailed:
              alert.message = @"Message Failed";
            break;
        default:
              alert.message = @"Message Not Sent";
            break;
    }
    [alert release];
    [self dismissModalViewControllerAnimated:NO];
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
              alert.message = @"Message %@", error ;
            break;
    }
    [alert release];
    [self dismissModalViewControllerAnimated:NO];
    
}

- (void)activateMail:(Appointment *)mailComponents
{
//    NSString *emailSubject = [mailComponents objectAtIndex:0];
//    NSString *emailTo = [mailComponents objectAtIndex:1];
//    NSString *emailMessage = [mailComponents objectAtIndex:2];
     NSDateFormatter *dateFormatter =[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
     NSDateFormatter *timeFormatter =[[[NSDateFormatter alloc] init] autorelease];
    [timeFormatter setDateFormat:@"hh:mm aa"];
    
    
     NSString *emailSubject = @"Appointment by Iphone App";
    NSString *emailTo = @"jerry.goh@leappmobile.com";
    NSString *emailMessage = [NSString stringWithFormat:@"Appointment Date:%@\nAppointment Time:%@\nName:%@\nEmail:%@\nPhone:%@\nMessage:%@\n", self.appointmentDate.text , self.appointmentTime.text , mailComponents.clientName, mailComponents.doctorName, mailComponents.mobileNumber, mailComponents.notes];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark view life cycle
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    //To make the border look very close to a UITextField
   [_textViewMessage.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    
    [_textViewMessage.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    _textViewMessage.layer.cornerRadius = 5;
    _textViewMessage.clipsToBounds = YES;
    
    if(self.appointment) {
        
        NSDate *scheduleDate = [NSDate dateWithTimeIntervalSince1970:[self.appointment.appointmentDate doubleValue]];
        NSDate *scheduleTime = [NSDate dateWithTimeIntervalSince1970:[self.appointment.appointmentTime doubleValue]];
        
        NSDateFormatter *reminderDateFormatter =[[[NSDateFormatter alloc] init] autorelease];
        reminderDateFormatter.timeZone = _datePicker.timeZone;
        [reminderDateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSDateFormatter *reminderTimeFormatter =[[[NSDateFormatter alloc] init] autorelease];
        reminderTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [reminderTimeFormatter setDateFormat:@"hh:mm aa"];
        
        NSString *appointmentDate = [reminderDateFormatter stringFromDate:scheduleDate];
        NSString *appointmentTime = [reminderTimeFormatter stringFromDate:scheduleTime];
        
        self.textFieldClientName.text = self.appointment.clientName;
        self.textFieldDoctorName.text =self.appointment.doctorName;
        self.appointmentDate.text = appointmentDate;
        self.appointmentTime.text = appointmentTime;
        self.reminderAlert.text =  self.appointment.reminderAlert;
    }
}

-(void)dismissKeyboard {
    [_textFieldPhoneNumber resignFirstResponder];
    [_textViewMessage resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextFieldPhoneNumber:nil];
    [self setTextViewMessage:nil];
    [super viewDidUnload];
}
@end
