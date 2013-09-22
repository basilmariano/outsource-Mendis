//
//  MAAppDelegate.m
//  Mendis
//
//  Created by Wong Johnson on 6/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MAAppDelegate.h"
#import "MAFirstTabViewController.h"
#import "PCNavigationController.h"
#import "PCAppointmentTableViewController.h"
#import "MASServicesViewController.h"


static MAAppDelegate *sharedInstance;
@interface MAAppDelegate()
@end
@implementation MAAppDelegate


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (id)init
{
    if (sharedInstance) {
#ifdef DEBUG
        NSLog(@"ERROR!...Creating another PCAppDelegate");
#endif
        
    }
    [super init];
    sharedInstance = self;
    return self;
}

+ (MAAppDelegate *)sharedPCAppDelegate
{
    return sharedInstance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    PCTabBarController *tabBarController = [[[PCTabBarController alloc]initWithTabBarBackgroundImage:nil] autorelease];
    
    MAFirstTabViewController *home = [[[MAFirstTabViewController alloc]initWithArticleId:nil andImageSliderId:@"7" andCompanyId:@"17"]autorelease];
    
    MASServicesViewController *services = [[MASServicesViewController alloc]init];
    
    PCModelTableViewController *products = [[[PCModelTableViewController alloc] initForProductsWithGroupListId:@"30"andGroupListTitle:@"Skin Care Product" andCompanyId:@"17"] autorelease];
 
    PCAppointmentTableViewController *appointment = [[[PCAppointmentTableViewController alloc] init] autorelease];
    
    PCModelWebViewController *contactUs = [[[PCModelWebViewController alloc]initWithArticleId:@"153" andArticleTitle:@"Contact Us" andCompanyId:@"17" andBackButtonHiddenFirst:YES]autorelease];
    
    UIImage *WithTitleImage = [UIImage imageNamed:@"TopBanner_Mendis.png"];
    UIImage *image = [UIImage imageNamed:@"TopBanner_blank.png"];
    
    PCNavigationController *firstTabNavigationController  = [[[PCNavigationController alloc]initWithRootViewController:home]autorelease];
    firstTabNavigationController.backgroundImageView.image = WithTitleImage;
    firstTabNavigationController.navigationTitle.textColor = [UIColor blackColor];
    
    PCNavigationController *secondTabNavigationController = [[[PCNavigationController alloc]initWithRootViewController:services]autorelease];
    secondTabNavigationController.backgroundImageView.image = image;
    secondTabNavigationController.navigationTitle.textColor = [UIColor blackColor];
    
    PCNavigationController *thirdTabNavigationController  = [[[PCNavigationController alloc]initWithRootViewController:products]autorelease];
    thirdTabNavigationController.backgroundImageView.image = image;
    thirdTabNavigationController.navigationTitle.textColor = [UIColor blackColor];
    
    PCNavigationController *fourthTabNavigationController = [[[PCNavigationController alloc]initWithRootViewController:appointment]autorelease];
    fourthTabNavigationController.backgroundImageView.image = image;
    fourthTabNavigationController.navigationTitle.textColor = [UIColor blackColor];
    
    PCNavigationController *fifthTabNavigationController = [[[PCNavigationController alloc]initWithRootViewController:contactUs]autorelease];
    fifthTabNavigationController.backgroundImageView.image = image;
    fifthTabNavigationController.navigationTitle.textColor = [UIColor blackColor];
    
    UIImage *tabBarFirstButtonImagePress = [UIImage imageNamed:@"MAHomePressed.png"];
    UIImage *tabBarFirstButtonImage = [UIImage imageNamed:@"MAHome.png"];
    UIImage *tabBarSecondButtonImagePress = [UIImage imageNamed:@"MAServicesPressed.png"];
    UIImage *tabBarSecondButtonImage = [UIImage imageNamed:@"MAServices.png"];
    UIImage *tabBarThirdButtonImagePress = [UIImage imageNamed:@"MAProductPressed.png"];
    UIImage *tabBarThirdButtonImage = [UIImage imageNamed:@"MAProduct.png"];
    UIImage *tabBarFourthButtonImagePress = [UIImage imageNamed:@"MAAppointmentPressed.png"];
    UIImage *tabBarFourthButtonImage = [UIImage imageNamed:@"MAAppointment.png"];
    UIImage *tabBarFifthButtonImagePress = [UIImage imageNamed:@"MAContactUsPressed.png"];
    UIImage *tabBarFifthButtonImage = [UIImage imageNamed:@"MAContactUs.png"];
    
    UIButton *tabBarFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tabBarFirstButton setImage:tabBarFirstButtonImagePress  forState:UIControlStateSelected];
    [tabBarFirstButton setImage:tabBarFirstButtonImage forState:UIControlStateNormal];
    firstTabNavigationController.tabBarItem = [PCTabBarItem tabBarItemWithButton:tabBarFirstButton];
    
    UIButton *tabBarSecondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tabBarSecondButton setImage:tabBarSecondButtonImagePress  forState:UIControlStateSelected];
    [tabBarSecondButton setImage:tabBarSecondButtonImage forState:UIControlStateNormal];
    secondTabNavigationController.tabBarItem = [PCTabBarItem tabBarItemWithButton:tabBarSecondButton];
    
    UIButton *tabBarThirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tabBarThirdButton setImage:tabBarThirdButtonImagePress  forState:UIControlStateSelected];
    [tabBarThirdButton setImage:tabBarThirdButtonImage forState:UIControlStateNormal];
    thirdTabNavigationController.tabBarItem = [PCTabBarItem tabBarItemWithButton:tabBarThirdButton];
    
    UIButton *tabBarFourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tabBarFourthButton setImage:tabBarFourthButtonImagePress  forState:UIControlStateSelected];
    [tabBarFourthButton setImage:tabBarFourthButtonImage forState:UIControlStateNormal];
    fourthTabNavigationController.tabBarItem = [PCTabBarItem tabBarItemWithButton:tabBarFourthButton];
    
    UIButton *tabBarFifthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tabBarFifthButton setImage:tabBarFifthButtonImagePress forState:UIControlStateSelected];
    [tabBarFifthButton setImage:tabBarFifthButtonImage forState:UIControlStateNormal];
    fifthTabNavigationController.tabBarItem = [PCTabBarItem tabBarItemWithButton:tabBarFifthButton];
    
    NSString *imageSplash = nil;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        //Iphone 4 (Retina 3.5 inch below)
        if(result.height == 480) {
            imageSplash = @"Default.png";
            tabBarController.tabBarBackgroundImageView.frame = CGRectMake(0,435,320,49);
            tabBarFirstButton.frame = CGRectMake(0, 434, 64, 49);
            tabBarSecondButton.frame = CGRectMake(64, 434, 64, 49);
            tabBarThirdButton.frame = CGRectMake(128, 434, 64, 49);
            tabBarFourthButton.frame = CGRectMake(192, 434, 64, 49);
            tabBarFifthButton.frame = CGRectMake(256, 434, 64, 49);
            
        } else if(result.height == 568) {
            //Iphone 5 (Retina 4inch)
            imageSplash = @"Default-568h.png";
            tabBarController.tabBarBackgroundImageView.frame = CGRectMake(0,520,320,48);
            tabBarFirstButton.frame = CGRectMake(0, 523, 64, 47.5);
            tabBarSecondButton.frame = CGRectMake(64, 523, 64, 47.5);
            tabBarThirdButton.frame = CGRectMake(128, 523, 64, 47.5);
            tabBarFourthButton.frame = CGRectMake(192, 523, 64, 47.5);
            tabBarFifthButton.frame = CGRectMake(256, 523, 64, 47.5);
        }
        
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageSplash = @"Default-Portrait~ipad.png";
        tabBarController.tabBarBackgroundImageView.frame = CGRectMake(0,923.0f,768,101.0f);
        tabBarFirstButton.frame = CGRectMake(0, 923.0f, 153.6f, 101.0f);
        tabBarSecondButton.frame = CGRectMake(153.6f, 923.0f, 153.6f, 101.0f);
        tabBarThirdButton.frame = CGRectMake(307.2f, 923.0f, 153.6f, 101.0f);
        tabBarFourthButton.frame = CGRectMake(460.8f, 923.0f, 153.6f, 101.0f);
        tabBarFifthButton.frame = CGRectMake(614.4f, 923.0f, 153.6f, 101.0f);
    }
    tabBarController.viewControllers = [NSArray arrayWithObjects:firstTabNavigationController,secondTabNavigationController,thirdTabNavigationController,fourthTabNavigationController,fifthTabNavigationController,nil];
    tabBarController.selectedIndex = 0;
    tabBarController.delegate = self;
    
    self.window.rootViewController = tabBarController ;
    [[PCRequestHandler sharedInstance] requestVersionCheck:@"17"];
    UIImageView *splashImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageSplash]];
	splashImageView.userInteractionEnabled = FALSE;
	[tabBarController.view addSubview:splashImageView];
    [self performSelector:@selector(removeSplashImageView:) withObject:splashImageView afterDelay:2];
    
    [self.window makeKeyAndVisible];
    /*
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	application.applicationIconBadgeNumber = 0;
    if (localNotification)
	{
		[[PCLocalNotification sharedInstance] handleReceivedNotification:localNotification];
    }
    
    [Crashlytics startWithAPIKey:@"847841a1648ac86b19e6efd3effd9da6a70ebff5"];
    */
    return YES;
}

- (void)removeSplashImageView:(UIImageView *)splashImageView
{
    [splashImageView removeFromSuperview];
    [splashImageView release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
