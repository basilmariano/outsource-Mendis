//
//  PCSecondTabViewController.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCModelTableViewController.h"
#import "PCModelWebViewController.h"
#import "PCCell.h"
#import "LSMainCell.h"
#import "DentistCell.h"
#import "ListId.h"
#import "ListIdNameVersionData.h"
#import "ListItemsData.h"
#import <MessageUI/MessageUI.h>
#import "SmileGalleryCell.h"
#import "ShareViewController.h"
#import "MAWishListViewController.h"
#import "MASkinCareProductsViewController.h"

@interface PCModelTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *groupListIdString;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSDictionary *defaultData;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *listSpinner;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic) BOOL changeNavigationBackground;
@property (nonatomic, retain) UIButton *wishBtn;

@end

@implementation PCModelTableViewController
{
    bool forWIishList;
}

- (id)initWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId andHidesBackButtonFirst:(BOOL)hidesBackButton
{
    
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelTableViewController");
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataNeeded:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",_groupListIdString]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(offlineData:)
                                                     name:[NSString stringWithFormat:DATA_OFFLINE_KEY,@"list",_groupListIdString]
                                                   object:nil];
        _filteredList = [[NSMutableArray alloc]init];
        _groupListIdString = [groupListIdString retain];
        _companyId = [companyId retain];
        if (!groupListTitle) {
            
        } else {
            self.navigationItem.title = groupListTitle;
        }
    }
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *contentView = [[[UIView alloc]init]autorelease];
    NSString *backImageName = @"PICClinicModel.bundle/Back_btn-s.png";

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        contentView.frame = CGRectMake(0, 0.0f, 420.0f, 44.0f);
        self.backButton.frame = CGRectMake(0.0f, 0.0f, 53.0f, 33.5f);
    } else { //IPAD
        contentView.frame = CGRectMake(0.0f, 0.0f, 768 , 44);
        self.backButton.frame = CGRectMake(0.0f, 18.0f, 97.0f, 64.0f);
    }
    
    UIImage *customNavigationBarBackButtonImage = [UIImage imageNamed:backImageName];
    [_backButton setImage:customNavigationBarBackButtonImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_backButton];
    
    UIBarButtonItem *navigationBarBackButton = [[UIBarButtonItem alloc] initWithCustomView:contentView] ;
    
    if (hidesBackButton) {
        self.backButton.hidden = TRUE;
    } else {
        self.backButton.hidden = FALSE;
    }
    
    self.navigationItem.leftBarButtonItem = navigationBarBackButton;
    
    return self;
    
}

- (id)initWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelTableViewController");
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataNeeded:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",_groupListIdString]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(offlineData:)
                                                     name:[NSString stringWithFormat:DATA_OFFLINE_KEY,@"list",_groupListIdString]
                                                   object:nil];
        _filteredList = [[NSMutableArray alloc]init];
        _groupListIdString = [groupListIdString retain];
        _companyId = [companyId retain];

    }
    
    self.navigationItem.title = groupListTitle;
    self.navigationItem.rightBarButtonItem = [self rightBarButton];
    
    return self;
}

- (id)initForProductsWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelTableViewController");
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataNeeded:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",_groupListIdString]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(offlineData:)
                                                     name:[NSString stringWithFormat:DATA_OFFLINE_KEY,@"list",_groupListIdString]
                                                   object:nil];
        _filteredList = [[NSMutableArray alloc]init];
        _groupListIdString = [groupListIdString retain];
        _companyId = [companyId retain];
        
    }
    
    forWIishList = YES;
    self.navigationItem.title = groupListTitle;
    self.navigationItem.rightBarButtonItem = [self rightBarButton];
    
    return self;
}

- (UIBarButtonItem *) rightBarButton
{
    UIView *contentView = [[[UIView alloc]init]autorelease];

    self.wishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"iphone_WishListsBtn-s.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"iphone_WishListsBtn-ss.png"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.wishBtn.frame = CGRectMake(0.0f, 0.0f, 70.0f, 34.5f);
        contentView.frame = self.wishBtn.frame;
    } else {
        buttonImage = [UIImage imageNamed:@"PICClinicModel.bundle/ipad_WishListsBtn-s.png"];
        buttonImagePressed = [UIImage imageNamed:@"PICClinicModel.bundle/ipad_WishListsBtn-ss.png"];
        
        self.wishBtn.frame = CGRectMake(650, 11, 158.0f, 75.5f);
        contentView.frame = self.wishBtn.frame;
    }
    
    [_wishBtn addTarget:self action:@selector(onWishListTap) forControlEvents:UIControlEventTouchUpInside];
    [_wishBtn setImage:buttonImage forState:UIControlStateNormal];
    [_wishBtn setImage:buttonImagePressed forState:UIControlStateSelected];
    
    [contentView addSubview:self.wishBtn];
    
    UIBarButtonItem *navigationBarBackButton = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    return navigationBarBackButton;
}

- (id)initWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId andChangeNavigationBackground:(BOOL)changeNavigationBackground
{
    _changeNavigationBackground = changeNavigationBackground;
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelTableViewController");
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataNeeded:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",_groupListIdString]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(offlineData:)
                                                     name:[NSString stringWithFormat:DATA_OFFLINE_KEY,@"list",_groupListIdString]
                                                   object:nil];
        
        _filteredList = [[NSMutableArray alloc]init];
        _groupListIdString = [groupListIdString retain];
        _companyId = [companyId retain];
        
        if (!groupListTitle) {
            
        } else {
            self.navigationItem.title = groupListTitle;
        }
    }
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *contentView = [[[UIView alloc]init]autorelease];
    NSString *backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        contentView.frame = CGRectMake(0.0f, 0.0f, 420.0f, 44.0f);
        self.backButton.frame = CGRectMake(0.0f, 5.5f, 55.0f, 32.5f);
        
    } else { //IPAD
        contentView.frame = CGRectMake(0.0f, 0.0f, 768, 44.0f);
        self.backButton.frame = CGRectMake(0.0f, 9.0f, 97.0f, 64.0f);
    }
    
    UIImage *customNavigationBarBackButtonImage = [UIImage imageNamed:backImageName];
    [_backButton setImage:customNavigationBarBackButtonImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_backButton];
    
    
    if ([_companyId isEqualToString:@"17"] && [_groupListIdString isEqualToString:@"30"]){
        
        _wishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _wishBtn.frame = CGRectMake(250, 5.5, 55.0, 32.5);
            
        }else{
            _wishBtn.frame = CGRectMake(500, 0, 60.0, 64.0);
        }
        [_wishBtn setTitle:@"Wishlist" forState:UIControlStateNormal];
        _wishBtn.titleLabel.font = [UIFont fontWithName:@"American Typewriter" size:10];
        [_wishBtn addTarget:self action:@selector(wishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_wishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [contentView addSubview:_wishBtn];
        //  [contentView bringSubviewToFront:_wishBtn ];// _wishBtn.hidden = false;
    }
    
    UIBarButtonItem *navigationBarBackButton = [[[UIBarButtonItem alloc] initWithCustomView:contentView]autorelease] ;
    self.navigationItem.leftBarButtonItem = navigationBarBackButton;
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_addButton release];
    [_wishBtn release];
    [_companyId release];
    [_backButton release];
    [_resultLabel release];
    [_filteredList release];
    [_listSpinner release];
    [_list release];
    [_defaultData release];
    [_tableView release];
    [_groupListIdString release];
    [_popOverController release];
    
    [super dealloc];
}

#pragma mark - View LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataNeeded:)
                                                 name:[NSString stringWithFormat:DATA_KEY,@"list",_groupListIdString]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(offlineData:)
                                                 name:[NSString stringWithFormat:DATA_OFFLINE_KEY,@"list",_groupListIdString]
                                               object:nil];
    
    if ([PCModelManager sharedManager].versionCheckFinished) {
        [self canRequestNow:nil];
    }
    if ([_companyId isEqualToString:@"7"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480) {
                self.tableView.frame = CGRectMake(0, 0,self.view.bounds.size.width,370);
                
            } else if(result.height == 568) {
                self.tableView.frame = CGRectMake(0, 0,self.view.bounds.size.width,459);
                
            }
            
        } else {
            self.tableView.frame = CGRectMake(0, 36,self.view.bounds.size.width,823);
        }
    } else if ([_companyId isEqualToString:@"8"]) {
        self.resultLabel.textColor = [UIColor colorWithRed:22.f/255 green:95.f/255 blue:48.f/255 alpha:1];
    } else if ([_companyId isEqualToString:@"17"]) {
        
        self.resultLabel.textColor = [UIColor blackColor];
        
    }
    
    if([self isEqual: [self.navigationController.viewControllers objectAtIndex:0] ]){
        // Put Back button in navigation bar
        self.backButton.hidden = TRUE;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultLabel.hidden = TRUE;
    if (_changeNavigationBackground) {
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_blank.png"];
    }
    if([_companyId isEqualToString:@"17"]) {
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_blank.png"];
    }
    
    if([_companyId isEqualToString:@"10"] || [_companyId isEqualToString:@"14"]) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _tableView.frame = CGRectMake(0.0f, 35.0f, 768.0f, 825.0f);
        } else {
            
            _tableView.frame = CGRectMake(0.0f, 3.0f, 320.0f, 368.0f);
        }
    } else if ([_companyId isEqualToString:@"7"]) {
        _tableView.backgroundColor = [UIColor colorWithRed:151.0f/255.0f green:134.0f/255.0f blue:108.0f/255.0f alpha:1];
        if (![_groupListIdString isEqualToString:@"1"]) {
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.separatorColor = [UIColor colorWithRed:104.0f/255.0f green:92.0f/255.0f blue:75.0f/255.0f alpha:1];
        }
    }
    
    if([_companyId isEqualToString:@"14"]) { // <- bearyFunGym
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _tableView.frame = CGRectMake(0.0f, 35.0f, 768.0f, 825.0f);
        } else {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480) {
                _tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 368.0f);
            } else if(result.height == 568) {
                _tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 455.0f);
            }
            
        }
        _tableView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:104.0f/255.0f green:92.0f/255.0f blue:75.0f/255.0f alpha:1];
    }
    
    if([_companyId isEqualToString:@"15"] || [_companyId isEqualToString:@"17"]) { // <- Wayan
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_blank.png"];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _tableView.frame = CGRectMake(0.0f, 35.0f, 768.0f, 825.0f);
        } else {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480) {
                _tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 368.0f);
            } else if(result.height == 568) {
                _tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 455.0f);
            }
            
        }
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor darkGrayColor];
    }
    // Do any additional setup after loading the view from its nib.
    if ([_companyId isEqualToString:@"14"])
        self.resultLabel.textColor = [UIColor colorWithRed:36.0f/255.0f green:97.0f/255.0f blue:166.0f/255.0f alpha:1]; //<-BearyFunGym
    if ([_companyId isEqualToString:@"17"]){
        self.resultLabel.textColor = [UIColor blackColor];
    }
    [self refreshDataGathered];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.resultLabel = nil;
    self.listSpinner = nil;
    self.tableView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getting data

- (void)backButtonPressed
{
    if (_changeNavigationBackground) {
        PCNavigationController *nav = (PCNavigationController *)self.navigationController;
        nav.backgroundImageView.image = [UIImage imageNamed:@"TopBanner_Mendis.png"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onWishListTap
{
    NSLog(@"wishPressed");
    MASkinCareProductsViewController *products = [[[MASkinCareProductsViewController alloc] initWithNibName:@"MASkinCareProductsViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:products animated:YES];
}


- (void)canRequestNow:(NSNotification *)notification
{
    if ([_groupListIdString isEqualToString:@"999"]) {
        self.resultLabel.hidden = FALSE;
        
        return;
    }
    [_filteredList removeAllObjects];
    
    NSArray *fetchedObjectsVersion = [PCRequestHandler fetchRequestListIdNameVersionData];
    NSInteger versionList = 0;
    NSInteger versionListData = 0;
    //listId
    // listVersion
    if (fetchedObjectsVersion.count) {
        for (NSManagedObject *info in fetchedObjectsVersion)
        {
            if ([[[info valueForKey:@"list_id"]stringValue] isEqualToString:_groupListIdString]) {
                versionListData = [[info valueForKey:@"version"]integerValue];
            }
        }
    }
    
    NSArray *fetchedListVersionData = [PCRequestHandler fetchRequestListVersionData];
    
    if (fetchedListVersionData.count) {
        for (NSManagedObject *info in fetchedListVersionData)
        {
            if ([[[info valueForKey:@"listId"]stringValue] isEqualToString:_groupListIdString]) {
                versionList = [[info valueForKey:@"listVersion"]integerValue];
            }
        }
        
    }
    NSArray *fetchedObjectsList = [PCRequestHandler fetchRequestListItemsData];
    
    if (fetchedObjectsList.count) {
        if (versionList != 1 && versionListData != versionList ) {
            
            [_listSpinner startAnimating];
            [[PCRequestHandler sharedInstance] requestGroupList:_groupListIdString andCompanyId:_companyId];
            
        } else {
            for (NSManagedObject *needed in fetchedObjectsList) {
                if ([_groupListIdString isEqualToString:[[needed valueForKey:@"list_id"]stringValue]]) {
                    [_filteredList addObject:needed];
                }
            }
            
            self.list = _filteredList;
            if (self.list.count) {
                self.resultLabel.hidden = TRUE;
            } else {
                if (!_defaultData) {
                    self.resultLabel.hidden = FALSE;
                }
                
            }
            
            [_tableView reloadData];
            
        }
        
    } else {
        
        if (versionList != 0 ) {
            
            [_listSpinner startAnimating];
            [[PCRequestHandler sharedInstance] requestGroupList:_groupListIdString andCompanyId:_companyId];
            
        } else {
            [_listSpinner stopAnimating];
            if ([self.groupListIdString isEqualToString:@"1"]) {
                NSString *defaultDate = @"2013-01-22 22:22:22";
                NSString *name = @"List 1";
                NSNumber *status = [NSNumber numberWithInt:0];
                NSNumber *version = [NSNumber numberWithInt:1];
                NSNumber *listId = [NSNumber numberWithInt:1];
                
                NSDictionary *image1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:999],@"action_id",
                                        [NSNumber numberWithInt:0],@"action_type",
                                        @"pic_1.png",@"image_url",
                                        @"Image 2",@"item_name",
                                        [NSNumber numberWithInt:1],@"item_id",
                                        nil];
                
                NSDictionary *image2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:999],@"action_id",
                                        [NSNumber numberWithInt:0],@"action_type",
                                        @"pic_2.png",@"image_url",
                                        @"Image 3",@"item_name",
                                        [NSNumber numberWithInt:2],@"item_id",
                                        nil];
                NSDictionary *image3 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:999],@"action_id",
                                        [NSNumber numberWithInt:0],@"action_type",
                                        @"pic_3.png",@"image_url",
                                        @"Image 4",@"item_name",
                                        [NSNumber numberWithInt:3],@"item_id",
                                        nil];
                
                NSDictionary *image4 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:999],@"action_id",
                                        [NSNumber numberWithInt:0],@"action_type",
                                        @"pic_4.png",@"image_url",
                                        @"Image 5",@"item_name",
                                        [NSNumber numberWithInt:4],@"item_id",
                                        nil];
                
                NSArray *array = [NSArray arrayWithObjects:image1,image2,image3,image4, nil];
                
                self.defaultData = [NSDictionary dictionaryWithObjectsAndKeys:defaultDate,@"datelastupdated",
                                    array,@"items",
                                    listId,@"list_id",
                                    name,@"name",
                                    status,@"status",
                                    version,@"version",
                                    nil];
                [_tableView reloadData];
            } else {
                self.resultLabel.hidden = FALSE;
            }
        }
    }
}

- (void)offlineData: (NSNotification *)notification
{
    [_listSpinner stopAnimating];
    
    [_filteredList removeAllObjects];
    NSArray *fetchedListItemsObjects = [PCRequestHandler fetchRequestListItemsData];
    if (fetchedListItemsObjects.count) {
        
        for (NSManagedObject *info in fetchedListItemsObjects) {
            if ([_groupListIdString isEqualToString:[[info valueForKey:@"list_id"]stringValue]]) {
                [_filteredList addObject:info];
            }
        }
        
        self.list = _filteredList;
        [_tableView reloadData];
    }
    if (self.list.count) {
        self.resultLabel.hidden = TRUE;
    } else {
        if (!_defaultData) {
            self.resultLabel.hidden = FALSE;
        }
    }
    
    
}

- (void)dataNeeded:(NSNotification *)notification
{
    [_filteredList removeAllObjects];
    //Check if there is Old Data. Every time call the API means there is new Data so need to delete old data.
    [_listSpinner stopAnimating];
    
    NSArray *fetchedOldObjects = [PCRequestHandler fetchRequestListIdNameVersionData];
    NSError *oldIdVersion = nil;
    if (fetchedOldObjects.count) {
        for (NSManagedObject *info in fetchedOldObjects) {
            
            
            if ([[[info valueForKey:@"list_id"]stringValue]isEqualToString:_groupListIdString]) {
                [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
            }
            
        }
        [[[PCModelManager sharedManager] managedObjectContext] save:&oldIdVersion];
    }
    
    NSArray *fetchedListItemsData = [PCRequestHandler fetchRequestListItemsData];
    NSError *oldListItems = nil;
    if (fetchedListItemsData.count) {
        for (NSManagedObject *info in fetchedListItemsData) {
            if ([[[info valueForKey:@"list_id"]stringValue]isEqualToString:_groupListIdString]) {
                [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
            }
        }
        [[[PCModelManager sharedManager] managedObjectContext] save:&oldListItems];
    }
    
    //----------------------------------------------------------------------------//
    
    //Method on Inserting New data in core data for there respective Entities.
    
    ListId *listId = (ListId *)[NSEntityDescription insertNewObjectForEntityForName:@"ListId" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    ListIdNameVersionData *listIdNameVersionData = (ListIdNameVersionData *)[NSEntityDescription insertNewObjectForEntityForName:@"ListIdNameVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    
    NSError *errorListId = nil;
    NSMutableSet *listIdSet = [NSMutableSet set];
    NSDictionary *data = [[notification userInfo] valueForKey:@"list"];
    
    if (data) {
        listIdNameVersionData.list_id = [NSNumber numberWithInteger:[[data valueForKey:@"list_id"] integerValue]];
        listIdNameVersionData.name = [data valueForKey:@"name"];
        listIdNameVersionData.version = [NSNumber numberWithInteger:[[data valueForKey:@"version"] integerValue]];
        [listIdSet addObject:listIdNameVersionData];
        
        NSArray *list = [data valueForKey:@"items"];
        NSMutableSet *listItemsSet = [NSMutableSet set];
        
        for (int i = 0; i < list.count; ++i) {
            
            ListItemsData *listData = (ListItemsData *)[NSEntityDescription insertNewObjectForEntityForName:@"ListItemsData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
            NSDictionary *imageDic = [list objectAtIndex:i];
            listData.action_id = [NSNumber numberWithInteger:[[imageDic valueForKey:@"action_id"] integerValue]];
            listData.action_type = [NSNumber numberWithInteger:[[imageDic valueForKey:@"action_type"]integerValue]];
            listData.item_name = [imageDic valueForKey:@"item_name"];
            listData.item_id = [imageDic valueForKey:@"item_id"];
            listData.image_url = [imageDic valueForKey:@"image_url"];
            listData.item_desc = [imageDic valueForKey:@"item_desc"];
            listData.sequence_id = [NSNumber numberWithInteger:[[imageDic valueForKey:@"sequence_id"]integerValue]];
            listData.list_id = [NSNumber numberWithInteger:[[data valueForKey:@"list_id"] integerValue]];
            [listItemsSet addObject:listData];
            
        }
        [listId addListItemsData:listItemsSet];
        [listId addListIdNameVersionData:listIdSet];
        [[[PCModelManager sharedManager] managedObjectContext] save:&errorListId];
    }
    
    // create fetch object, this object fetch's the objects out of the database
    
    NSArray *fetchedListItemsObjects = [PCRequestHandler fetchRequestListItemsData];
    if (fetchedListItemsObjects.count) {
        
        for (NSManagedObject *info in fetchedListItemsObjects) {
            if ([_groupListIdString isEqualToString:[[info valueForKey:@"list_id"]stringValue]]) {
                [_filteredList addObject:info];
            }
        }
        
        self.list = _filteredList;
        [_tableView reloadData];
    }
    if (self.list.count) {
        self.resultLabel.hidden = TRUE;
    } else {
        if (!_defaultData) {
            self.resultLabel.hidden = FALSE;
        }
    }
    
}

#pragma mark - TableView Datasource and TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0 ;
    if (self.list.count) {
        rows = self.list.count;
    } else if (self.defaultData) {
        NSArray *list = [_defaultData valueForKey:@"items"];
        rows = list.count;
    }
    return rows ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = nil;
    NSString *itemDesc = nil;
    NSString *imageUrl = nil;
    NSString *itemName = nil;
    //  if (self.list.count) {
    
    if (indexPath.row < [_list count]) {
        data = [_list objectAtIndex:indexPath.row];
    }
    
    itemDesc = [data valueForKey:@"item_desc"];
    imageUrl = [data valueForKey:@"image_url"];
    itemName = [data valueForKey:@"item_name"];
    
    
    if ([itemDesc isEqualToString:@""] && [imageUrl isEqualToString:@""]) {
        
        LSMainCell *cell = (LSMainCell *) [tableView dequeueReusableCellWithIdentifier:@"LSMainCell"];
        if (cell == nil) {
            cell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"LSMainCell" owner:self options:nil]objectAtIndex:0];
            
        }
        
        if ([_companyId isEqualToString:@"7"]) {
            // [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            cell.arrowImage.hidden = FALSE;
            cell.arrowImage.image = [UIImage imageNamed:@"PICClinicModel.bundle/DentistArrowCell.png"];
            
        } else if ([_companyId isEqualToString:@"8"]) {
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [tableView setBackgroundColor:[UIColor whiteColor]];
            cell.arrowImage.hidden = FALSE;
            cell.arrowImage.image = [UIImage imageNamed:@"PICClinicModel.bundle/LSCellArrow.png"];
        } else if ([_companyId isEqualToString:@"10"]) {
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            cell.arrowImage.hidden = FALSE;
            cell.arrowImage.image = [UIImage imageNamed:@"PICClinicModel.bundle/AMCArrowCell.png"];
        } else if ([_companyId isEqualToString:@"14"]) {
            cell.arrowImage.hidden = TRUE;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ([_companyId isEqualToString:@"15"]) {
            cell.arrowImage.hidden = TRUE;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ([_companyId isEqualToString:@"17"]) {
            cell.arrowImage.hidden = TRUE;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if ([_groupListIdString isEqualToString:@"10"]) {
                [cell.diseaseLabel setFont:[UIFont systemFontOfSize:18]];
                cell.diseaseLabel.frame = CGRectMake(20, 10, 259, 40);
                [cell.diseaseLabel setNumberOfLines:2];
                
            } else {
                [cell.diseaseLabel setFont:[UIFont systemFontOfSize:16]];
                // cell.diseaseLabel.frame = CGRectMake(20,0, 259, 25);
                [cell.diseaseLabel setNumberOfLines:1];
                if([_companyId isEqualToString:@"7"]) {
                    [cell.diseaseLabel setFont:[UIFont systemFontOfSize:18]];
                    cell.diseaseLabel.frame = CGRectMake(20, 17, 259, 25);
                    [cell.diseaseLabel setNumberOfLines:1];
                }
            }
        } else { //IPAD
            [cell.diseaseLabel setFont:[UIFont systemFontOfSize:36]];
            if ([_groupListIdString isEqualToString:@"10"]) {
                
                cell.diseaseLabel.frame = CGRectMake(60, 27, 650, 85);
                [cell.diseaseLabel setNumberOfLines:2];
                
            } else {
                [cell.diseaseLabel setFont:[UIFont systemFontOfSize:30]];
                if([_companyId isEqualToString:@"7"]) {
                    [cell.diseaseLabel setFont:[UIFont systemFontOfSize:36]];
                    cell.diseaseLabel.frame = CGRectMake(60, 45, 650, 45);
                    [cell.diseaseLabel setNumberOfLines:1];
                }
            }
        }
        cell.diseaseLabel.text = [data valueForKey:@"item_name"];
        if([_companyId isEqualToString:@"7"]) {
            cell.diseaseLabel.textColor = [UIColor whiteColor];
        } else if([_companyId isEqualToString:@"8"]) {
            cell.diseaseLabel.textColor = [UIColor darkGrayColor];
        }
        
        cell.companyId = self.companyId;
        
        return cell;
    }
    
    
    // }
    
    if (itemDesc && ![itemDesc isEqualToString:@""] && [imageUrl isEqualToString:@""] && ![itemName isEqualToString:@""]/*[_groupListIdString isEqualToString:@"9"]*/) { //<-for CANAAN smileGalery?
        
        SmileGalleryCell *cell = (SmileGalleryCell *) [tableView dequeueReusableCellWithIdentifier:@"SmileGalleryCell"];
        if (cell == nil) {
            cell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"SmileGalleryCell" owner:self options:nil]objectAtIndex:0];
        }
        cell.tittle.textColor = [UIColor whiteColor];
        cell.tittle.text = [data valueForKey:@"item_name"];
        cell.subTittle.textColor = [UIColor whiteColor];
        cell.subTittle.text = [data valueForKey:@"item_desc"];
        return cell;
    }
    
    //if ([_companyId isEqualToString:@"7"]) {
    
    if (indexPath.row < [_list count]) {
        data = [_list objectAtIndex:indexPath.row];
    }
    //itemDesc = [data valueForKey:@"item_desc"];
    //imageUrl = [data valueForKey:@"image_url"];
    
    if (itemDesc && ![itemDesc isEqualToString:@""]) {
        
        DentistCell *cell = (DentistCell *) [tableView dequeueReusableCellWithIdentifier:@"DentistCell"];
        if (cell == nil) {
            cell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"DentistCell" owner:self options:nil]objectAtIndex:0];
        }
        
        UIColor *DNtextColor = [UIColor whiteColor];
        UIColor *DDtextColor = [UIColor whiteColor];
        if([_companyId isEqualToString:@"14"]) {
            cell.dentistName.font = [UIFont boldSystemFontOfSize:16];
            cell.dentistDesc.font = [UIFont systemFontOfSize:12];
            DNtextColor = [UIColor blackColor];
            DDtextColor = [UIColor darkGrayColor];
            cell.arrow.image = [UIImage imageNamed:@"Arrow_AboutUs-ipad.png"];
        }
        
        NSURL *urlString = [NSURL URLWithString:[data valueForKey:@"image_url"]];
        [cell.asyncImageView loadImageFromURL:urlString];
        cell.asyncImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        cell.dentistName.text = [data valueForKey:@"item_name"];
        cell.dentistDesc.text = [data valueForKey:@"item_desc"];
        cell.dentistDesc.textColor = DDtextColor;
        cell.dentistName.textColor = DNtextColor;
        return cell;
    }
    if (itemDesc && [itemDesc isEqualToString:@""] && ![_groupListIdString isEqualToString:@"1"]) { //<- just for CANAAN hygeinist
        
        DentistCell *cell = (DentistCell *) [tableView dequeueReusableCellWithIdentifier:@"DentistCell"];
        if (cell == nil) {
            cell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"DentistCell" owner:self options:nil]objectAtIndex:0];
        }
        
        UIColor *DNtextColor = [UIColor whiteColor];
        UIColor *DDtextColor = [UIColor whiteColor];
        if([_companyId isEqualToString:@"14"]) {
            cell.dentistName.font = [UIFont boldSystemFontOfSize:16];
            cell.dentistDesc.font = [UIFont systemFontOfSize:12];
            DNtextColor = [UIColor blackColor];
            DDtextColor = [UIColor darkGrayColor];
        }
        
        NSURL *urlString = [NSURL URLWithString:[data valueForKey:@"image_url"]];
        [cell.asyncImageView loadImageFromURL:urlString];
        cell.asyncImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        cell.dentistName.text = [data valueForKey:@"item_name"];
        //cell.dentistDesc.text = [data valueForKey:@"item_desc"];
        cell.dentistDesc.textColor = DDtextColor;
        cell.dentistName.textColor = DNtextColor;
        return cell;
    }
    // }
    
    PCCell *cell = (PCCell *) [tableView dequeueReusableCellWithIdentifier:@"PCCell"];
    if (cell == nil) {
        cell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"PCCell" owner:self options:nil]objectAtIndex:0];
        
    }
    
    NSArray *items = [_defaultData valueForKey:@"items"];
    if (items.count) {
        if (indexPath.row < [items count]) {
            data = [items objectAtIndex:indexPath.row];
        }
    } else if ([_list count]) {
        if (indexPath.row < [_list count]) {
            data = [_list objectAtIndex:indexPath.row];
        }
    }
    
    if (data && self.list.count) {
        cell.imageView.hidden = TRUE;
        cell.asyncImageView.hidden = FALSE;
        NSURL *urlString = [NSURL URLWithString:[data valueForKey:@"image_url"]];
        [cell.asyncImageView loadImageFromURL:urlString];
        cell.asyncImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
    } else if (data && items.count) {
        cell.imageView.hidden = FALSE;
        cell.asyncImageView.hidden = TRUE;
        NSString *imageUrl = [data valueForKey:@"image_url"];
        
        if (![imageUrl isEqualToString:@""]) {
            UIImage *imageForList = [UIImage imageNamed:[data valueForKey:@"image_url"]];
            [cell.imageView setImage:imageForList];
        }
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //refracted the code
    UITableViewCell *obj = (UITableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if([obj isMemberOfClass:[DentistCell class]]) {
        DentistCell *cell = (DentistCell *) obj;
        return cell.frame.size.height;
    } else if([obj isKindOfClass:[LSMainCell class]]) {
        LSMainCell *cell = (LSMainCell *) obj;
        return cell.frame.size.height;
    } else if([obj isKindOfClass:[PCCell class]]) {
        PCCell *cell = (PCCell *) obj;
        return cell.frame.size.height;
    } else if([obj isKindOfClass:[SmileGalleryCell class]]) {
        SmileGalleryCell *cell = (SmileGalleryCell *) obj;
        return cell.frame.size.height;
    }
    
    /*  int height = 0;
     NSDictionary *data = nil;
     NSString *itemDesc = nil;
     NSString *imageUrl = nil;
     if ([_companyId isEqualToString:@"8"] || [_companyId isEqualToString:@"10"]) {
     data = [_list objectAtIndex:indexPath.row];
     itemDesc = [data valueForKey:@"item_desc"];
     imageUrl = [data valueForKey:@"image_url"];
     
     if ([itemDesc isEqualToString:@""] && [imageUrl isEqualToString:@""]) {
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     height = 60;
     } else { //IPAD
     height = 135;
     }
     
     }
     return height;
     
     } else if ([_companyId isEqualToString:@"7"]) {
     data = [_list objectAtIndex:indexPath.row];
     itemDesc = [data valueForKey:@"item_desc"];
     imageUrl = [data valueForKey:@"image_url"];
     
     if (itemDesc && ![itemDesc isEqualToString:@""]) {
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     height = 70;
     } else { //IPAD
     height = 150;
     }
     return height;
     
     } else if ([itemDesc isEqualToString:@""] && [imageUrl isEqualToString:@""]) {
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     height = 60;
     } else { //IPAD
     height = 135;
     }
     return height;
     }
     
     }
     
     if (itemDesc && [itemDesc isEqualToString:@""] && ![_groupListIdString isEqualToString:@"1"]) { //<-for the CANAAN hygienist hahaah
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     height = 70;
     } else { //IPAD
     height = 150;
     }
     return height;
     }
     
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     CGSize result = [[UIScreen mainScreen] bounds].size;
     
     if(result.height == 480) {
     height = 93;
     } else if(result.height == 568) {
     height = 91;
     }
     
     
     } else { //IPAD
     height = 205;
     }
     
     return height; */
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * data = nil;
    NSArray *items = [_defaultData valueForKey:@"items"];
    NSNumber *actionType = nil;
    NSNumber *actionId = nil;
    NSString *articleTitle = nil;
    if (items.count) {
        if (indexPath.row < [items count]) {
            data = [items objectAtIndex:indexPath.row];
        }
    } else if ([_list count]) {
        if (indexPath.row < [_list count]) {
            data = [_list objectAtIndex:indexPath.row];
        }
    }
    
    
    if (data && items.count) {
        actionType = [data valueForKey:@"action_type"];
        actionId = [data valueForKey:@"action_id"];
        articleTitle = [data valueForKey:@"item_name"];
    } else if (data && self.list.count) {
        actionType = [data valueForKey:@"action_type"];
        actionId = [data valueForKey:@"action_id"];
        articleTitle = [data valueForKey:@"item_name"];
    }
    
    
    
    if([actionId isEqualToNumber:[NSNumber numberWithInt:2]] && [articleTitle isEqualToString:@"Invite My Friends"]) {
        NSObject *obj = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        if([obj isKindOfClass:[PCCell class]]) {
            PCCell *cell = (PCCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            [self showActionSheetInView:cell];
        }
        return;
    }
    if ([actionType integerValue] == 1) {
        if (forWIishList) {
            PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc] initWithArticleIdForWishList:[actionId stringValue] andArticleTitle:articleTitle andCompanyId:_companyId] autorelease];
            [self.navigationController pushViewController:webViewController animated:YES];
        } else {
            PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:[actionId stringValue] andArticleTitle:articleTitle andCompanyId:_companyId andBackButtonHiddenFirst:NO]autorelease];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
       
    } else  if ([actionType integerValue] == 0) {
        
        if (actionId) {
            PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:[actionId stringValue] andGroupListTitle:articleTitle andCompanyId:_companyId andHidesBackButtonFirst:NO]autorelease];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self.navigationController pushViewController:modelTableViewController animated:YES];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_companyId isEqualToString:@"10"]) {
        UIImageView *selBGView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AMC-Listview-bg-s.png"]] autorelease];
        
        cell.backgroundView = selBGView;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)updateRefreshLabelForScrollViewEvent:(UIScrollView *)scrollView {
    
    if (![_groupListIdString isEqualToString:@"99"]) {
        
        if ([_companyId isEqualToString:@"10"])
            self.resultLabel.textColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:196.0f/255.0f alpha:1]; //<-AMC
        if ([_companyId isEqualToString:@"7"])
            self.resultLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1]; //<-Canaan
        if ([_companyId isEqualToString:@"14"])
            self.resultLabel.textColor = [UIColor colorWithRed:36.0f/255.0f green:97.0f/255.0f blue:166.0f/255.0f alpha:1]; //<-BearyFunGym
        if ([_companyId isEqualToString:@"15"])
            self.resultLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:28.0f/255.0f blue:12.0f/255.0f alpha:1]; //<-BearyFunGym
        if ([_companyId isEqualToString:@"17"])
            self.resultLabel.textColor = [UIColor blackColor]; //<-Mendis
        self.resultLabel.hidden = FALSE;
        int yOffset = scrollView.contentOffset.y;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            if (yOffset <= -50) {
                self.resultLabel.frame = CGRectMake(85, scrollView.frame.origin.y - 15 - yOffset, 150, 15);
                self.resultLabel.text = @"Release To Refresh...";
                
            } else if (yOffset <= 0) {
                
                self.resultLabel.frame = CGRectMake(120, scrollView.frame.origin.y - 15 - yOffset, 150, 15);
                self.resultLabel.text = @" Pull More...";
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height == 480) {
                    self.resultLabel.frame = CGRectMake(120, scrollView.frame.origin.y - 15 - yOffset, 150, 15);
                    self.resultLabel.text = @"Pull More...";
                    
                } else if(result.height == 568) {
                    //Iphone 5 (Retina 4inch)
                    self.resultLabel.frame = CGRectMake(80, scrollView.frame.origin.y - 15 - yOffset, 150, 15);
                    self.resultLabel.text = @"Pull More...";
                }
                
            }
            
        } else   if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.resultLabel setFont:[UIFont systemFontOfSize:30]];
            if (yOffset <= -100) {
                self.resultLabel.frame = CGRectMake(206, scrollView.frame.origin.y - 30 - yOffset , 350, 35);
                self.resultLabel.text = @"Release To Refresh...";
            } else if (yOffset<= 0) {
                self.resultLabel.frame = CGRectMake(210, scrollView.frame.origin.y - 30 - yOffset , 350, 35);
                self.resultLabel.text = @"Pull More...";
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateRefreshLabelForScrollViewEvent:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self updateRefreshLabelForScrollViewEvent:scrollView];
}

- (void)requestingMethod
{
    if (![_groupListIdString isEqualToString:@"99"]) {
        if (_defaultData) {
            self.defaultData = nil;
        }
        self.resultLabel.hidden = TRUE;
        [_listSpinner startAnimating];
        [[PCRequestHandler sharedInstance]requestGroupList:_groupListIdString andCompanyId:_companyId];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int yOffset = scrollView.contentOffset.y;
    
    NSInteger versionList = 0;
    NSArray *fetchedListVersionData = [PCRequestHandler fetchRequestListVersionData];
    
    if (fetchedListVersionData.count) {
        for (NSManagedObject *info in fetchedListVersionData)
        {
            if ([[[info valueForKey:@"listId"]stringValue] isEqualToString:_groupListIdString]) {
                versionList = [[info valueForKey:@"listVersion"]integerValue];
            }
        }
        
    }
    if (versionList != 0) {
        // if (self.tableView.hidden == FALSE)  {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (yOffset <= -50) {
                [self requestingMethod];
            }
        } else {
            if (yOffset <= -100) {
                [self requestingMethod];
            }
        }
        // }
        
    }
    
}

- (void) refreshDataGathered
{
    NSInteger versionList = 0;
    NSArray *fetchedListVersionData = [PCRequestHandler fetchRequestListVersionData];
    
    if (fetchedListVersionData.count) {
        for (NSManagedObject *info in fetchedListVersionData)
        {
            if ([[[info valueForKey:@"listId"]stringValue] isEqualToString:_groupListIdString]) {
                versionList = [[info valueForKey:@"listVersion"]integerValue];
            }
        }
        
    }
    if (versionList != 0) {
        [self requestingMethod];
    }
}

- (void)showActionSheetInView:(UIView *)cellView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIView *view = [[UIView alloc] init];
        UIViewController *contentViewController = [[[UIViewController alloc] init] autorelease];
        contentViewController.contentSizeForViewInPopover = CGSizeMake(760.0f, 225.0f);
        _popOverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
        self.popOverController.delegate = self;
        view = contentViewController.view;
        
        [_popOverController presentPopoverFromRect:cellView.bounds inView:cellView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        float senderViewHeight = view.frame.size.height;
        
        if (senderViewHeight < 225) {
            [self.popOverController dismissPopoverAnimated:YES];
            self.popOverController = nil;
            _popOverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
            self.popOverController.delegate = self;
            view = contentViewController.view;
            [_popOverController presentPopoverFromRect:cellView.bounds inView:cellView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        
        UIView *actionSheetView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
        UIActionSheet *aSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil] autorelease];
        [aSheet addButtonWithTitle:@"Email"];
        [aSheet addButtonWithTitle:@"SMS"];
        [aSheet addButtonWithTitle:@"Facebook"];
        aSheet.cancelButtonIndex = [aSheet addButtonWithTitle:@"Cancel"];
        aSheet.delegate = self;
        [actionSheetView addSubview:aSheet];
        
        [view addSubview:actionSheetView];
        [aSheet showInView:actionSheetView];
        [view release];
        
    } else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil] autorelease];
        [actionSheet addButtonWithTitle:@"Email"];
        [actionSheet addButtonWithTitle:@"SMS"];
        [actionSheet addButtonWithTitle:@"Facebook"];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        return;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            
            [self activateMail];
            break;
        }
        case 1: {
            
            [self activateSMS];
            break;
        }
        case 2: {
            NSString *textViewPlaceHolder = nil;
            if ([_companyId isEqualToString:@"7"]) {
                textViewPlaceHolder = @"Come join me at Canaan Dentals.";
            }
            
            ShareViewController *shareViewController = [[[ShareViewController alloc] initWithPlaceHolder:textViewPlaceHolder]autorelease];
            shareViewController.senderTag = 0;
            [self.navigationController pushViewController:shareViewController animated:YES];
            break;
        }
        case 3: {
            
            break;
        }
            
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [_popOverController dismissPopoverAnimated:NO];
        _popOverController = nil;
    }
}

- (void)activateSMS
{
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        //controller.recipients = [NSArray arrayWithObjects:smsNumber, nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:NO];
    }
    
}

- (void)activateMail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [self presentModalViewController:mfViewController animated:YES];
        [mfViewController release];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
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
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
