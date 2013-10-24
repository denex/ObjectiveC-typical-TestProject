//
//  Employee.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "Employee.h"

@implementation Employee

- (instancetype)initWithFullname:(NSString *)aFullname
                          salary:(NSString *)aSalary
                       workplace:(NSString *)aWorkplace
                       lunchTime:(NSString *)aLunchtime
{
    self = [super initWithFullname:aFullname salary:aSalary];
    self.workplace = aWorkplace;
    self.lunchTime = aLunchtime;
    return self;
}

- (NSString *)detail
{
    return self.workplace;
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.workplace forKey:@"workplace"];
    [aCoder encodeObject:self.lunchTime forKey:@"lunchtime"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.workplace = [aDecoder decodeObjectForKey:@"workplace"];
        self.lunchTime = [aDecoder decodeObjectForKey:@"lunchtime"];
    }
    return self;
}

#pragma mark - dealloc
- (void)dealloc
{
    [_workplace release];
    [_lunchTime release];
    [super dealloc];
}

@end
