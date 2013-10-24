//
//  DataSource.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeBase.h"

typedef NS_ENUM(NSInteger, EmployeeKind) {
    EmployeeKindExecutive,
    EmployeeKindEmployee,
    EmployeeKindAccountant,
};

@interface DataSource : NSObject

#pragma mark - Singleton
+ (instancetype) instance;
// clue for improper use (produces compile time error)
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));

#pragma mark - Static methods
+ (NSString *)employeeGroupTitleForKind:(EmployeeKind)kind;
+ (NSString *)sectionName:(EmployeeKind) sectionId;
+ (NSString *)modelChangedNotificationName;
+ (EmployeeKind)whatKindOfEmployee:(EmployeeBase *)employee;

- (NSInteger)sectionCount;
- (NSInteger)itemsInSection:(NSInteger) section;
- (EmployeeBase *)employeeAtIndexPath:(NSIndexPath *) aPath;
- (void)saveModel;

- (NSIndexPath *)addNewEmployee:(EmployeeBase *)newEmployee;
- (NSIndexPath *)replaceExistingEmployeeAtIndexPath:(NSIndexPath *)oldIndexPath withNew:newEmployee;
- (void)deleteEmployeeAtPath:(NSIndexPath *)indexPath;
- (void)moveEmployeeAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end
