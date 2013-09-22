//
//  PCModelFormViewController.m
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCModelFormViewController.h"
#import <MessageUI/MessageUI.h>
#import "PCTexTFieldCell.h"
#import "PCTextAreaCell.h"
#import "PCListCell.h"

typedef enum
{
    LSListPicker,
    LSDatePicker,
    LSTimePicker
}
FormPickerType;

@interface PCModelFormViewController ()<MFMailComposeViewControllerDelegate,PCTextFieldCellDelegate,PCTextAreaCellDelegate, UIScrollViewDelegate>
{
    int selectedIndex;
}
@property (nonatomic) FormPickerType pickerType;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *formId;
@property (nonatomic, retain) NSDictionary *dataFromServer;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *itemContent;
@property (nonatomic) NSInteger textFieldRange;
@property (nonatomic,retain) NSString *placeHolder;
@property (nonatomic, retain) NSMutableArray *clientInformationList;
@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic,retain) NSArray *itemList;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSMutableArray *keyList;
@property (nonatomic, retain) NSObject *objectWithResponder;

- (void)showPickerActionSheet:(NSString *)title andObjectView:(UIView *)views;

@end

static PCModelFormViewController *_instance;

@implementation PCModelFormViewController

+(PCModelFormViewController *)orderViewController
{
    return _instance;
}

- (id)initWithTittle:(NSString *)tittle andFormId: (NSString *)formId andCompanyId:(NSString *)companyId andClickId:(NSUInteger)clickedId
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelFormViewController");
    
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    //self = [super initWithNibName:nib bundle:nil];
    if (self) {
        
        _instance = self;
        
        self.clientInformationList  = [[[NSMutableArray alloc] init] autorelease];
        self.keyList                = [[[NSMutableArray alloc] init] autorelease];
        self.pickerData             = [[[NSArray alloc] init] autorelease];
        self.formId                 = [formId retain];
        self.companyId              = [companyId retain];
        
        [[PCRequestHandler sharedInstance] requestFormWithCompanyId:_companyId andFormId:_formId];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(dataFromServer:)
                                                    name:[NSString stringWithFormat:DATA_KEY,@"form",_formId]
                                                  object:nil];
        
        NSString *doneImageNormalName = nil;
        NSString *backImageName       = nil;
        
        if([_companyId isEqualToString:@"10"]) {
            doneImageNormalName = @"ipad_Done-btn-s";
            
        } else if ([_companyId isEqualToString:@"8"]) {
            doneImageNormalName = @"LSDoneButton.png";
            
        } else if ([_companyId isEqualToString:@"14"]) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                doneImageNormalName = @"iphone_Send-btn-s.png";
            } else {
                doneImageNormalName = @"ipad_Send-btn-s.png";
            }
        }else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                doneImageNormalName = @"PICClinicModel.bundle/iphone_Done-btn-s";
            } else {
                doneImageNormalName = @"PICClinicModel.bundle/ipad_Done-btn-s";
            }
        }
        
        UIView *customViewDone = [[[UIView alloc] init] autorelease];
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            btnDone.frame = CGRectMake(0, 0, 53, 33.5);
            customViewDone.frame = btnDone.frame;
            //btnDone.backgroundColor = [UIColor redColor];
            
        } else {
            btnDone.frame = CGRectMake(0.0f, 20.0f, 129.0f, 80.0f);
            customViewDone.frame = CGRectMake(0.0f, 0.0f, 129.0f, 80.0f);
        }
        
        UIImage *doneImageNormal = [UIImage imageNamed:doneImageNormalName];
        [btnDone setBackgroundImage:doneImageNormal forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(activateMail) forControlEvents:UIControlEventTouchUpInside];
        
        [customViewDone addSubview:btnDone];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:customViewDone];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        if(clickedId == 1) {
            UIView *customView = [[[UIView alloc] init] autorelease];
            UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
            backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if ([_companyId isEqualToString:@"8"]) {
                    backImageName = @"LSBackButton.png";
                }
                btnback.frame = CGRectMake(0, 0, 53, 33.5);
                customView.frame = btnback.frame;
                //btnback.backgroundColor = [UIColor redColor];
                
            } else { //IPAD
                
                if ([_companyId isEqualToString:@"8"]) {
                    backImageName = @"LSBackButton.png";
                    btnback.frame = CGRectMake(0.0f, 19.0f, 129.0f, 80.0f);
                    customView.frame = CGRectMake(0.0f, 0.0f, 129.0f, 80.0f);
                } else {
                    
                    btnback.frame = CGRectMake(0, 18, 97, 64);
                    customView.frame = CGRectMake(0, 0, 97, 64);
                }
            }
            
            UIImage *BackImage = [UIImage imageNamed:backImageName];
            [btnback setBackgroundImage:BackImage forState:UIControlStateNormal];
            [btnback addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            
            [customView addSubview:btnback];
            UIBarButtonItem *bckButton = [[UIBarButtonItem alloc]initWithCustomView:customView];
            self.navigationItem.leftBarButtonItem = bckButton;
        }
        
        self.navigationItem.title = tittle;
    }
    
    return self;
    
}

- (id)initWithFormId:(NSString *)formId andCompanyId:(NSString *)companyId andClickId:(NSUInteger)clickedId
{
    NSString *nibNameOrNil = PCNameForDevice(@"PCModelFormViewController");
    
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]]];
    //self = [super initWithNibName:nib bundle:nil];
    if (self) {
        _instance = self;
        
        self.clientInformationList = [[[NSMutableArray alloc] init] autorelease];
        self.keyList = [[[NSMutableArray alloc] init] autorelease];
        self.pickerData = [[[NSArray alloc] init] autorelease];
        self.formId = [formId retain];
        self.companyId = [companyId retain];
        
        [[PCRequestHandler sharedInstance] requestFormWithCompanyId:_companyId andFormId:_formId];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(dataFromServer:)
                                                    name:[NSString stringWithFormat:DATA_KEY,@"form",_formId]
                                                  object:nil];
        if(clickedId == 1) {
            NSString *backImageName = nil;
            UIView *customView = [[[UIView alloc] init] autorelease];
            UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
            backImageName = @"PICClinicModel.bundle/Back_btn-s.png";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                
                btnback.frame = CGRectMake(0, 0, 53, 33.5);
                customView.frame = btnback.frame;
                
            } else { //IPAD
                
                btnback.frame = CGRectMake(0, 18, 97, 64);
                customView.frame = CGRectMake(0, 0, 97, 94);
            }
            
            UIImage *BackImage = [UIImage imageNamed:backImageName];
            [btnback setBackgroundImage:BackImage forState:UIControlStateNormal];
            [btnback addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            
            [customView addSubview:btnback];
            UIBarButtonItem *bckButton = [[UIBarButtonItem alloc]initWithCustomView:customView];
            self.navigationItem.leftBarButtonItem = bckButton;
        }
        
        NSString *doneImageNormalName = nil;
        if([_companyId isEqualToString:@"10"]) {
            doneImageNormalName = @"Done_btn-s";
        } else {
            doneImageNormalName = @"PICClinicModel.bundle/Done_btn-s.png";
        }
        
        UIView *customViewDone = [[[UIView alloc] init] autorelease];
        //customViewDone.backgroundColor = [UIColor redColor];
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if ([_companyId isEqualToString:@"15"]) {
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                
                btnDone.frame = CGRectMake(0.0f, 0.0f, 65.0f, 33.5f);
                customViewDone.frame = btnDone.frame;
                
            } else { //IPAD
                
                btnDone.frame = CGRectMake(0.0f, 18.0f, 129.0f, 64.0f);
                customViewDone.frame = CGRectMake(0.0f, 0.0f, 129.0f, 64.0f);
            }
            
        } else {
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                btnDone.frame = CGRectMake(0, 0, 53, 33.5);
                customViewDone.frame = btnDone.frame;
                
            } else { //IPAD
                
                btnDone.frame = CGRectMake(0, 30, 97, 64);
                customViewDone.frame = CGRectMake(0, 0, 97, 94);
            }
            
        }
        UIImage *doneImageNormal = [UIImage imageNamed:doneImageNormalName];
        [btnDone setBackgroundImage:doneImageNormal forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(activateMail) forControlEvents:UIControlEventTouchUpInside];
        
        [customViewDone addSubview:btnDone];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithCustomView:customViewDone];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        if([companyId isEqualToString:@"10"]) {
            self.navigationItem.title = @"Appointment";
        } else  if([companyId isEqualToString:@"15"]) {
            self.navigationItem.title = @"Booking";
        }
    }
    
    return self;
    
}

- (void)dealloc
{
    [_tableView release];
    [_objectWithResponder release];
    [_itemList release];
    [_pickerList release];
    [_datePicker release];
    [_companyId release];
    [_formId release];
    [_dataFromServer release];
    [_picker release];
    [_itemContent release];
    [_clientInformationList release];
    [_pickerData release];
    
    [_valueKey release];
    [_value release];
    [_keyList release];
    
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_companyId isEqualToString:@"8"] || [_companyId isEqualToString:@"15"]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.tableView.bounces = FALSE;
        }
    }
    // Do any additional setup after loading the view from its nib.
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
    [self dismissModalViewControllerAnimated:YES];
}

- (void)activateMail
{
    NSMutableString *emailMessage = [NSMutableString string];
    NSString *emailSubject = [_dataFromServer valueForKey:@"email_subject"];
    NSString *emailTo = [_dataFromServer valueForKey:@"email_to"];
    
    if (self.clientInformationList.count) {
        
        for (NSString *str in self.keyList) {
            for (NSDictionary *dict in self.clientInformationList) {
                
                if([dict objectForKey:str]) {
                    NSString *emailContentTitle = nil;
                    for(NSDictionary *itemDict in self.itemList) {
                        NSNumber *itemId = [itemDict objectForKey:@"item_id"];
                        if([str integerValue] ==[itemId integerValue]) {
                            emailContentTitle = [itemDict objectForKey:@"item_name"];
                        }
                    }
                    [emailMessage appendString:[NSString stringWithFormat:@"%@: %@\n",emailContentTitle,[dict objectForKey:str]]];
                    
                }
            }
        }
        
        
    } else {
        //[emailMessage appendFormat:@"%@:\n%@:\n %@",self.name.text,self.mobileNumber.text,[_dataFromServer valueForKey:@"email_message"]];
        //emailMessage = [_dataFromServer valueForKey:@"email_message"];
    }
    emailSubject = [emailSubject stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    if([_companyId isEqualToString:@"10"]) {
        emailTo = @"info@aestheticmedical.com.sg";
    } else {
        [emailTo stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    }
    
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
    
    [self.clientInformationList removeAllObjects];
    [_tableView reloadData];
    
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
            alert.message = @"Message Not Sent";
            break;
    }
    [alert release];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)dataFromServer:(NSNotification *)notify
{
    self.dataFromServer = [[notify userInfo] valueForKey:@"form"];
    if(!_itemList)
        _itemList = [[NSArray alloc] init];
    
    self.itemList = [[self dataFromServer] valueForKey:@"items"];
    [_tableView reloadData];
    
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableCell:(UITableView *)tableView andType:(int) type andProperty:(NSDictionary *)property andIndexPath:(NSIndexPath *)indexPath
{
    NSString *hint =[property valueForKey:@"hint"];
    NSInteger keyType = [[property valueForKey:@"keyboard"] integerValue];
    NSInteger range = [[property valueForKey:@"length"] integerValue];
    UIColor *textColor = [UIColor darkGrayColor];
    
    if([_companyId isEqualToString:@"14"]) {
        textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    }
    
    switch (type) {
        case 0: {
            PCTexTFieldCell *tbCell = (PCTexTFieldCell *) [tableView dequeueReusableCellWithIdentifier:@"PCTexTFieldCell"];
            if (tbCell == nil) {
                tbCell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"PCTextFieldCell" owner:self options:nil]objectAtIndex:0];
                // tbCell = [[[NSBundle mainBundle] loadNibNamed:@"PCTextFieldCell" owner:self options:nil]objectAtIndex:0];
            }
            tbCell.delegate = self;
            tbCell.index = indexPath.section;
            tbCell.viewParam = self.view;
            tbCell.textField.textColor = textColor;
            if(![[self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint] isEqualToString:hint]) {
                tbCell.textField.text = [self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint];
            }
            
            tbCell.textField.placeholder = hint;
            tbCell.textFieldRange = range;
            
            if(keyType == 0)
                tbCell.textField.keyboardType = UIKeyboardTypeDefault;
            else {
                tbCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [tbCell.buttonDone setHidden:NO];
            }
            
            
            return  tbCell;
        }
        case 1: {
            PCTextAreaCell *tbCell = (PCTextAreaCell *) [tableView dequeueReusableCellWithIdentifier:@"PCTextAreaCell"];
            if (tbCell == nil) {
                tbCell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"PCTextAreaCell" owner:self options:nil]objectAtIndex:0];
                // tbCell = [[[NSBundle mainBundle] loadNibNamed:@"PCTextAreaCell" owner:self options:nil]objectAtIndex:0];
                
            }
            tbCell.delegate = self;
            
            if(![[self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint] isEqualToString:hint]) {
                tbCell.textView.text = [self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint];
                tbCell.textView.textColor = textColor;
            }
            else {
                tbCell.textView.text = hint;
                tbCell.textView.textColor = [UIColor darkGrayColor];
            }
            
            tbCell.textFieldRange = range;
            tbCell.index = indexPath.section;
            tbCell.viewParam = self.view;
            tbCell.placeHolder = @"";//[self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint];
            
            return  tbCell;
        }
        case 2: {
            PCListCell *tbCell = (PCListCell *) [tableView dequeueReusableCellWithIdentifier:@"PCListCell"];
            if(tbCell == nil) {
                tbCell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"PCListCell" owner:self options:nil]objectAtIndex:0];
                // tbCell = [[[NSBundle mainBundle] loadNibNamed:@"PCListCell" owner:self options:nil] objectAtIndex:0];
            }
            self.labelPickerTitle.text = @"Date Selector";
            tbCell.index = indexPath.section;
            tbCell.textLabel.textColor = textColor;
            tbCell.textLabel.font = [UIFont systemFontOfSize:16];
            tbCell.textLabel.text = [self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint];
            return tbCell;
        }
        case 3: {
            PCListCell *tbCell = (PCListCell *) [tableView dequeueReusableCellWithIdentifier:@"PCListCell"];
            if(tbCell == nil) {
                tbCell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"PCListCell" owner:self options:nil]objectAtIndex:0];
                //tbCell = [[[NSBundle mainBundle] loadNibNamed:@"PCListCell" owner:self options:nil] objectAtIndex:0];
            }
            tbCell.textLabel.font = [UIFont systemFontOfSize:16];
            tbCell.textLabel.textColor = textColor;
            tbCell.textLabel.text = [self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint];
            tbCell.index = indexPath.section;
            self.labelPickerTitle.text = @"Time Selector";
            return tbCell;
        }
        case 4: {
            
            PCListCell *tbCell = (PCListCell *) [tableView dequeueReusableCellWithIdentifier:@"PCListCell"];
            if(tbCell == nil) {
                tbCell = [[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PICClinicModel" ofType:@"bundle"]] loadNibNamed:@"PCListCell" owner:self options:nil]objectAtIndex:0];
            }
            tbCell.textLabel.font = [UIFont systemFontOfSize:16];
            tbCell.textLabel.textColor = textColor;
            tbCell.textLabel.text = [self getClientInfoWithValurkey:indexPath.section andPlaceHolder:hint];
            tbCell.index = indexPath.section;
            self.labelPickerTitle.text = @"Options";
            return tbCell;
        }
    }
    return nil;
}

- (void) addClientInfo
{
    [self addInKeyList];
    
    if(_clientInformationList == nil) {
        _clientInformationList = [NSMutableArray array];
    }
    
    
    if(_clientInformationList.count) {
        
        NSMutableArray *handler = [NSMutableArray array];
        for (NSDictionary *dict in _clientInformationList) {
            if([dict valueForKey:_valueKey]) {
                [handler addObject:dict];
            }
        }
        
        if(handler.count)
            [ _clientInformationList removeObjectsInArray:handler];
    }
    
    NSDictionary *dict  = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.value,self.valueKey,
                           nil];
    
    [self.clientInformationList addObject:dict];
    
    
}

- (NSString *) getClientInfoWithValurkey: (NSInteger) valueKey andPlaceHolder:(NSString *)placeHolder
{
    NSString *key = [[[_itemList objectAtIndex:valueKey] valueForKey:@"item_id"] stringValue];
    
    if(_clientInformationList == nil) {
        _clientInformationList = [NSMutableArray array];
    }
    
    if(_clientInformationList.count) {
        
        
        for (NSDictionary *dict in _clientInformationList) {
            if([dict valueForKey:key]) {
                //SLog(@"PreviousData= %@",[[dict valueForKey:_valueKey] stringValue]);
                return [dict valueForKey:key];
            }
        }
    }
    
    return  placeHolder;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resignResponder];
}

- (void) addInKeyList
{
    NSString *strObject = _valueKey;
    
    BOOL keyExist = NO;
    
    if(_clientInformationList == nil)
        _keyList = [NSMutableArray array];
    
    if(_keyList.count)
    {
        for (NSString *str in _keyList) {
            if([str isEqualToString:strObject])
                keyExist = YES;
        }
    }
    
    if(!keyExist){
        [self.keyList addObject:strObject];
        
    }
    
}

#pragma mark PCTextFieldCellDelegate
- (void)textFieldFinishedTyping
{
    
    [self addClientInfo];
}

- (void)textFieldWillStartTyping:(NSUInteger)cellIndex andTextfield:(UITextField *)textField
{
    self.objectWithResponder = textField;
    self.valueKey = [[[_itemList objectAtIndex:cellIndex] valueForKey:@"item_id"] stringValue];
    
    UIColor *tittleColor = textField.textColor;
    if([_companyId isEqualToString:@"14"]) {
        tittleColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
        textField.textColor = tittleColor;
    }
}

#pragma mark PCTextAreaCellDelegate

- (void) textViewFinishedTyping
{
    [self addClientInfo];
}

- (void) textViewwillStartTyping:(NSUInteger)cellIndex andTextfield:(UITextView *)textView
{
    self.objectWithResponder = textView;
    self.valueKey = [[[_itemList objectAtIndex:cellIndex] valueForKey:@"item_id"] stringValue];
    
    UIColor *tittleColor = textView.textColor;
    if([_companyId isEqualToString:@"14"]) {
        tittleColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
        textView.textColor = tittleColor;
    }
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.itemContent objectAtIndex:row];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [_itemList objectAtIndex:indexPath.section];
    NSDictionary *propertyData = [[_itemList objectAtIndex:indexPath.section] valueForKey:@"property"];
    
    NSInteger type = [[data valueForKey:@"item_type"] integerValue];
    return [self tableCell:tableView andType:type andProperty:propertyData andIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_itemList objectAtIndex:section] valueForKey:@"item_name"] ;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIColor *tittleColor = [UIColor darkGrayColor];
    if([_companyId isEqualToString:@"14"]) {
        tittleColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    }
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150.0, 30.0)];
    headerView.backgroundColor = [UIColor clearColor];
    
    CGRect headerTetcRect = CGRectMake(10.0, 0.0, 150, 25.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        headerTetcRect = CGRectMake(50.0, 0.0, 150, 25.0);
    }
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerTetcRect];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.text = [[_itemList objectAtIndex:section] valueForKey:@"item_name"];
    headerLabel.textColor = tittleColor;
    headerLabel.highlightedTextColor = tittleColor;
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.shadowColor = [UIColor clearColor];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.numberOfLines = 0;
    headerLabel.textAlignment = UITextAlignmentLeft;
    [headerView addSubview: headerLabel];
    
    [headerLabel release];
    
    return headerView;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [_itemList objectAtIndex:indexPath.section];
    NSInteger type = [[data valueForKey:@"item_type"] integerValue];;
    
    switch (type) {
        case 0: return  44.0f;
        case 1: return  201.0f;
        case 2: return  44.0f;
        case 3: return  44.0f;
        case 4: return  44.0f;
    }
    return 44.0f;; //<-depends on what is the return
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignResponder];
    selectedIndex = indexPath.section;
    NSDictionary *data = [_itemList objectAtIndex:indexPath.section];
    NSInteger type = [[data valueForKey:@"item_type"] integerValue];
    switch (type) {
        case 0: {
            //show previous data if it exist
            
            break;
        }
        case 1:
            //show previous data if it exist
            break;
        case 2: {
            
            self.pickerType = LSDatePicker;
            PCListCell *cell = (PCListCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex]];
            [self showPickerActionSheet:@"Date Selector" andObjectView:cell];
            ///show picker for date
            break;
        }
        case 3: {
            self.pickerType = LSTimePicker;
            PCListCell *cell = (PCListCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex]];
            [self showPickerActionSheet:@"Time Selector" andObjectView:cell];
            ///show picker for time
            break;
        }
        case 4: {
            
            self.pickerType = LSListPicker;
            PCListCell *cell = (PCListCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex]];
            [self showPickerActionSheet:@"Products" andObjectView:cell];
            NSDictionary *dict = [_itemList objectAtIndex:indexPath.section];
            NSDictionary *property = [dict valueForKey:@"property"];
            NSString *options = [property valueForKey:@"options"];
            if(options) {
                
                self.pickerList.showsSelectionIndicator = YES;
                self.pickerList.delegate = self;
                
                NSString *fullToken = (NSString *)options;
                
                NSArray *components = [fullToken componentsSeparatedByString:@";"];
                
                
                //if(!_pickerData)
                //_pickerData = [[NSMutableArray alloc] init];
                
                self.pickerData = components;
                
                if(!_itemContent)
                    _itemContent = [[NSMutableArray alloc] init];
                
                if(_itemContent.count > 0)
                    [_itemContent removeAllObjects];
                
                
                for (NSString *str in components){
                    
                    [_itemContent addObject:str];
                }
            }
            
            [_pickerList reloadAllComponents];
            break;
            
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark Private
- (void)showPickerActionSheet:(NSString *)title andObjectView:(UIView *)views
{
    
    CGRect btnOkRect;
    CGRect titleLabelRect;
    UIView *view = [[UIView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIViewController *contentViewController = [[[UIViewController alloc] init] autorelease];
        contentViewController.contentSizeForViewInPopover = CGSizeMake(760.0f, 300.0f);
        _popOverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
        self.popOverController.delegate = self;
        view = contentViewController.view;
        
        
        float senderViewY = views.frame.origin.y;
        
        if(senderViewY < 300.0f) {
            
            [_popOverController presentPopoverFromRect:views.bounds inView:views permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        } else {
            [_popOverController presentPopoverFromRect:views.bounds inView:views permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
        
        
        titleLabelRect = CGRectMake(230.0f, -10, 278.0f, 40.0f);
        btnOkRect = CGRectMake(230.0f, 250.0f, 278.0f, 45.0f);
        
        
    } else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] init] autorelease];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        view = actionSheet;
        
        titleLabelRect = CGRectMake(21.0f, -3, 278.0f, 40.0f);
        //titleLabelRect = CGRectMake(21.0f, 0, 278.0f, 45.0f);
        btnOkRect = CGRectMake(21.0f, 250.0f, 278.0f, 45.0f);
        
        [actionSheet showInView:self.view];
        actionSheet.frame = CGRectMake(0.0f, self.view.bounds.size.height - 300.0f, actionSheet.frame.size.width, 300.0f);
        self.actionSheet = actionSheet;
    }
    
    switch (self.pickerType) {
        case LSListPicker: {
            self.picker = [self listPickerForActionSheet];
            [view addSubview:self.picker];
            /*if (self.dayTimeAsleepNumber) {
             self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:[self.dayTimeAsleepNumber doubleValue]];
             }*/
            break;
        }
        case LSDatePicker: {
            self.datePicker = [self datePickerForActionSheet];
            [view addSubview:self.datePicker];
            /* if (self.dayTimeWakeUpNumber) {
             self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:[self.dayTimeWakeUpNumber doubleValue]];
             }*/
            break;
        }
        case LSTimePicker: {
            self.datePicker = [self datePickerForActionSheet];
            [view addSubview:self.datePicker];
            /* if (self.dayTimeWakeUpNumber) {
             self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:[self.dayTimeWakeUpNumber doubleValue]];
             }*/
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
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    okButton.frame = btnOkRect;
    [okButton addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:okButton];
    [view addSubview:titleLabel];
    [view release];
}

- (UIDatePicker *)datePickerForActionSheet
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
        if(self.pickerType == LSDatePicker)
            datePicker.datePickerMode = UIDatePickerModeDate;
        else if (self.pickerType == LSTimePicker)
            datePicker.datePickerMode = UIDatePickerModeTime;
        
        datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
        
        return [datePicker autorelease];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10,25, 700, 220)];
        if(self.pickerType == LSDatePicker)
            datePicker.datePickerMode = UIDatePickerModeDate;
        else if (self.pickerType == LSTimePicker)
            datePicker.datePickerMode = UIDatePickerModeTime;
        
        datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
        
        return [datePicker autorelease];
    }
    
    return nil;
}

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

- (void) resignResponder
{
    if( [self.objectWithResponder isKindOfClass:[UITextField class]] ) {
        UITextField *textField = (UITextField *) self.objectWithResponder;
        [textField resignFirstResponder];
    } else if([self.objectWithResponder isKindOfClass:[UITextView class]] ) {
        UITextView *textView = (UITextView *) self.objectWithResponder;
        [textView resignFirstResponder];
    }
}

- (void)okTapped:(NSObject *)sender
{
    NSObject *object = [[[NSObject alloc] init] autorelease];
    int valueKey;
    
    UIColor *textColor = [UIColor darkGrayColor];
    if([_companyId isEqualToString:@"14"]) {
        textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    }
    
    switch (self.pickerType) {
        case LSDatePicker: {
            
            NSDate *date = _datePicker.date;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMMM-dd-yyyy"];
            NSString *strDate = [dateFormat stringFromDate:date];
            
            PCListCell *cell = (PCListCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex]];
            object = strDate;
            cell.textLabel.text = strDate;
            cell.textLabel.textColor = textColor;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            valueKey = cell.index;
            [cell layoutSubviews];
            [dateFormat release];
            break;
        }
        case LSTimePicker: {
            NSDate *date = _datePicker.date;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.timeZone = _datePicker.timeZone;
            [dateFormat setDateFormat:@"hh:mm: aa"];
            NSString *strTime = [dateFormat stringFromDate:date];
            
            PCListCell *cell = (PCListCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex]];
            object = strTime;
            cell.textLabel.text = strTime;
            cell.textLabel.textColor = textColor;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            valueKey = cell.index;
            [cell layoutSubviews];
            [dateFormat release];
            break;
        }
            
        case LSListPicker: {
            PCListCell *cell = (PCListCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex]];
            object = [_itemContent objectAtIndex:[_picker selectedRowInComponent:0]];
            cell.textLabel.text = [_itemContent objectAtIndex:[_picker selectedRowInComponent:0]];
            cell.textLabel.textColor = textColor;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            valueKey = cell.index;
            [cell layoutSubviews];
            break;
        }
    }
    self.valueKey = [[[_itemList objectAtIndex:valueKey] valueForKey:@"item_id"] stringValue];
    self.value = object;
    [self addClientInfo];
    
    if(_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        _actionSheet = nil;
    }
    
    if(_datePicker)
        self.datePicker = nil;
    if(_picker) {
        self.picker = nil;
    }
    if(_popOverController) {
        [_popOverController dismissPopoverAnimated:YES];
        _popOverController = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

