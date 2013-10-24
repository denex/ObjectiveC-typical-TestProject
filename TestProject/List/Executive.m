//
//  Executive.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "Executive.h"

@implementation Executive

- (instancetype) initWithFullname:(NSString *)aFullname
                           salary:(NSString *)aSalary
                      officeHours:(NSString *)anOfficeHours
{
    self = [super initWithFullname:aFullname salary:aSalary];
    if (self) {
        self.officeHours = anOfficeHours;
    }
    return self;
}

- (NSString *)detail
{
    return self.officeHours;
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.officeHours forKey:@"officehours"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.officeHours = [aDecoder decodeObjectForKey:@"officehours"];
    }
    return self;
}

#pragma mark - dealloc
- (void)dealloc
{
    [_officeHours release];
    [super dealloc];
}

@end
