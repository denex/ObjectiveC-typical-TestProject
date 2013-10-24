//
//  EmployeeViewController.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeBase.h"

@interface EmployeeViewController : UIViewController

@property (nonatomic, retain) NSIndexPath *employeePath;

@property (retain, nonatomic) IBOutlet UILabel *labelFullName;
@property (retain, nonatomic) IBOutlet UILabel *labelSalary;
@property (retain, nonatomic) IBOutlet UILabel *labelWorkplace;
@property (retain, nonatomic) IBOutlet UILabel *labelLunchTime;
@property (retain, nonatomic) IBOutlet UILabel *labelSpecialization;
@property (retain, nonatomic) IBOutlet UILabel *labelOfficeHours;

@property (retain, nonatomic) IBOutlet UILabel *labelOffice;
@property (retain, nonatomic) IBOutlet UILabel *labelSpec;
@property (retain, nonatomic) IBOutlet UILabel *labelLunch;
@property (retain, nonatomic) IBOutlet UILabel *LabelWork;

@end
