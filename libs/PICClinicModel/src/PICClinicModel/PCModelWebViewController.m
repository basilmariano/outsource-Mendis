//
//  LSWebViewController.m
//  LSAestheticClinic
//
//  Created by Wong Johnson on 3/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCModelWebViewController.h"
#import "PCModelTableViewController.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "FPPopoverController.h"
#import "SOcialShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PCModelFormViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WishList.h"

@interface PCModelWebViewController ()<UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIPopoverControllerDelegate>
{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) PCModelAnnotation *annotation;
@property (nonatomic, retain) NSString *articleId;
@property (nonatomic, retain) IBOutlet UIView *mapViewHolder;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIWebView *webViewContactUs;
@property (nonatomic, retain) IBOutlet UIWebView *webViewContactUsClickLink;
@property (nonatomic, retain) NSString *urlStringLink;
@property (nonatomic, retain) NSArray *callNumbers;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *rightBarButton;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic) BOOL hideBackButton;
@property (nonatomic) BOOL dontRequest;
@property (nonatomic) BOOL changeNavigationBackGround;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) UIButton *addContactButton;
//@property (nonatomic, retain) MAContactShareViewController *addContactShare;
@property (nonatomic, retain) UIButton *plusContactBtn;
@property (nonatomic, retain) UIButton *ConnectSocialBtn;
@property (nonatomic, retain) PCNavigationController *nav;
@property (nonatomic, retain) FPPopoverController *contactPopOverController;
@property (nonatomic, retain) NSString *productName;

@end

@implementation PCModelWebViewController

#pragma mark - Memory Life Cycle

- (id)initWithUrlString:(NSString *)urlString andCompanyId:(NSString *)companyId andDontRequest:(BOOL)dontRequest
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelWebViewController");
    if (self = [self initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]]) {
        _companyId = [companyId retain];
        _dontRequest = dontRequest;
        _urlStringLink = [urlString retain];
        self.navigationItem.title = @"Contact Us";
        self.webView.hidden = TRUE;
        self.webViewContactUs.hidden = TRUE;
        self.webViewContactUsClickLink.hidden = FALSE;
        
        
        self.navigationItem.leftBarButtonItem = [self leftBarButton];
        
    }
    //_nav = [[PCNavigationController alloc] initWithRootViewController:self];
    return self;
}
- (id)initWithArticleId:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString *)companyId andChangeNavigationBackground:(BOOL)changeNavigationBackground
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelWebViewController");
    if (self = [self initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(canRequestNow:)
                                                     name:VERSION_CHECK_READY
                                                   object:nil];
        _articleId = [articleId retain];
        _companyId = [companyId retain];
        _changeNavigationBackGround = changeNavigationBackground;
        
        if (articleTitle) {
            self.navigationItem.title = articleTitle;
        }
        
        self.navigationItem.leftBarButtonItem = [self leftBarButton];
    }
    //_nav = [[PCNavigationController alloc] initWithRootViewController:self];
    return self;
}

- (id)initWithArticleId:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString*)companyId andBackButtonHiddenFirst:(BOOL)buttonHiddenFirst
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelWebViewController");
    if (self = [self initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]]) {
        if (articleId){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(canRequestNow:)
                                                         name:VERSION_CHECK_READY
                                                       object:nil];
        }
        _articleId = [articleId retain];
        _companyId = [companyId retain];
        
        _hideBackButton = buttonHiddenFirst;
        if (articleTitle) {
            self.navigationItem.title = articleTitle;
        } else {
            if ([articleId isEqualToString:@"36"]) {
                self.navigationItem.title = @"Doctors info";
            }
        }
        
    }
    
   self.navigationItem.leftBarButtonItem = [self leftBarButton];
    
    
    if (buttonHiddenFirst) {
        self.backButton.hidden = TRUE;
    } else {
        self.backButton.hidden = FALSE;
    }
    // _nav = [[PCNavigationController alloc] initWithRootViewController:self];
    return self;
}

- (id)initWithArticleIdForWishList:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString *)companyId
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelWebViewController");
    if (self = [self initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]]) {
        if (articleId){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(canRequestNow:)
                                                         name:VERSION_CHECK_READY
                                                       object:nil];
        }
        _articleId = [articleId retain];
        _companyId = [companyId retain];
        

        self.navigationItem.title = articleTitle;
    }
    
    self.productName = articleTitle;
    self.navigationItem.leftBarButtonItem = [self leftBarButton];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
    
    return self;
}

- (id)initWithShareButtonAndArticleId:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString*)companyId;
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelWebViewController");
    if (self = [self initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(canRequestNow:)
                                                     name:VERSION_CHECK_READY
                                                   object:nil];
        _articleId = [articleId retain];
        _companyId = [companyId retain];
        
        self.navigationItem.title = articleTitle;
        
    }
    
    UIView *customViewShare = [[[UIView alloc] init] autorelease];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareButtonImage = [UIImage imageNamed:@"PICClinicModel.bundle/iphone_Share-button_s.png"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        shareButton.frame = CGRectMake(0.0f, 0.0f, 61.5f, 33.5f);
        customViewShare.frame = shareButton.frame;
    } else { //IPAD
        shareButtonImage = [UIImage imageNamed:@"PICClinicModel.bundle/ipad_Share-button_s.png"];
        shareButton.frame = CGRectMake(0.0f, 18.0f, 121.0f, 64.0f);
        customViewShare.frame = CGRectMake(0.0f, 0.0f, 121.0f, 64.0f);
    }
    
    [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [customViewShare addSubview:shareButton];
    UIBarButtonItem *navigationBarBackButton = [[[UIBarButtonItem alloc] initWithCustomView:customViewShare]autorelease] ;
    self.navigationItem.rightBarButtonItem = navigationBarBackButton;
    
    
    self.navigationItem.leftBarButtonItem = [self leftBarButton];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_companyId release];
    [_backButton release];
    [_rightBarButton release];
    [_mapViewHolder release];
    [_mapView release];
    [_callNumbers release];
    [_spinner release];
    [_webView release];
    [_webViewContactUs release];
    [_webViewContactUsClickLink release];
    [_urlStringLink release];
    [_articleId release];
    [_annotation release];
    [_productName release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *) rightBarButtonItem
{
    UIView *contentView = [[[UIView alloc]init]autorelease];
    
    self.rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"iphone_WishListsBtn-s.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"iphone_WishListsBtn-ss.png"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.rightBarButton.frame = CGRectMake(0.0f, 0.0f, 70.0f, 34.5f);
        contentView.frame = self.rightBarButton.frame;
    } else {
        buttonImage = [UIImage imageNamed:@"PICClinicModel.bundle/ipad_WishListsBtn-s.png"];
        buttonImagePressed = [UIImage imageNamed:@"PICClinicModel.bundle/ipad_WishListsBtn-ss.png"];
        
        self.rightBarButton.frame = CGRectMake(650, 11, 158.0f, 75.5f);
        contentView.frame = self.rightBarButton.frame;
    }
    
    [_rightBarButton addTarget:self action:@selector(onAddToWishListTap) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarButton setImage:buttonImage forState:UIControlStateNormal];
    [_rightBarButton setImage:buttonImagePressed forState:UIControlStateSelected];
    
    [contentView addSubview:self.rightBarButton];
       
    return [[[UIBarButtonItem alloc] initWithCustomView:contentView] autorelease];

}

- (void) onAddToWishListTap
{
    //NSLog(@"ADD TO WISH LIST");
    WishList *wishList = [WishList NewWishList];
    wishList.productName = self.productName;
    wishList.articleId = self.articleId;
    
    [[PCModelManager sharedManager] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *) leftBarButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *contentView = [[[UIView alloc]init]autorelease];
    NSString *backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        contentView.frame = CGRectMake(0, 0.0f, 420.0f, 44.0f);
        self.backButton.frame = CGRectMake(0.0f, 5.5f, 55.0f, 32.5f);
        
    } else { //IPAD
        contentView.frame = CGRectMake(0, 0.0f, 768, 44.0f);
        self.backButton.frame = CGRectMake(0.0f, 9.0f, 97.0f, 64.0f);
    }
    UIImage *customNavigationBarBackButtonImage = [UIImage imageNamed:backImageName];
    [_backButton setImage:customNavigationBarBackButtonImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_backButton];
    
    
    if ([_companyId isEqualToString:@"17"] && [_articleId isEqualToString:@"153"]) {
        
        _addContactButton    = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addContactButton addTarget:self action:@selector(addContactBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *buttonImage = [[UIImage alloc] init];
        UIImage *buttonImagePressed = [[UIImage alloc] init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            _addContactButton.frame = CGRectMake(275.0f, 5.0f, 35.0, 35.0);
            buttonImage = [UIImage imageNamed:@"iphone_plus_btn-s.png"];
            buttonImagePressed = [UIImage imageNamed:@"iphone_plus_btn-ss.png"];

        }else{
            
            _addContactButton.frame = CGRectMake(680.0f, 7.0f, 64.0, 64.0);
            buttonImage = [UIImage imageNamed:@"ipad_plus_btn-s.png"];
            buttonImagePressed = [UIImage imageNamed:@"ipad_plus_btn-ss.png"];
   
        }
        [_addContactButton setTitle:@"Add Contact" forState:UIControlStateNormal];

        [_addContactButton setImage:buttonImage forState:UIControlStateNormal];
        [_addContactButton setImage:buttonImagePressed forState:UIControlStateSelected];
        
        [_addContactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [contentView addSubview:_addContactButton];
        
    }
    
    UIBarButtonItem *navigationBarBackButton = [[[UIBarButtonItem alloc] initWithCustomView:contentView]autorelease] ;
    return navigationBarBackButton;
}

- (UIBarButtonItem *)createContactBackButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *contentView = [[[UIView alloc]init]autorelease];
    NSString *backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        self.backButton.frame = CGRectMake(0.0f, 3.0f, 53.0f, 33.5f);
        contentView.frame = self.backButton.frame;
        
    } else { //IPAD
        
        self.backButton.frame = CGRectMake(0.0f, 21.0f, 97.0f, 64.0f);
        contentView.frame = CGRectMake(0.0f, 0.0f, 97.0f, 64.0f);
    }
    
    UIImage *customNavigationBarBackButtonImage = [UIImage imageNamed:backImageName];
    [_backButton setImage:customNavigationBarBackButtonImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backToContactButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_backButton];
    
    
    return [[[UIBarButtonItem alloc] initWithCustomView:contentView]autorelease];
    //self.navigationItem.leftBarButtonItem = navigationBarBackButton;
    
}



#pragma mark - View Life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    if ([self isEqual: [self.navigationController.viewControllers objectAtIndex:0] ]){
        // Put Back button in navigation bar
        self.backButton.hidden = TRUE;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if (_changeNavigationBackGround) {
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_blank.png"];
    }
    
    if (!_dontRequest) {
        [_spinner startAnimating];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadWebView:)
                                                     name:LOAD_WEBVIEW_KEY
                                                   object:nil];
        
        if ([PCModelManager sharedManager].versionCheckFinished) {
            [[PCRequestHandler sharedInstance]requestArticle:_articleId andCompanyId:_companyId];
            
        }
        
    } else {
        NSURL *url = [NSURL URLWithString:_urlStringLink];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [_webViewContactUsClickLink loadRequest:requestObj];
    }
    if ([_companyId isEqualToString:@"7"] || [_companyId isEqualToString:@"10"] || [_companyId isEqualToString:@"14"] || [_companyId isEqualToString:@"15"] || [_companyId isEqualToString:@"16"]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480) {
                self.webView.frame = CGRectMake(0, 0,self.view.bounds.size.width,370);
                self.webViewContactUs.frame = CGRectMake(0, 0,self.view.bounds.size.width,370);
                self.webViewContactUsClickLink.frame = CGRectMake(0, 0,self.view.bounds.size.width,370);
                self.mapViewHolder.frame = CGRectMake(0, 0,self.view.bounds.size.width,370);
            } else if(result.height == 568) {
                self.webView.frame = CGRectMake(0, 0,self.view.bounds.size.width,459);
                self.webViewContactUs.frame = CGRectMake(0, 0,self.view.bounds.size.width,459);
                self.webViewContactUsClickLink.frame = CGRectMake(0, 0,self.view.bounds.size.width,459);
                self.mapViewHolder.frame = CGRectMake(0, 0,self.view.bounds.size.width,459);
            }
            
        } else {
            self.webView.frame = CGRectMake(0, 36,self.view.bounds.size.width,823);
            self.webViewContactUs.frame = CGRectMake(0, 36,self.view.bounds.size.width,823);
            self.webViewContactUsClickLink.frame = CGRectMake(0, 36,self.view.bounds.size.width,823);
            self.mapViewHolder.frame = CGRectMake(0, 36,self.view.bounds.size.width,823);
        }
        
        if ([_companyId isEqualToString:@"7"]) {
            self.webView.backgroundColor = [UIColor colorWithRed:151.0f/255.0f green:134.0f/255.0f blue:108.0f/255.0f alpha:1];
            self.webViewContactUs.backgroundColor = [UIColor colorWithRed:151.0f/255.0f green:134.0f/255.0f blue:108.0f/255.0f alpha:1];
            self.webViewContactUsClickLink.backgroundColor = [UIColor colorWithRed:151.0f/255.0f green:134.0f/255.0f blue:108.0f/255.0f alpha:1];
        } else if ([_companyId isEqualToString:@"14"]) {
            UIColor *backGroundColor = [UIColor colorWithRed:99.0f/255.0f green:182.0f/255.0f blue:234.0f/255.0f alpha:1];
            self.webView.backgroundColor = backGroundColor;
            self.webViewContactUs.backgroundColor = backGroundColor;
            self.webViewContactUsClickLink.backgroundColor = backGroundColor;
            
        } else if ([_companyId isEqualToString:@"15"]) {
            [_webView setBackgroundColor:[UIColor colorWithRed:0.34117647058 green:0.17647058823 blue:0.07450980392 alpha:1]];
            [_webViewContactUs setBackgroundColor:[UIColor colorWithRed:0.34117647058 green:0.17647058823 blue:0.07450980392 alpha:1]];
            [_webViewContactUsClickLink setBackgroundColor:[UIColor colorWithRed:0.34117647058 green:0.17647058823 blue:0.07450980392 alpha:1]];
            
        }
        
    }
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.spinner = nil;
    self.webView = nil;
    self.mapViewHolder = nil;
    self.mapView = nil;
    self.webViewContactUs = nil;
    self.webViewContactUsClickLink = nil;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)canRequestNow:(NSNotification *)notification
{
    [[PCRequestHandler sharedInstance]requestArticle:_articleId andCompanyId:_companyId];
}
- (void)loadWebView:(NSNotification *)notification
{
    [_spinner stopAnimating];
    
    
    NSString *articleId = [[notification userInfo] valueForKey:LOAD_WEBVIEW_ARTICLE_ID_KEY];
    
    if (articleId && [articleId isEqualToString:_articleId]) {
        
        if (_hideBackButton) {
            self.webView.hidden = TRUE;
            self.webViewContactUs.hidden = FALSE;
            self.webViewContactUsClickLink.hidden = TRUE;
            [_webViewContactUs loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[notification userInfo] valueForKey:LOAD_WEBVIEW_CONTENT_KEY]]]];
            return;
        } else {
            self.webView.hidden = FALSE;
            self.webViewContactUs.hidden = TRUE;
            self.webViewContactUsClickLink.hidden = TRUE;
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[notification userInfo] valueForKey:LOAD_WEBVIEW_CONTENT_KEY]]]];
            return;
        }
        return;
    }
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertView = nil;
}
- (void)backToContactButtonPressed
{
    if (_changeNavigationBackGround) {
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        
                        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_Mendis.png"];
    }
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    
    if ([_webViewContactUs canGoBack]) {
        [_webViewContactUs goBack];
        self.backButton.hidden = TRUE;
    } else if ([_webViewContactUsClickLink canGoBack]) {
        [_webViewContactUsClickLink goBack];
        
    }else if (_mapViewHolder.alpha != 0) {
        self.backButton.hidden = TRUE;
        [UIView beginAnimations:nil context:nil];
        self.mapViewHolder.alpha = 0;
        [UIView commitAnimations];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    UIView *contentView = [[[UIView alloc]init]autorelease];
    
    if ([_companyId isEqualToString:@"17"] && [_articleId isEqualToString:@"153"]) {
        
        
        _addContactButton    = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addContactButton addTarget:self action:@selector(addContactBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *buttonImage = [[UIImage alloc] init];
        UIImage *buttonImagePressed = [[UIImage alloc] init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            contentView.frame = CGRectMake(0, 0.0f, 420.0f, 44.0f);
            _addContactButton.frame = CGRectMake(275.0f, 5.0f, 35.0, 35.0);
            buttonImage = [UIImage imageNamed:@"iphone_plus_btn-s.png"];
            buttonImagePressed = [UIImage imageNamed:@"iphone_plus_btn-ss.png"];
            
        }else{
             contentView.frame = CGRectMake(0, 0.0f, 768, 44.0f);
            _addContactButton.frame = CGRectMake(680.0f, 7.0f, 64.0, 64.0);
            buttonImage = [UIImage imageNamed:@"ipad_plus_btn-s.png"];
            buttonImagePressed = [UIImage imageNamed:@"ipad_plus_btn-ss.png"];
        }
        
        [_addContactButton setTitle:@"Add Contact" forState:UIControlStateNormal];
        [_addContactButton setImage:buttonImage forState:UIControlStateNormal];
        [_addContactButton setImage:buttonImagePressed forState:UIControlStateSelected];
        
        [_addContactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [contentView addSubview:_addContactButton];
        
        UIBarButtonItem *navigationBarBackButton = [[[UIBarButtonItem alloc] initWithCustomView:contentView]autorelease] ;
        self.navigationItem.leftBarButtonItem = navigationBarBackButton;
    }
}

- (void)backButtonPressed
{
    if (_changeNavigationBackGround) {
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
            nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_Mendis.png"];
       
    }
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    
    if ([_webViewContactUs canGoBack]) {
        [_webViewContactUs goBack];
        self.backButton.hidden = TRUE;
    } else if ([_webViewContactUsClickLink canGoBack]) {
        [_webViewContactUsClickLink goBack];
        
    }else if (_mapViewHolder.alpha != 0) {
        self.backButton.hidden = TRUE;
        [UIView beginAnimations:nil context:nil];
        self.mapViewHolder.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) addContactBtnPressed:(id) sender
{

    UIViewController *testview = [[UIViewController alloc]init];
    _plusContactBtn    = [UIButton buttonWithType:UIButtonTypeCustom];
    _ConnectSocialBtn    = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    UIImage *buttonImage = [[UIImage alloc] init];
    UIImage *buttonImagePressed = [[UIImage alloc] init];
    UIImage *button2Image = [[UIImage alloc] init];
    UIImage *button2ImagePressed = [[UIImage alloc] init];
    
    
    [_plusContactBtn addTarget:self action:@selector(plusContactPressed) forControlEvents:UIControlEventTouchUpInside];
    [_ConnectSocialBtn addTarget:self action:@selector(ConnectSocialPressed) forControlEvents:UIControlEventTouchUpInside];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _plusContactBtn.frame = CGRectMake(0.0f, 0.0f, 120.0, 38.0);
         _ConnectSocialBtn.frame = CGRectMake(0.0f, 38.0f, 120.0, 38.0);
        buttonImage = [UIImage imageNamed:@"iphone_Add_btn-s.png"];
        buttonImagePressed = [UIImage imageNamed:@"iphone_Add_btn-ss.png"];
        button2Image = [UIImage imageNamed:@"iphone_Social_btn-s.png"];
        button2ImagePressed = [UIImage imageNamed:@"iphone_Social_btn-ss.png"];
        
        
    }else{
        _plusContactBtn.frame = CGRectMake(0.0f, 0.0f, 200.0, 70.0);
        _ConnectSocialBtn.frame = CGRectMake(0.0f, 70.0f, 200.0, 70.0);
        buttonImage = [UIImage imageNamed:@"ipad_Add_btn-s.png"];
        buttonImagePressed = [UIImage imageNamed:@"ipad_Add_btn-ss.png"];
        button2Image = [UIImage imageNamed:@"ipad_Social_btn-s.png"];
        button2ImagePressed = [UIImage imageNamed:@"ipad_Social_btn-ss.png"];
        
        
    }
    UIFont *font = [UIFont fontWithName:@"American Typewriter" size:10];
    
    [_plusContactBtn setTitle:@"Add to Contact" forState:UIControlStateNormal];
    _plusContactBtn.titleLabel.font = font;
    
    [_ConnectSocialBtn setTitle:@"Connect Social" forState:UIControlStateNormal];
    _ConnectSocialBtn.titleLabel.font = font;
    
    [_plusContactBtn setImage:buttonImage forState:UIControlStateNormal];
    [_plusContactBtn setImage:buttonImagePressed forState:UIControlStateSelected];
    
    [_ConnectSocialBtn setImage:button2Image forState:UIControlStateNormal];
    [_ConnectSocialBtn setImage:button2ImagePressed forState:UIControlStateSelected];
    
    [_plusContactBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_plusContactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [_ConnectSocialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_ConnectSocialBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [testview.view addSubview:_plusContactBtn];
    [testview.view addSubview:_ConnectSocialBtn];
    [testview.view bringSubviewToFront:_plusContactBtn ];// _wishBtn.hidden = false;
     [testview.view bringSubviewToFront:_ConnectSocialBtn ];
    
    _contactPopOverController = [[FPPopoverController alloc] initWithViewController:testview ];
    //
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _contactPopOverController.contentSize = CGSizeMake(145,117);
    } else {
        _contactPopOverController.contentSize = CGSizeMake(220,180);
    }
    //
  //  addContactPanel.popOverController = _contactPopOverController;
    [_contactPopOverController presentPopoverFromView:sender];
    
}

- (void) plusContactPressed
{
    NSString *name = @"Mendis";
    NSString *email = @"Email@email.com";
    NSString *homePage = @"www.mendis.com.sg";
    NSString *phone = @"1234567";
    NSString *address = @"Adddress at Orchard Scotts";
    NSString *address2 = @"Adddress 2 at Orchard Scotts";
    
    ABRecordRef person = ABPersonCreate();
    // set name and other string values
    ABRecordSetValue(person, kABPersonOrganizationProperty, (CFStringRef) name, NULL);
    
    if (homePage)
    {
        ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(urlMultiValue, ( CFStringRef) homePage, kABPersonHomePageLabel, NULL);
        ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
        CFRelease(urlMultiValue);
    }
    if (email)
    {
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (CFStringRef) email, kABWorkLabel, NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
        CFRelease(emailMultiValue);
    }
    if (phone)
    {
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *venuePhoneNumbers = [phone componentsSeparatedByString:@" or "];
        for (NSString *venuePhoneNumberString in venuePhoneNumbers)
            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (CFStringRef) venuePhoneNumberString, kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
    }
    // add address
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    if (address)
    {
        if (address2)
            addressDictionary[(NSString *) kABPersonAddressStreetKey] = [NSString stringWithFormat:@"%@\n%@", address, address2];
        else
            addressDictionary[(NSString *) kABPersonAddressStreetKey] = address;
    }
    //    if (venueCity)
    //        addressDictionary[(NSString *)kABPersonAddressCityKey] = venueCity;
    //    if (venueState)
    //        addressDictionary[(NSString *)kABPersonAddressStateKey] = venueState;
    //    if (venueZip)
    //        addressDictionary[(NSString *)kABPersonAddressZIPKey] = venueZip;
    //    if (venueCountry)
    //        addressDictionary[(NSString *)kABPersonAddressCountryKey] = venueCountry;
    
    ABMultiValueAddValueAndLabel(multiAddress, ( CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
    ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
    CFRelease(multiAddress);
    
    // let's show view controller
    ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init] ;

    controller.displayedPerson = person;
    controller.title = @"Add Mendis";
    
    controller.allowsAddingToAddressBook = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [_contactPopOverController dismissPopoverAnimated:NO];
    
    controller.navigationItem.leftBarButtonItem = [self createContactBackButton];
    [self createContactBackButton];
    
    CFRelease(person);
    CFRelease(controller);
    
}


- (void) ConnectSocialPressed
{
     [_contactPopOverController dismissPopoverAnimated:NO];
    
    PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:@"221" andArticleTitle:@"Social Connect" andCompanyId:@"17" andBackButtonHiddenFirst:NO]autorelease];
    
    [self.navigationController pushViewController:webViewController animated:YES];

}

- (void) shareButtonPressed:(id) sender
{
    NSBundle *bundle =  [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]];
    SOcialShareViewController *sharePanel  = [[[SOcialShareViewController alloc] initWithNibName:@"SOcialShareViewController" bundle:bundle] autorelease];
    sharePanel.parent = self;
    
    
    
    FPPopoverController *popOver = [[FPPopoverController alloc] initWithViewController:sharePanel];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        popOver.contentSize = CGSizeMake(120.5,200.5);
    } else {
        popOver.contentSize = CGSizeMake(250,415);
    }
    
    sharePanel.popOverController = popOver;
    [popOver presentPopoverFromView:sender];
}
#pragma mark - UIWebView Link Intercept Method

- (void)activateCall:(NSArray *)callNumbers
{
    self.callNumbers = callNumbers;
    UIActionSheet *actionSheet = [[[UIActionSheet alloc]initWithTitle:@"Call" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]autorelease];
    actionSheet.tag = 0;
    for (NSString *numbers in callNumbers) {
        
        [actionSheet addButtonWithTitle:numbers];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:[callNumbers count]];
    [actionSheet showInView:self.view];
    
}

- (void)branchZooming
{
    MKCoordinateRegion region ;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003f;
    span.longitudeDelta = 0.003f;
    region.span = span;
    region.center = coordinate;
    
    [_mapView setRegion:region animated:NO];
    [_mapView selectAnnotation:_annotation animated:NO];
}

- (void)activateMap:(NSArray*)coordinates
{
    self.backButton.hidden = FALSE;
    NSString *latitude = [coordinates objectAtIndex:0];
    NSString *longitude = [coordinates objectAtIndex:1];
    NSString *title = [coordinates objectAtIndex:2];
    title = [title stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    coordinate.latitude = [latitude floatValue];
    coordinate.longitude = [longitude floatValue];
    if (_annotation) {
        [_mapView removeAnnotation:_annotation];
    }
    self.annotation = [[[PCModelAnnotation alloc] initWithCoordinate:coordinate andannotationTitle:title] autorelease];
    [_mapView addAnnotation:_annotation];
    
    [self branchZooming];
    
    [UIView beginAnimations:nil context:nil];
    self.mapViewHolder.alpha = 1;
    [UIView commitAnimations];
}

- (void)activateSMS:(NSArray *)smsComponents
{
    
    NSString *smsNumber = [smsComponents objectAtIndex:0];
    NSString *smsMessage = [smsComponents objectAtIndex:1];
    
    smsMessage = [smsMessage stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    smsNumber = [smsNumber stringByReplacingOccurrencesOfString:@"%20" withString:@"-"];
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = smsMessage;
        controller.recipients = [NSArray arrayWithObjects:smsNumber, nil];
        controller.messageComposeDelegate = self;
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
    [self dismissModalViewControllerAnimated:NO];
}

- (void)activateMail:(NSArray *)mailComponents
{
    NSString *emailSubject = [mailComponents objectAtIndex:0];
    NSString *emailTo = [mailComponents objectAtIndex:1];
    NSString *emailMessage = [mailComponents objectAtIndex:2];
    
    emailSubject = [emailSubject stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    emailTo = [emailTo stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    emailMessage = [emailMessage stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            // alert.message = @"Message Canceled";
            break;
        case MFMailComposeResultSaved:
            // alert.message = @"Message Saved";
            break;
        case MFMailComposeResultSent:
            alert.message = @"Message Sent";
            
            [alert show];
            
            break;
        case MFMailComposeResultFailed:
            //  alert.message = @"Message Failed";
            break;
        default:
            //  alert.message = @"Message Not Sent";
            break;
    }
    [alert release];
    [self dismissModalViewControllerAnimated:NO];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return ;
    }
    NSString *callNumber = [_callNumbers objectAtIndex:buttonIndex];
    
    NSString *numberToCall = [NSString stringWithFormat:@"tel://%@",callNumber];
    
    if (actionSheet.tag == 0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:numberToCall]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numberToCall]];
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Check If the device is in Airplane mode, or the SIM card is removed, or the SIM cards service is deactivated or Device is not Iphone" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    }
}


#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange start;
    NSRange end;
    NSString *action = nil;
    NSString *dataToPass = nil;
    NSArray *dataArray = nil;
    if ([request.URL.scheme isEqualToString:@"native"]) {
        NSString *urlToOpen = [NSString stringWithFormat:@"%@",request.URL];
        
        start = [urlToOpen rangeOfString:@"::"];
        if (start.location != NSNotFound)
        {
            action = [urlToOpen substringFromIndex:start.location + start.length];
            end = [action rangeOfString:@"("];
            if (end.location != NSNotFound)
            {
                action = [action substringToIndex:end.location];
            }
            
            
        }
        
        start = [urlToOpen rangeOfString:@"("];
        if (start.location != NSNotFound) {
            
            dataToPass = [urlToOpen substringFromIndex:start.location + start.length];
            
            end = [dataToPass rangeOfString:@")"];
            if (end.location != NSNotFound) {
                dataToPass = [dataToPass substringToIndex:end.location];
            }
            
            dataArray = [dataToPass componentsSeparatedByString:@"::"];
            
        }
        
        if ([action isEqualToString:@"call"]) {
            [self activateCall:dataArray];
        } else if ([action isEqualToString:@"map"]) {
            [self activateMap:dataArray];
        } else if ([action isEqualToString:@"email"]) {
            [self activateMail:dataArray];
        } else if ([action isEqualToString:@"embeddedbrowser"]) {
            PCModelWebViewController *webViewLink = [[[PCModelWebViewController alloc]initWithUrlString:dataToPass andCompanyId:_companyId andDontRequest:YES]autorelease];
            [self.navigationController pushViewController:webViewLink animated:YES];
            
        } else if ([action isEqualToString:@"sms"]) {
            [self activateSMS:dataArray];
        } else if ([action isEqualToString:@"article"]) {
            NSString *title = [dataArray objectAtIndex:0];
            title = [title stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            NSString *articleId = [dataArray objectAtIndex:1];
            self.backButton.hidden = FALSE;
            PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:articleId andArticleTitle:title andCompanyId:_companyId andBackButtonHiddenFirst:NO]autorelease];
            [self.navigationController pushViewController:webViewController animated:YES];
            
        } else if ([action isEqualToString:@"list"]) {
            
            NSString *title = [dataArray objectAtIndex:0];
            title = [title stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            NSString *listId = [dataArray objectAtIndex:1];
            
            PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:listId andGroupListTitle:title andCompanyId:_companyId andHidesBackButtonFirst:NO]autorelease];
            [self.navigationController pushViewController:modelTableViewController animated:YES];
            
        } else if ([action isEqualToString:@"externalbrowser"]) {
            NSURL *url = [NSURL URLWithString:dataToPass];
            [[UIApplication sharedApplication]openURL:url];
        } else if ([action isEqualToString:@"Form"]) {
            
            NSString *formId = [dataArray objectAtIndex:1];
            NSString *formTittle = [dataArray objectAtIndex:0];
            formTittle = [formTittle stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            
            PCModelFormViewController *formViewCOntroller =[[[PCModelFormViewController alloc] initWithTittle:formTittle andFormId:formId andCompanyId:_companyId andClickId:1] autorelease];
            [self.navigationController pushViewController:formViewCOntroller animated:YES];
        }
        
        return NO;
    } else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        self.backButton.hidden = FALSE;
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.scalesPageToFit = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    if ([error code] != NSURLErrorCancelled) {
        NSString* errorString = [NSString stringWithFormat:
                                 
                                 @"<html><center><font size=+1 color='black'><br><br><br>An error occurred:<br>%@</font></center></html>",
                                 
                                 error.localizedDescription];
        
        [webView loadHTMLString:errorString baseURL:nil];
    }
}

@end
