//
//  Employee.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeBase.h"

@interface Employee : EmployeeBase <NSCoding>

@property (nonatomic, strong) NSString *workplace;
@property (nonatomic, strong) NSString *lunchTime;

@property (nonatomic, readonly) NSString *detail;

- (instancetype)initWithFullname:(NSString *)aFullname
                          salary:(NSString *)aSalary
                       workplace:(NSString *)aWorkplace
                       lunchTime:(NSString *)aLunchtime;

@end
