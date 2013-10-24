//
//  HtmlWriter.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlWriter : NSObject <NSXMLParserDelegate>

+ (NSString *) htmlEscapeString:(NSString *)string;

- (instancetype) init;
- (instancetype) initWithCapacity:(NSInteger)capacity;

@property (nonatomic, strong, readonly, getter = htmlString) NSString *htmlString;

@end
