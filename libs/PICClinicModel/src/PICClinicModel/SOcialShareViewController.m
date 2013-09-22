//
//  SOcialShareViewController.m
//  PICClinicModel
//
//  Created by Sil on 6/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "SOcialShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "ShareViewController.h"
#import "PCModelWebViewController.h"
#import <MessageUI/MessageUI.h>

@interface SOcialShareViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation SOcialShareViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = PCNameForDevice(@"SOcialShareViewController");
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initParentClass: (Class *) class bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = PCNameForDevice(@"SOcialShareViewController");
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [_btnFacebook release];
    [_btnTwitter release];
    [_btnSms release];
    [_parent release];
    [_popOverController release];
    [super dealloc];
}

#pragma mark viewLifeCycle
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

#pragma mark IBOutlet
-(IBAction)onBtnFacebookClicked:(id)sender
{
    UIButton *btnClicked = (UIButton *) sender;
    
    NSString *textViewPlaceHolder = @"Come join me in Wayan Retreat Wellness Spa";
    ShareViewController *shareViewController = [[[ShareViewController alloc] initWithPlaceHolder:textViewPlaceHolder]autorelease];
    
    shareViewController.senderTag = btnClicked.tag;
    
    PCModelWebViewController *viewController = (PCModelWebViewController *) self.parent;
    
    [viewController.navigationController pushViewController:shareViewController animated:YES];
    [self.popOverController dismissPopoverAnimated:YES];
    
}
-(IBAction)onBtnTwitterClicked:(id)sender
{
    UIButton *btnClicked = (UIButton *) sender;
    NSString *textViewPlaceHolder = @"Come join me in Wayan Retreat Wellness Spa.";
    
    ShareViewController *shareViewController = [[[ShareViewController alloc] initWithPlaceHolder:textViewPlaceHolder]autorelease];
    
    shareViewController.senderTag = btnClicked.tag;
    
    PCModelWebViewController *viewController = (PCModelWebViewController *) self.parent;
    
    [viewController.navigationController pushViewController:shareViewController animated:YES];
    [self.popOverController dismissPopoverAnimated:YES];
}

-(IBAction)onBtnSmsClicked:(id)sender
{
     NSString *smsMessage = @"Come join me in Wayan Retreat Wellness Spa.";
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = smsMessage;
        //controller.recipients = [NSArray arrayWithObjects:smsNumber, nil];
        controller.messageComposeDelegate = self;
      //  [self.popOverController dismissPopoverAnimated:NO];
        [self presentModalViewController:controller animated:YES];
    
    }
    
}

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
    [self dismissModalViewControllerAnimated:YES];}


@end
