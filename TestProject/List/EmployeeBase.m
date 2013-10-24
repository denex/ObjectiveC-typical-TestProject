//
//  EmployeeBase.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "EmployeeBase.h"

@implementation EmployeeBase

- (instancetype)init
{
    return [self initWithFullname:@"" salary:@"$1000"];
}

- (instancetype)initWithFullname:(NSString *)aFullname
                          salary:(NSString *)aSalary;
{
    self = [super init];
    self.fullname = aFullname;
    self.salary = aSalary;
    return self;
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.fullname forKey:@"fullname"];
    [aCoder encodeObject:self.salary forKey:@"salary"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self initWithFullname:[aDecoder decodeObjectForKey:@"fullname"]
                           salary:[aDecoder decodeObjectForKey:@"salary"]];
    return self;
}

#pragma mark - dealloc
- (void)dealloc
{
    [_fullname release];
    [_salary release];
    [super dealloc];
}

@end
