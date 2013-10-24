//
//  Model.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "Model.h"
#import "Executive.h"
#import "Employee.h"
#import "Accountant.h"

@interface Model () <NSCoding>

@end

@implementation Model

- (instancetype)initWithDummyData
{
    self = [super init];
    if (self) {
        self.executives = [NSMutableArray arrayWithCapacity:10];
        self.employees = [NSMutableArray arrayWithCapacity:10];
        self.accountants = [NSMutableArray arrayWithCapacity:10];
        [self.executives addObject:[[[Executive alloc] initWithFullname:@"First CEO"
                                                                 salary:@"$10000"
                                                            officeHours:@"12-15"] autorelease]];
        [self.executives addObject:[[[Executive alloc] initWithFullname:@"Second CEO"
                                                                 salary:@"5000"
                                                            officeHours:@"11-16"] autorelease]];

        [self.employees addObject:[[[Employee alloc] initWithFullname:@"First Employee"
                                                               salary:@"$100.99"
                                                            workplace:@"42"
                                                            lunchTime:@"13-14"] autorelease]];
        [self.employees addObject:[[[Employee alloc] initWithFullname:@"Second Employee"
                                                               salary:@"200.99"
                                                            workplace:@"43"
                                                            lunchTime:@"13-14"] autorelease]];

        [self.accountants addObject:[[[Accountant alloc] initWithFullname:@"First Accountant"
                                                                   salary:@"100.10"
                                                                workplace:@"44"
                                                                lunchTime:@"12-13"
                                                           specialization:AccountantKindRecordkeeping] autorelease]];
        [self.accountants addObject:[[[Accountant alloc] initWithFullname:@"Second Accountant"
                                                                   salary:@"200.10"
                                                                workplace:@"45"
                                                                lunchTime:@"12-13"
                                                           specialization:AccountantKindPayroll] autorelease]];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.executives forKey:@"executives"];
    [aCoder encodeObject:self.employees forKey:@"employees"];
    [aCoder encodeObject:self.accountants forKey:@"accountants"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.executives = [aDecoder decodeObjectForKey:@"executives"];
        self.employees = [aDecoder decodeObjectForKey:@"employees"];
        self.accountants = [aDecoder decodeObjectForKey:@"accountants"];
    }
    return self;
}

#pragma mark - Static methods

+ (EmployeeKind)getKindOfEmployee:(EmployeeBase *)employee
{
    if ([employee isMemberOfClass:[Executive class]]) {
        return EmployeeKindExecutive;
    }
    if ([employee isMemberOfClass:[Employee class]]) {
        return EmployeeKindEmployee;
    }
    return EmployeeKindAccountant;
}

#pragma mark - dealloc
- (void)dealloc
{
    [_executives release];
    [_employees release];
    [_accountants release];
    [super dealloc];
}

@end
