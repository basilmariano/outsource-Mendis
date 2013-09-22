//
//  PCAppointmentViewController.h
//  PICClinic
//
//  Created by Panfilo Mariano Jr. on 5/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appointment.h"
#import <MessageUI/MessageUI.h>

@interface PCAppointmentViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *appointmentDate;
@property (nonatomic, retain) IBOutlet UILabel *appointmentTime;
@property (nonatomic, retain) IBOutlet UILabel *reminderAlert;
@property (nonatomic, retain) IBOutlet UIButton *buttonAppointmentDate;
@property (nonatomic, retain) IBOutlet UIButton *buttonAppointmentTime;
@property (nonatomic, retain) IBOutlet UIButton *buttonReminderAlert;
@property (nonatomic, retain) IBOutlet UITextField *textFieldClientName;
@property (nonatomic, retain) IBOutlet UITextField *textFieldDoctorName;
@property (retain, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (retain, nonatomic) IBOutlet UITextView *textViewMessage;


- (id)initWithNavigationTitle: (NSString *)title andAppointment:(Appointment *)appointment;

-(IBAction)onButtonAppointmentDateClicked:(id)sender;
-(IBAction)onbuttonAppointmentTimeClicked:(id)sender;
-(IBAction)onbuttonReminderAlertClicked:(id)sender;

@end
