//
//  MASkinCareProductsViewController.m
//  Mendis
//
//  Created by Basil Mariano on 9/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MASkinCareProductsViewController.h"
#import "WishList.h"
#import "MAProducsCell.h"

@interface MASkinCareProductsViewController ()

@property (nonatomic, retain) UIButton *wishBtn;
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSString *companyId;

@end

@implementation MASkinCareProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = PCNameForDevice(@"MASkinCareProductsViewController");
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.navigationItem.title = @"WishList - List";
    self.navigationItem.rightBarButtonItem = [self rightBarButton];
    
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
    NSString *cellIdentifier = @"MAProducsCell";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellIdentifier = @"MAProducsCell~ipad";
    }
    
    MAProducsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.arrowImage.hidden = TRUE;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.products.count == 0) {
        return cell;
    }
    
    WishList *wislist = (WishList *) [self.products objectAtIndex:indexPath.row];
    cell.productName.text = wislist.productName;
    
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

#pragma mark Private Functions
- (void) onContactsTap
{
    NSLog(@"a");
}

@end
