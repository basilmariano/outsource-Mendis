//
//  PCModelFormViewController.h
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCModelFormViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

- (id)initWithFormId:(NSString *)formId andCompanyId:(NSString *)companyId andClickId:(NSUInteger)clickedId;
- (id)initWithTittle:(NSString *)tittle andFormId: (NSString *)formId andCompanyId:(NSString *)companyId andClickId:(NSUInteger)clickedId;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerList;
@property (nonatomic, retain) IBOutlet UILabel *labelPickerTitle;
@property (nonatomic, retain) NSString *valueKey;
@property (nonatomic, retain) NSObject *value;

//-(IBAction)buttonPickerOkClicked:(id)sender;
+(PCModelFormViewController *) orderViewController;
- (void) addClientInfo;
@end