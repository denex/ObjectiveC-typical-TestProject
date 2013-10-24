//
//  Executive.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeBase.h"

@interface Executive : EmployeeBase <NSCoding>

@property (nonatomic, strong) NSString *officeHours;

@property (nonatomic, readonly) NSString *detail;

- (instancetype) initWithFullname:(NSString *)aFullname
                           salary:(NSString *)aSalary
                      officeHours:(NSString*)anOfficeHours;

@end
