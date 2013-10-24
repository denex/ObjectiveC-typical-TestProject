//
//  Accountant.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "Accountant.h"

@implementation Accountant

+ (NSString *)specializationStringOfKind:(AccountantKind)kind
{
    switch (kind) {
        case AccountantKindPayroll:
            return NSLocalizedString(@"Payroll", @"Payroll");
        case AccountantKindRecordkeeping:
            return NSLocalizedString(@"Record keeping", @"Record keeping");
    }
}

- (instancetype) initWithFullname:(NSString *)aFullname
                           salary:(NSString *)aSalary
                        workplace:(NSString *)aWorkplace
                        lunchTime:(NSString *)aLunchtime
                   specialization:(AccountantKind)aSpecialization
{
    self = [super initWithFullname:aFullname salary:aSalary workplace:aWorkplace lunchTime:aLunchtime];
    if (self) {
        self.specialization = aSpecialization;
    }
    return self;
}

- (NSString *)detail
{
    return [[self class] specializationStringOfKind:self.specialization];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.specialization forKey:@"specialization"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.specialization = [aDecoder decodeIntegerForKey:@"specialization"];
    }
    return self;
}

#pragma mark - dealloc
- (void)dealloc
{
    [super dealloc];
}

@end
