//
//  MAFirstTabViewController.m
//  Mendis
//
//  Created by Wong Johnson on 6/27/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MAFirstTabViewController.h"
#import "ImageData.h"
#import "ImageSliderData.h"
#import "PCTabBarController.h"
#import "XCDeviceManager.h"
#import "PCNavigationController.h"
#import "MASkinQuizViewController.h"
#import "MASkinIssuesViewController.h"
#import "MASServicesViewController.h"

@interface MAFirstTabViewController ()
{
    int imageCounter;
}

@property (nonatomic, retain) NSDictionary *defaultData;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableArray *asyncImageArray;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *imageSliderId;

- (IBAction)aboutUsPressed:(id)sender;
- (IBAction)takeOurSkinQuizPressed:(id)sender;
- (IBAction)skinIssuesToSolvePressed:(id)sender;
- (IBAction)promotionsPressed:(id)sender;

@end

@implementation MAFirstTabViewController

- (id)initWithArticleId:(NSString *)articleId andImageSliderId:(NSString *)imageSliderId andCompanyId:(NSString *)companyId;
{
    NSString *nibNameOrNil = [[XCDeviceManager manager] xibNameForDevice:@"MAFirstTabViewController"];
    if (self = [self initWithNibName:nibNameOrNil bundle:nil]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(canRequestNow:)
                                                     name:VERSION_CHECK_READY
                                                   object:nil];
        
        _companyId       = [companyId retain];
        _imageSliderId   = [imageSliderId retain];
        _asyncImageArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageSliderId release];
    [_companyId release];
    [_asyncImageArray release];
    [_defaultData release];
    [_timer invalidate];
    [_timer release];
    [_images release];
    [_swipeView release];
    [_pageControl release];
    
    [super dealloc];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataNeeded:)
                                                 name:[NSString stringWithFormat:DATA_KEY,@"imageslider",_imageSliderId]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(offlineData:)
                                                 name:[NSString stringWithFormat:DATA_OFFLINE_KEY,@"imageslider",_imageSliderId]
                                               object:nil];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.94509804 green:0.38823529 blue:0.3372549 alpha:1];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.pageControl.indicatorDiameter = 11.0f;
    } else { //IPAD
        self.pageControl.indicatorDiameter = 20.0f;
    }
    
    _swipeView.alignment         = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled     = YES;
    _swipeView.wrapEnabled       = NO;
    _swipeView.itemsPerPage      = 1;
    _swipeView.truncateFinalPage = YES;
    
    //configure page control
    _pageControl.defersCurrentPageDisplay = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pageControl = nil;
    self.swipeView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pageControl.hidden = FALSE;
    self.swipeView.hidden = FALSE;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                               valueOrTarget:[NSValue valueWithNonretainedObject:self]
                                                    selector:@selector(scrollTo:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [_timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Getting data

- (void)canRequestNow:(NSNotification *)notification
{
    NSArray *fetchedObjectsVersion = [PCRequestHandler fetchRequestImageSliderVersionData];
    NSInteger versionImageSlider1 = 0;
    NSInteger versionImageSliderData1 = 0;
    
    if (fetchedObjectsVersion.count) {
        for (NSManagedObject *info in fetchedObjectsVersion)
        {
            if ([[info valueForKey:@"imageSliderId"]integerValue] == [_imageSliderId integerValue]) {
                versionImageSlider1 = [[info valueForKey:@"imageSliderVersion"]integerValue];
            }
        }
    }
    
    NSFetchRequest *fetchRequestImageSliderData = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entityImageSliderData = [NSEntityDescription entityForName:@"ImageSliderData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequestImageSliderData setEntity:entityImageSliderData];
    NSError *errorImageSliderData = nil;
    NSArray *fetchedObjectsImageSliderData = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequestImageSliderData error:&errorImageSliderData];
    
    for (NSManagedObject *info in fetchedObjectsImageSliderData)
    {
#ifdef DEBUG
        NSLog(@"imageSliderName: %@", [info valueForKey:@"imageSliderName"]);
#endif
        
        if ([[info valueForKey:@"imageSliderId"]integerValue] == [_imageSliderId integerValue]) {
            versionImageSliderData1 = [[info valueForKey:@"imageSliderVersion"]integerValue];
        }
    }
#ifdef DEBUG
    NSLog(@"versionImageSlider1 : %d = versionImageSliderData1 : %d",versionImageSlider1,versionImageSliderData1);
#endif
    NSArray *fetchedObjectsImageSlider = [PCRequestHandler fetchRequestImageSliderData];
    
    if (fetchedObjectsImageSlider.count) {
        if (versionImageSlider1 != 1 && versionImageSliderData1 != versionImageSlider1 ) {
            
            if (_defaultData) {
                self.defaultData = nil;
            }
            [[PCRequestHandler sharedInstance] requestImageSlider:_imageSliderId andCompanyId:_companyId];
            
        } else {
            
            if (_defaultData) {
                self.defaultData = nil;
            }
            self.images = fetchedObjectsImageSlider;
            [_asyncImageArray removeAllObjects];
            [self loadSlideData];
            
        }
    } else {
        if (versionImageSlider1 != 0 ) {
            
            if (_defaultData) {
                self.defaultData = nil;
            }
            [[PCRequestHandler sharedInstance] requestImageSlider:_imageSliderId andCompanyId:_companyId];
            
        } else {
            
            NSString *defaultDate = @"2013-01-22 22:22:22";
            NSString *name = @"Image Slider 1";
            NSNumber *status = [NSNumber numberWithInt:0];
            NSNumber *version = [NSNumber numberWithInt:1];
            NSNumber *sliderId = [NSNumber numberWithInt:1];
            
            NSDictionary *image1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"article_id",
                                    [NSNumber numberWithInt:1],@"image_id",
                                    @"Image 2",@"image_name",
                                    @"image1.png",@"image_url",
                                    nil];
            
            NSDictionary *image2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"article_id",
                                    [NSNumber numberWithInt:2],@"image_id",
                                    @"Image 3",@"image_name",
                                    @"image2.png",@"image_url",
                                    nil];
            NSDictionary *image3 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"article_id",
                                    [NSNumber numberWithInt:3],@"image_id",
                                    @"Image 4",@"image_name",
                                    @"image3.png",@"image_url",
                                    nil];
            
            NSArray *array = [NSArray arrayWithObjects:image1,image2,image3, nil];
            
            self.defaultData = [NSDictionary dictionaryWithObjectsAndKeys:defaultDate,@"datelastupdated",
                                array,@"images",
                                sliderId,@"imageslider_id",
                                name,@"name",
                                status,@"status",
                                version,@"version",
                                nil];
            
            _pageControl.numberOfPages = _swipeView.numberOfPages;
            
            
            [_swipeView reloadData];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertView = nil;
}

- (void)scrollTo:(NSInteger)index
{
    NSArray *images = [_defaultData valueForKey:@"images"];
    NSArray *imageToLoad = nil;
    if (self.images.count) {
        imageToLoad = self.images;
        
    } else if (images.count) {
        imageToLoad = images;
    }
    
    if (self.pageControl.currentPage != [imageToLoad count] - 1) {
        
        [_swipeView scrollToItemAtIndex:self.pageControl.currentPage +1 duration:1.0f];
        self.pageControl.currentPage ++;
        
    } else {
        self.swipeView.currentPage = 0;
        self.pageControl.currentPage = 0;
        [_swipeView scrollToItemAtIndex: self.pageControl.currentPage duration:1.0f];
        self.pageControl.currentPage ++;
    }
    self.pageControl.currentPage = self.swipeView.currentPage;
    
}

- (void)offlineData: (NSNotification *)notification
{
    NSArray *fetchedObjects = [PCRequestHandler fetchRequestImageSliderData];
    if (fetchedObjects.count) {
        
        self.images = fetchedObjects;
        [_asyncImageArray removeAllObjects];
        [self loadSlideData];
    }
}

- (void)dataNeeded:(NSNotification *)notification
{
    //Check if there is Old Data. Every time call the API means there is new Data so need to delete old data.
    
    NSArray *fetchedOldObjectsImage = [PCRequestHandler fetchRequestImageSliderData];
    NSError *oldImages = nil;
    if (fetchedOldObjectsImage.count) {
        for (NSManagedObject *info in fetchedOldObjectsImage)
        {
            [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
        }
        [[[PCModelManager sharedManager] managedObjectContext] save:&oldImages];
    }
    //----------------------------------------------------------------------------//
    
    //Method on Inserting New data in core data for there respective Entities.
    
    ImageSliderData *imageSliderData = (ImageSliderData *)[NSEntityDescription insertNewObjectForEntityForName:@"ImageSliderData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    NSError *error = nil;
    NSDictionary *dataCapture = [[notification userInfo] valueForKey:@"imageslider"];
    
    if (dataCapture) {
        imageSliderData.imageSliderName = [dataCapture valueForKey:@"name"];
        imageSliderData.imageSliderId = [NSNumber numberWithInteger:[[dataCapture valueForKey:@"imageslider_id"] integerValue]];
        imageSliderData.imageSliderVersion = [NSNumber numberWithInteger:[[dataCapture valueForKey:@"version"] integerValue]];
        NSArray *images = [dataCapture valueForKey:@"images"];
        NSMutableSet *imagesSet = [NSMutableSet set];
        for (int i = 0; i < images.count; ++i) {
            ImageData *imageData = (ImageData *)[NSEntityDescription insertNewObjectForEntityForName:@"ImageData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
            NSDictionary *imageDic = [images objectAtIndex:i];
            imageData.imageId = [NSNumber numberWithInteger:[[imageDic valueForKey:@"image_id"] integerValue]];
            imageData.articleId = [NSNumber numberWithInteger:[[imageDic valueForKey:@"article_id"]integerValue]];
            imageData.imageName = [imageDic valueForKey:@"image_name"];
            imageData.imageUrl = [imageDic valueForKey:@"image_url"];
            imageData.imageSequenceId = [imageDic valueForKey:@"sequence_id"];
            
            [imagesSet addObject:imageData];
        }
        [imageSliderData addImagesData:imagesSet];
        [[[PCModelManager sharedManager] managedObjectContext] save:&error];
    }
    // create fetch object, this object fetch's the objects out of the database
    
    NSArray *fetchedObjects = [PCRequestHandler fetchRequestImageSliderData];
    if (fetchedObjects.count) {
        self.images = fetchedObjects;
        [_asyncImageArray removeAllObjects];
        [self loadSlideData];
    }
    
}

- (void)loadSlideData
{
    for (int x= 0; x < [_images count]; x++) {
        PCAsyncImageView *asynImageView = [[[PCAsyncImageView alloc]init]autorelease];
        asynImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width ,self.swipeView.bounds.size.height);
        NSDictionary *imageData = [_images objectAtIndex:x];
        NSURL *imageURL = [NSURL URLWithString:[imageData valueForKey:@"imageUrl"]];
        [asynImageView loadImageFromURL:imageURL];
        
        [_asyncImageArray addObject:asynImageView];
    }
    _pageControl.numberOfPages = _swipeView.numberOfPages;
    [_swipeView reloadData];
    
    
}

# pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    NSInteger row = 0;
    if (self.images.count) {
        row = self.images.count;
    } else if (_defaultData){
        NSArray *images = [_defaultData valueForKey:@"images"];
        row = images.count;
    }
    return row;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSArray *images = [_defaultData valueForKey:@"images"];
    NSDictionary *imageDataDefault = [images objectAtIndex:index];
    PCAsyncImageView * articleImage = (PCAsyncImageView *)view;
    UIImageView *imageView = (UIImageView *)view;
    //create or reuse view
    if (view == nil)
    {
        if (images.count) {
            imageView = [[[UIImageView alloc]init]autorelease];
            imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width ,self.swipeView.bounds.size.height);
        }
        
    }
    
    if (self.images.count) {
        articleImage = [_asyncImageArray objectAtIndex:index];
        view = articleImage;
    } else {
        view = imageView;
        [imageView setImage:[UIImage imageNamed:[imageDataDefault valueForKey:@"image_url"]]];
    }
    //return view
    return view;
}

#pragma mark - SwipeViewDelegate

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    //update page control page
    _pageControl.currentPage = self.swipeView.currentPage;
    // [_timer invalidate];
    
}

- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate
{
    if (self.timer) {
        [_timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                               valueOrTarget:[NSValue valueWithNonretainedObject:self]
                                                    selector:@selector(scrollTo:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *imageData = nil;
    if (self.images.count) {
        imageData = [_images objectAtIndex:index];
        NSNumber *articleId = [imageData valueForKey:@"articleId"];
        if ([articleId integerValue] != 0) {
            PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:[articleId stringValue] andArticleTitle:nil andCompanyId:_companyId andBackButtonHiddenFirst:NO]autorelease];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

#pragma mark - IBAction

- (IBAction)pageControlTapped
{
    //update swipe view page
    [_swipeView scrollToPage:_pageControl.currentPage duration:0.4];
    
}

- (IBAction)aboutUsPressed:(id)sender
{
    PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:@"154" andArticleTitle:@"About Us" andCompanyId:@"17" andChangeNavigationBackground:YES]autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}
- (IBAction)takeOurSkinQuizPressed:(id)sender
{
   // MASkinQuizViewController *skinQuizViewController = [[[MASkinQuizViewController alloc]init]autorelease];
   // [self.navigationController pushViewController:skinQuizViewController animated:YES];
    PCModelWebViewController *webViewController = [[[PCModelWebViewController alloc]initWithArticleId:@"220" andArticleTitle:@"Beauty and Lifestyle" andCompanyId:@"17" andChangeNavigationBackground:YES]autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}
- (IBAction)skinIssuesToSolvePressed:(id)sender
{
    MASkinIssuesViewController *skinIssuesViewController = [[[MASkinIssuesViewController alloc]init]autorelease];
    [self.navigationController pushViewController:skinIssuesViewController animated:YES];
}
- (IBAction)promotionsPressed:(id)sender
{
    PCModelTableViewController *modelTableViewController = [[[PCModelTableViewController alloc]initWithGroupListId:@"28"andGroupListTitle:@"Promotions" andCompanyId:_companyId andChangeNavigationBackground:YES]autorelease];
    
    [self.navigationController pushViewController:modelTableViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
