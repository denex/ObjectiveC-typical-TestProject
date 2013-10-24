//
//  EmployeeViewController.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "EmployeeViewController.h"
#import "EmployeeEditViewController.h"
#import "DataSource.h"
#import "Accountant.h"

@implementation EmployeeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Employee", @"Employee");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editEmployee)];
    self.navigationItem.rightBarButtonItem = editButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(employeeHasChanged:) name:[EmployeeEditViewController indexPathChangedOnSaveNotificationName] object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    EmployeeBase *employee = [[DataSource instance] employeeAtIndexPath:self.employeePath];
    self.labelFullName.text = employee.fullname;
    self.labelSalary.text = employee.salary;

    SEL workplaceMethod = @selector(workplace);
    if ([employee respondsToSelector:workplaceMethod]) {
        self.labelWorkplace.text = [employee performSelector:workplaceMethod];
        self.labelWorkplace.hidden = NO;
    } else {
        self.labelWorkplace.hidden = YES;
    }
    self.LabelWork.hidden = self.labelWorkplace.hidden;

    SEL lunchMethod = @selector(lunchTime);
    if ([employee respondsToSelector:lunchMethod]) {
        self.labelLunchTime.text = [employee performSelector:lunchMethod];
        self.labelLunchTime.hidden = NO;
    } else {
        self.labelLunchTime.hidden = YES;
    }
    self.labelLunch.hidden = self.labelLunchTime.hidden;

    SEL specialMethod = @selector(specialization);
    if ([employee respondsToSelector:specialMethod]) {
        AccountantKind kind = (NSInteger)[employee performSelector:specialMethod];
        self.labelSpecialization.text = [Accountant specializationStringOfKind:kind] ;
        self.labelSpecialization.hidden = NO;
    } else {
        self.labelSpecialization.hidden = YES;
    }
    self.labelSpec.hidden = self.labelSpecialization.hidden;

    SEL officeMethod = @selector(officeHours);
    if ([employee respondsToSelector:officeMethod]) {
        self.labelOfficeHours.text = [employee performSelector:officeMethod];
        self.labelOfficeHours.hidden = NO;
    } else {
        self.labelOfficeHours.hidden = YES;
    }
    self.labelOffice.hidden = self.labelOfficeHours.hidden;
}

- (void)employeeHasChanged:(NSNotification *)notification
{
    NSIndexPath *newPath = [notification userInfo][@0];
    self.employeePath = newPath;
}

- (void) editEmployee
{
    [EmployeeEditViewController editEmployeeFrom:self atIndexPath:self.employeePath];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_labelFullName release];
    [_labelSalary release];
    [_labelWorkplace release];
    [_labelLunchTime release];
    [_labelSpecialization release];
    [_labelOfficeHours release];
    [_labelOffice release];
    [_labelSpec release];
    [_labelLunch release];
    [_LabelWork release];
    [super dealloc];
}
@end
