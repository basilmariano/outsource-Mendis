//
//  ShareViewController.m
//  PICClinicModel
//
//  Created by Sil on 6/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "ShareViewController.h"
#import "SOcialShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "AFNetworking.h"


@interface ShareViewController () <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSString *placeHolder;

@end

@implementation ShareViewController

- (id)initWithPlaceHolder:(NSString *)placeHolder
{
    NSBundle *bundle =  [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]];
    NSString *nibName = PCNameForDevice(@"ShareViewController");
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        self.placeHolder = placeHolder;
        self.navigationItem.title = @"Share";
        
        NSString *shareImageNormalName = @"PICClinicModel.bundle/iphone_Share-button_s.png";
        NSString *backImageName        = @"PICClinicModel.bundle/Back_btn-s.png";
        
        UIView *customView = [[[UIView alloc] init] autorelease];
        UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView *customViewShare = [[[UIView alloc] init] autorelease];
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            btnShare.frame = CGRectMake(0.0f, 0.0f, 61.5f, 33.5f);
            btnback.frame = CGRectMake(0.0f, 0.0f, 53.0f, 33.5f);
            customViewShare.frame = btnShare.frame;
            customView.frame = btnback.frame;
            
        } else {
            shareImageNormalName = @"PICClinicModel.bundle/ipad_Share-button_s.png";
            btnShare.frame = CGRectMake(0.0f, 18.0f, 121.0f, 64.0f);
            customViewShare.frame = CGRectMake(0.0f, 0.0f, 121.0f, 64.0f);
            btnback.frame = CGRectMake(0.0f, 18.0f, 97.0f, 64.0f);
            customView.frame = CGRectMake(0.0f, 0.0f, 97.0f, 64.0f);
        }
        
        UIImage *shareImageNormal = [UIImage imageNamed:shareImageNormalName];
        [btnShare setBackgroundImage:shareImageNormal forState:UIControlStateNormal];
        [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [customViewShare addSubview:btnShare];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:customViewShare];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        
        UIImage *BackImage = [UIImage imageNamed:backImageName];
        [btnback setBackgroundImage:BackImage forState:UIControlStateNormal];
        [btnback addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [customView addSubview:btnback];
        UIBarButtonItem *bckButton = [[UIBarButtonItem alloc]initWithCustomView:customView];
        self.navigationItem.leftBarButtonItem = bckButton;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtAreaMessageContent.text = self.placeHolder;
    // Do any additional setup after loading the view from its nib.
    if (self.senderTag == 1) {
        [self canTwitterPost];
    }else {
        [self canFacebookPost];
    }
    
    _textAreaBGImage.image = [UIImage imageNamed:@"PICClinicModel.bundle/Rounded-Rectangle-2.png"];
    
    [self.txtAreaMessageContent becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_txtAreaMessageContent release];
    [_spinner release];
    [_placeHolder release];
    [super dealloc];
}

# pragma mark private
- (void)checkSocialNetworksAvailability
{
    if(self.senderTag == 1) {
        [self canTwitterPost];
    } else {
        [self canFacebookPost];
    }
    
}
- (BOOL)canTwitterPost
{
    if (![TWTweetComposeViewController canSendTweet]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://"]];
            [self.spinner stopAnimating];
            return NO;
        }
        UIAlertView *alertViewTwitter = [[UIAlertView alloc]
                                         initWithTitle:@"No Twitter Accounts"
                                         message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                         delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
        
        [alertViewTwitter show];
        [self.spinner stopAnimating];
        return NO;
    }
    return YES;
}
/*
- (BOOL)canFacebookPost
{
    if (!FBSession.activeSession.isOpen || [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkSocialNetworksAvailability];
            });
        }];
        return NO;
    }
    return YES;
}
*/

- (BOOL)canFacebookPost
{
    if (FBSession.activeSession.isOpen) {
        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
            [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:nil];
            [self.spinner stopAnimating];
            return NO;
        }
    } else {
        
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkSocialNetworksAvailability];
            });
        }];
        [self.spinner stopAnimating];
        return NO;
    }
    return YES;
}


- (void)postFacebook
{
    if (![self canFacebookPost]) {
        return;
    }
    NSString *stringToPass = self.txtAreaMessageContent.text;
    //NSDictionary *params = [NSDictionary dictionaryWithObject:stringToPass forKey:@"message"];
    
    [FBRequestConnection startForPostStatusUpdate:stringToPass completionHandler:^(FBRequestConnection *connection,
                                                                                   id result,
                                                                                   NSError *error) {
        NSString *alertText;
        if (error) {
            [self.spinner stopAnimating];
            alertText = [NSString stringWithFormat:
                         @"error: domain = %@, code = %d message = %@",
                         error.domain, error.code, error.localizedDescription];
        } else {
            [self.spinner stopAnimating];
            alertText = @"Posted Facebook successfully.";
        }
        // Show the result in an alert
        [[[UIAlertView alloc] initWithTitle:stringToPass
                                    message:alertText
                                   delegate:self
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
    }];
    
}

- (void)postTwitter
{
    if (![self canTwitterPost]) {
        return;
    }
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSString *stringToPass = self.txtAreaMessageContent.text;
    [store requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if (granted) {
                NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
                if (twitterAccounts.count > 0) {
                    ACAccount *account = [twitterAccounts objectAtIndex:0];
                    
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:stringToPass.length <= 140 ? stringToPass : [stringToPass substringWithRange:NSMakeRange(0, 140)], @"status", nil];
                    
                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                    
                    TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodPOST];
                    twitterRequest.account = account;
                    
                    NSURLRequest *request = [twitterRequest signedURLRequest];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    void (^finalize)() = ^() {
                        [self.spinner stopAnimating];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    };
                    
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        finalize();
                        [[[UIAlertView alloc] initWithTitle:@"Result" message:@"Posted Twitter successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        finalize();
                        NSDictionary *suggestion = [error.localizedRecoverySuggestion objectFromJSONString];
                        [[[UIAlertView alloc] initWithTitle:@"Twitter Error" message:suggestion[@"errors"][0][@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }];
                    
                    [operation start];
                }
            }
        });
    }];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if(self.senderTag == 1) { // Twitter
        if(140 >= textView.text.length)
            return  YES;
        else {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark Selectors
- (void) btnShareClicked:(id) sender
{
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    [_spinner startAnimating];
    if (self.senderTag == 1) {
        [self postTwitter];
    }else {
        [self postFacebook];
    }
}

- (void) btnBackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

