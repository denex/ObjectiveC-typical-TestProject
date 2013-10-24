//
//  Accountant.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "Employee.h"

typedef NS_ENUM(NSInteger, AccountantKind) {
    AccountantKindPayroll,
    AccountantKindRecordkeeping,
};

@interface Accountant : Employee <NSCoding>

@property (nonatomic) AccountantKind specialization;

@property (nonatomic, readonly) NSString *detail;

+ (NSString *)specializationStringOfKind:(AccountantKind)kind;

- (instancetype) initWithFullname:(NSString *)aFullname
                           salary:(NSString *)aSalary
                        workplace:(NSString *)aWorkplace
                        lunchTime:(NSString *)aLunchtime
                   specialization:(AccountantKind)aSpecialization;

@end
