//
//  DataSource.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "DataSource.h"
#import "Model.h"

@interface DataSource ()
@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) NSArray *data;
@end

@implementation DataSource

#pragma mark - Singleton

static id sharedInstance;

+ (void)initialize {
    // subclassing would result in an instance per class, probably not what we want
    NSAssert([DataSource class] == self, @"Subclassing is not welcome");
    sharedInstance = [[super alloc] initUniqueInstance];
}

+ (instancetype)instance {
    return sharedInstance;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    if (self) {
        self.model = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] getPathToArchive]];
        if (!_model) {
            _model = [[Model alloc] initWithDummyData];
        }
        self.data = @[self.model.executives,
                      self.model.employees,
                      self.model.accountants];
    }
    return self;
}

#pragma mark - Static methods

+(NSString *)getPathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"employee.data"];
}

+ (NSString *)employeeGroupTitleForKind:(EmployeeKind)kind
{
    switch (kind) {
        case EmployeeKindAccountant:
            return NSLocalizedString(@"Accountant", @"Accountant");
        case EmployeeKindEmployee:
            return NSLocalizedString(@"Employee", @"Employee");
        case EmployeeKindExecutive:
            return NSLocalizedString(@"Executive", @"Executive");
        default:
            break;
    }
}

+ (NSString *)sectionName:(EmployeeKind) sectionId
{
    switch (sectionId) {
        case EmployeeKindAccountant:
            return NSLocalizedString(@"Accountants", @"Accountants");
        case EmployeeKindEmployee:
            return NSLocalizedString(@"Employees", @"Employees");
        case EmployeeKindExecutive:
            return NSLocalizedString(@"Executives", @"Executives");
    }
}

+ (NSString *)modelChangedNotificationName
{
    return @"DataSource_ModelHasChanged";
}

+ (EmployeeKind)whatKindOfEmployee:(EmployeeBase *)employee
{
    return [Model getKindOfEmployee:employee];
}

+ (NSInteger)getIndexInArray:(NSMutableArray *)array forNewEmployeeName:(NSString *)employeeName
{
    if (array.count == 0) return 0;
    NSComparisonResult compResult = NSOrderedSame;

    NSInteger index = 0;
    while (compResult != NSOrderedAscending && index < array.count) {
        EmployeeBase *first = array[index];
        compResult = [employeeName compare:first.fullname];
        if (compResult == NSOrderedAscending) break;
        index+=1;
    }
    return index;
}

+ (NSInteger)alphabeticallyInsertEmployee:(EmployeeBase *)employee toArray:(NSMutableArray *)array
{
    NSInteger index = [self getIndexInArray:array forNewEmployeeName:employee.fullname];
    [array insertObject:employee atIndex:index];
    return index;
}

#pragma mark - Instance methods

- (void)saveModel
{
    NSString *filename = [[self class] getPathToArchive];
    [NSKeyedArchiver archiveRootObject:self.model toFile:filename];
    NSLog(@"Model saved to: %@", filename);
}

- (NSInteger)itemsInSection:(NSInteger) section
{
    return [self.data[section] count];
}

- (EmployeeBase *)employeeAtIndexPath:(NSIndexPath *) aPath
{
    return self.data[aPath.section][aPath.row];
}

- (NSInteger)sectionCount
{
    return [self.data count];
}

- (NSIndexPath *)addNewEmployee:(EmployeeBase *)newEmployee
{
    EmployeeKind kind = [[self class] whatKindOfEmployee:newEmployee];
    NSIndexPath *result = [NSIndexPath indexPathForItem:[[self class] alphabeticallyInsertEmployee:newEmployee toArray:self.data[kind]] inSection:kind];

    [self saveModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] modelChangedNotificationName] object:self];
    return result;
}

- (NSIndexPath *)replaceExistingEmployeeAtIndexPath:(NSIndexPath *)oldIndexPath withNew:newEmployee
{
    NSIndexPath *result = oldIndexPath;
    EmployeeKind kind = [[self class] whatKindOfEmployee:newEmployee];
    if (kind == oldIndexPath.section) {
        // In same section
        self.data[oldIndexPath.section][oldIndexPath.row] = newEmployee;
    } else {
        // Moved from another section
        // Remove from old path
        [self deleteEmployeeAtPath:oldIndexPath];
        // And add like new
        result = [self addNewEmployee:newEmployee];
    }

    [self saveModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] modelChangedNotificationName] object:self];
    return result;
}

- (void)deleteEmployeeAtPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = self.data[indexPath.section];
    [arr removeObjectAtIndex:indexPath.row];
    [self saveModel];
}

- (void)moveEmployeeAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSAssert(fromIndexPath.section == toIndexPath.section, @"Can not move outside own section!");
    NSMutableArray *arr = self.data[fromIndexPath.section];
    id object = [[arr objectAtIndex:fromIndexPath.row] retain];
    [arr removeObjectAtIndex:fromIndexPath.row];
    [arr insertObject:object atIndex:toIndexPath.row];
    [object release];
    [self saveModel];
}

#pragma mark - dealloc
- (void)dealloc
{
    [_data release];
    [_model release];
    [super dealloc];
}

@end
