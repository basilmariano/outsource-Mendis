//
//  MAContactShareViewController.m
//  PICClinicModel
//
//  Created by Jerry on 8/21/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MAContactShareViewController.h"

@interface MAContactShareViewController ()

@end

@implementation MAContactShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = PCNameForDevice(@"MAContactShareViewController");
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initParentClass: (Class *) class bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = PCNameForDevice(@"MAContactShareViewController");
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
