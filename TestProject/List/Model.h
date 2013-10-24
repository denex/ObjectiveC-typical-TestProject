//
//  Model.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeBase.h"
#import "DataSource.h"

@interface Model : NSObject

- (instancetype)initWithDummyData;

@property (nonatomic, strong) NSMutableArray *executives;
@property (nonatomic, strong) NSMutableArray *employees;
@property (nonatomic, strong) NSMutableArray *accountants;

+ (EmployeeKind)getKindOfEmployee:(EmployeeBase *)employee;

@end
