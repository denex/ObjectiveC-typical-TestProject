//
//  EmployeeEditViewController.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "EmployeeEditViewController.h"
#import "DataSource.h"
#import "Accountant.h"
#import "Executive.h"

@interface EmployeeEditViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) BOOL editingExistingEmployee;
@property (nonatomic, retain) NSIndexPath *existingEmployeeImagePath;
@property (nonatomic, retain) UITextField *selectedTextField;
@property (nonatomic) EmployeeKind selectedEmployeeKind;
@property (nonatomic) CGFloat originCenterY;

@end

@implementation EmployeeEditViewController

const static NSTimeInterval kAnimationDuration = .3;

+ (void)addNewEmployee:(UIViewController *)parentVC
{
    EmployeeEditViewController *addEmployeeVC = [[EmployeeEditViewController alloc] init];
    [parentVC presentViewController:addEmployeeVC animated:YES completion:nil];
    [addEmployeeVC release];
    [addEmployeeVC displayEmployee:[[Executive alloc] init]];
}

+ (void)editEmployeeFrom:(UIViewController *)parentVC atIndexPath:(NSIndexPath *)path;
{
    EmployeeEditViewController *editEmployeeVC = [[EmployeeEditViewController alloc] init];
    [parentVC presentViewController:editEmployeeVC animated:YES completion:nil];
    [editEmployeeVC release];
    editEmployeeVC.existingEmployeeImagePath = path;
    editEmployeeVC.editingExistingEmployee = YES;
    [editEmployeeVC displayEmployee:[[DataSource instance] employeeAtIndexPath:path]];
}

+ (NSString *)indexPathChangedOnSaveNotificationName
{
    return @"indexPathChangedOnSaveNotification";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Edit employee", @"Edit employee");
        self.selectedEmployeeKind = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Set Editor area
    self.textFieldFullname.delegate = self;
    self.textFieldLunchTime.delegate = self;
    self.textFieldOfficeHours.delegate = self;
    self.textFieldSalary.delegate = self;
    self.textFieldWorkplace.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (IBAction)buttonBackTapped:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonSaveTapped:(UIBarButtonItem *)sender
{
    EmployeeBase *emp = [self makeEmployee];
    if (self.editingExistingEmployee) {
        NSIndexPath *newPath = [[DataSource instance] replaceExistingEmployeeAtIndexPath:self.existingEmployeeImagePath withNew:emp];
        if (![newPath isEqual:self.existingEmployeeImagePath]) {
            NSDictionary *userInfo = @{@0:newPath};
            [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] indexPathChangedOnSaveNotificationName] object:self userInfo:userInfo];
        }
    } else {
        [[DataSource instance] addNewEmployee:emp];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayEmployee:(EmployeeBase *)employee
{
    // Init with Employee
    self.textFieldFullname.text = employee.fullname;
    self.textFieldSalary.text = employee.salary;

    SEL workplaceMethod = @selector(workplace);
    if ([employee respondsToSelector:workplaceMethod]) {
        self.textFieldWorkplace.text = [employee performSelector:workplaceMethod];
        self.textFieldWorkplace.hidden = NO;
    } else {
        self.textFieldWorkplace.hidden = YES;
    }
    self.labelWorkplace.hidden = self.textFieldWorkplace.hidden;

    SEL lunchMethod = @selector(lunchTime);
    if ([employee respondsToSelector:lunchMethod]) {
        self.textFieldLunchTime.text = [employee performSelector:lunchMethod];
        self.textFieldLunchTime.hidden = NO;
    } else {
        self.textFieldLunchTime.hidden = YES;
    }
    self.labelLunchTime.hidden = self.textFieldLunchTime.hidden;

    SEL specialMethod = @selector(specialization);
    if ([employee respondsToSelector:specialMethod]) {
        self.segControlAccountantKind.selectedSegmentIndex = (NSInteger)[employee performSelector:specialMethod];
        self.segControlAccountantKind.hidden = NO;
    } else {
        self.segControlAccountantKind.hidden = YES;
    }
    self.labelSpecialization.hidden = self.segControlAccountantKind.hidden;

    SEL officeMethod = @selector(officeHours);
    if ([employee respondsToSelector:officeMethod]) {
        self.textFieldOfficeHours.text = [employee performSelector:officeMethod];
        self.textFieldOfficeHours.hidden = NO;
    } else {
        self.textFieldOfficeHours.hidden = YES;
    }
    self.labelOfficeHours.hidden = self.textFieldOfficeHours.hidden;

    self.selectedEmployeeKind = [DataSource whatKindOfEmployee:employee];
}

- (EmployeeBase *)makeEmployee
{
    EmployeeBase *result;
    switch (self.selectedEmployeeKind) {
        case EmployeeKindExecutive:
            result = [[[Executive alloc] initWithFullname:self.textFieldFullname.text
                                                   salary:self.textFieldSalary.text
                                              officeHours:self.textFieldOfficeHours.text
                       ] autorelease];
            break;
        case EmployeeKindEmployee:
            result = [[[Employee alloc] initWithFullname:self.textFieldFullname.text
                                                  salary:self.textFieldSalary.text
                                               workplace:self.textFieldWorkplace.text
                                               lunchTime:self.textFieldLunchTime.text
                       ] autorelease];
            break;
        case EmployeeKindAccountant:
            result = [[[Accountant alloc] initWithFullname:self.textFieldFullname.text
                                                    salary:self.textFieldSalary.text
                                                 workplace:self.textFieldWorkplace.text
                                                 lunchTime:self.textFieldLunchTime.text
                                            specialization:self.segControlAccountantKind.selectedSegmentIndex
                       ] autorelease];
            break;
        default:
            // Unknown
            result = nil;
            break;
    }
    return result;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedTextField) {
        [self.selectedTextField resignFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedEmployeeKind == indexPath.row) {
        return;
    }
    self.selectedEmployeeKind = indexPath.row;
    for (int i=0; i<[[DataSource instance] sectionCount]; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == self.selectedEmployeeKind) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    EmployeeBase *emp = [self makeEmployee];
    [self displayEmployee: emp];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Kind of employee", @"Kind of employee");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataSource instance] sectionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }

    cell.textLabel.text = [DataSource employeeGroupTitleForKind:indexPath.row];
    if (indexPath.row == self.selectedEmployeeKind) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Keyboard Notifications

- (void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    if (self.selectedTextField) {
        CGRect absRect = [self.selectedTextField convertRect:self.selectedTextField.bounds toView:nil];
        CGFloat keyboardHeght = keyboardFrameBeginRect.size.height;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat diff = CGRectGetMaxY(absRect) - (screenHeight - keyboardHeght) + 8;
        if (diff > 0) {
            self.originCenterY = self.view.superview.center.y;
//            NSLog(@"Offset: %g current center: %g", diff, self.view.superview.center.y);
            [UIView animateWithDuration:kAnimationDuration
                             animations:^{
                                 self.view.superview.center = CGPointMake(self.view.superview.center.x,
                                                                          self.view.superview.center.y - diff);
                             }];
        }
    } else {
        NSLog(@"No TextField selected yet!");
    }
}

- (void)keyboardDidHide:(NSNotification*)notification
{
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.view.superview.center = CGPointMake(self.view.superview.center.x, self.originCenterY);
                     }];
}

#pragma mark - UITextFieldDelegate delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSLog(@"textFieldDidBeginEditing @%@", textField.placeholder);
    self.selectedTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"textFieldDidEndEditing @%@", textField.placeholder);
    self.selectedTextField = nil;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_selectedTextField release];
    [_tableView release];
    [_labelWorkplace release];
    [_labelOfficeHours release];
    [_labelLunchTime release];
    [_textFieldFullname release];
    [_textFieldLunchTime release];
    [_textFieldOfficeHours release];
    [_textFieldSalary release];
    [_textFieldWorkplace release];
    [_segControlAccountantKind release];
    [_labelSpecialization release];
    [super dealloc];
}

@end
