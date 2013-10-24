//
//  PhotoViewController.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "PhotoViewController.h"

@implementation PhotoViewController

+ (NSArray *)galleryFilenames
{
    //  Static local predicate must be initialized to 0
    static NSArray *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *galleryPath = [resourcePath stringByAppendingPathComponent:@"Gallery"];
        NSError *error;
        NSArray *directoryContents = [[NSFileManager defaultManager]
                                      contentsOfDirectoryAtPath:galleryPath
                                      error:&error];
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:directoryContents.count];
        for (id fname in directoryContents) {
            [tmp addObject: [galleryPath stringByAppendingPathComponent:fname]];
        }
        sharedInstance = [[NSArray arrayWithArray:tmp] retain];
    });
    return sharedInstance;
}

+ (NSInteger)photoCount {
    return [self galleryFilenames].count;
}

+ (NSArray *)poolOfPhotoViewControllers
{
    //  Static local predicate must be initialized to 0
    static NSArray *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [@[
                          [[PhotoViewController alloc] init],
                          [[PhotoViewController alloc] init],
                          [[PhotoViewController alloc] init],
                          ] retain]; // Keep in memory forever
    });
    return sharedInstance;
}

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSInteger)pageIndex
{
    if (pageIndex < 0 || pageIndex >= [self photoCount])
    {
        return nil;
    }
    NSArray *pool = [self poolOfPhotoViewControllers];
    NSInteger index = pageIndex % pool.count;
    PhotoViewController *vc = pool[index];
    vc.pageIndex = pageIndex;
    return vc;
}

- (id)init
{
    self = [super init];
    _pageIndex = -1;
    return self;
}

- (void)setPageIndex:(NSInteger)index
{
    if (self.pageIndex == index) {
        return;
    }
    _pageIndex = index;
    NSString *filename = [[self class] galleryFilenames][index];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:filename];
    NSLog(@"Loaded %d", index);
    if ([self.view isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)self.view).image = img;
    } else {
        NSLog(@"self.view is incorrect");
    }
    [img release];
}

- (void)loadView
{
    UIImageView *view = [[UIImageView alloc] init];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    [view release];
}

@end
