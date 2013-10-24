//
//  PhotoViewController.h
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

+ (NSInteger)photoCount;
+ (PhotoViewController *)photoViewControllerForPageIndex:(NSInteger)pageIndex;

@property (nonatomic, setter = setPageIndex:) NSInteger pageIndex;

@end
