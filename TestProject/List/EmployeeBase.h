//
//  EmployeeBase.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmployeeBase : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *salary;

@property (nonatomic, readonly) NSString *detail;

- (instancetype)initWithFullname:(NSString *)aFullname
                          salary:(NSString *)aSalary;

@end
