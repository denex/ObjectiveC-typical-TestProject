//
//  EmployeeEditViewController.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeBase.h"

@interface EmployeeEditViewController : UIViewController

+ (void)addNewEmployee:(UIViewController *)parentVC;
+ (void)editEmployeeFrom:(UIViewController *)parentVC atIndexPath:(NSIndexPath *)path;

+ (NSString *)indexPathChangedOnSaveNotificationName;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UITextField *textFieldFullname;
@property (retain, nonatomic) IBOutlet UITextField *textFieldSalary;
@property (retain, nonatomic) IBOutlet UITextField *textFieldWorkplace;
@property (retain, nonatomic) IBOutlet UITextField *textFieldLunchTime;
@property (retain, nonatomic) IBOutlet UITextField *textFieldOfficeHours;
@property (retain, nonatomic) IBOutlet UILabel *labelWorkplace;
@property (retain, nonatomic) IBOutlet UILabel *labelOfficeHours;
@property (retain, nonatomic) IBOutlet UILabel *labelLunchTime;
@property (retain, nonatomic) IBOutlet UILabel *labelSpecialization;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControlAccountantKind;

- (IBAction)buttonBackTapped:(UIBarButtonItem *)sender;
- (IBAction)buttonSaveTapped:(UIBarButtonItem *)sender;

@end
