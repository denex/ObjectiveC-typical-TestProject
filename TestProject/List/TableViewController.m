//
//  TableViewController.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "TableViewController.h"
#import "SectionHeaderView.h"
#import "EmployeeViewController.h"
#import "EmployeeEditViewController.h"

static NSString *kTableViewControllerSectionHeaderViewXib = @"SectionHeaderView";
static NSString *kTableViewControllerCellIdentifier = @"TableViewControllerCell";

@implementation TableViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"List", @"List");
        self.tabBarItem.image = [UIImage imageNamed:@"list"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self action:@selector(addToTable)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];

    // Table Section Headers
    UINib *sectionHeaderNib = [UINib nibWithNibName:kTableViewControllerSectionHeaderViewXib bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:kTableViewControllerSectionHeaderViewXib];

    // Sign up for model modification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelHasChanged) name:[DataSource modelChangedNotificationName] object:nil];
}

- (void) addToTable
{
    [EmployeeEditViewController addNewEmployee:self];
}

- (void)modelHasChanged
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[DataSource instance] sectionCount];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Without whis stange things in iOS 7 happens
    return 32;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {

    SectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewControllerSectionHeaderViewXib];
    sectionHeaderView.backgroundView = nil;
    sectionHeaderView.label.text = [DataSource sectionName:section];
    switch (section) {
        case EmployeeKindExecutive:
            sectionHeaderView.image.image = [UIImage imageNamed:@"badge"];
            break;
        case EmployeeKindEmployee:
            sectionHeaderView.image.image = [UIImage imageNamed:@"group"];
            break;
        case EmployeeKindAccountant:
            sectionHeaderView.image.image = [UIImage imageNamed:@"calculator"];
            break;
        default:
            break;
    }
    return sectionHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataSource instance] itemsInSection: section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeBase *item = [[DataSource instance] employeeAtIndexPath:indexPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewControllerCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewControllerCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = item.fullname;
    cell.detailTextLabel.text = item.detail;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DataSource instance] deleteEmployeeAtPath: indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[DataSource instance] moveEmployeeAtIndexPath: fromIndexPath toIndexPath: toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EmployeeViewController *detailViewController = [[EmployeeViewController alloc] init];
    detailViewController.employeePath = indexPath;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView release];
    [super dealloc];
}
@end
