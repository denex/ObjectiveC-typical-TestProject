//
//  GalleryPageViewController.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "GalleryPageViewController.h"
#import "PhotoViewController.h"

@interface GalleryPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UIBarButtonItem *rightButton;
@end

@implementation GalleryPageViewController

- (instancetype)init
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey: @40}];
    if (self) {
        self.title = NSLocalizedString(@"Gallery", @"Gallery");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // iOS 7 fix
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    //      self.edgesForExtendedLayout = UIRectEdgeNone;
    //    }
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Gallery", @"Gallery");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];

    _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                   style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(leftButtonPushed:)];
    _leftButton.enabled = NO;
    _rightButton = [[UIBarButtonItem alloc] initWithTitle:@">"
                                                    style:UIBarButtonItemStyleBordered
                                                   target:self
                                                   action:@selector(rightButtonPushed:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 44)];
    toolbar.items = @[_leftButton,
                      [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                     target:nil
                                                                     action:nil] autorelease],
                      _rightButton,];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:toolbar];
    [toolbar release];

    self.dataSource = self;
    self.delegate = self;
    [self loadFirstImage];
}

- (void)loadFirstImage
{
    PhotoViewController *pageZero = [PhotoViewController photoViewControllerForPageIndex:0];
    if (pageZero)
    {
        [self setViewControllers:@[pageZero]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

- (void)updateButtons
{
    self.leftButton.enabled = [self currentPageIndex] > 0;
    self.rightButton.enabled = [self currentPageIndex] < [PhotoViewController photoCount]-1;
}

- (IBAction)leftButtonPushed:(UIBarButtonItem *)button {
    button.enabled = NO;
    [self setCurrentPageIndex:[self currentPageIndex] - 1];
}

- (IBAction)rightButtonPushed:(UIBarButtonItem *)button {
    button.enabled = NO;
    [self setCurrentPageIndex:[self currentPageIndex] + 1];
}

- (NSInteger)currentPageIndex
{
    PhotoViewController *currentVC = self.viewControllers.lastObject;
    return currentVC.pageIndex;
}

- (void)setCurrentPageIndex:(NSInteger)index
{
    NSInteger direction = index - [self currentPageIndex];
    PhotoViewController *newVC = [PhotoViewController photoViewControllerForPageIndex:index];
    if (newVC) {
        [self setViewControllers:@[newVC]
                       direction: direction > 0
                                    ? UIPageViewControllerNavigationDirectionForward
                                    : UIPageViewControllerNavigationDirectionReverse
                        animated:NO
                      completion:^(BOOL finished) {
                          if (finished) {
                              [self updateButtons];
                          }
                      }];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (PhotoViewController *)pageViewController:(GalleryPageViewController *)pageViewController
         viewControllerBeforeViewController:(PhotoViewController *)viewController
{
    NSInteger index = viewController.pageIndex;
    PhotoViewController *photoVC = [PhotoViewController photoViewControllerForPageIndex:(index - 1)];
    return photoVC;
}

- (PhotoViewController *)pageViewController:(GalleryPageViewController *)pageViewController
          viewControllerAfterViewController:(PhotoViewController *)viewController
{
    NSInteger index = viewController.pageIndex;
    PhotoViewController *photoVC = [PhotoViewController photoViewControllerForPageIndex:(index + 1)];
    return photoVC;
}

- (NSInteger)presentationCountForPageViewController:(GalleryPageViewController *)pageViewController
{
    return [PhotoViewController photoCount];
}

- (NSInteger)presentationIndexForPageViewController:(GalleryPageViewController *)pageViewController
{
    return [pageViewController currentPageIndex];
}

#pragma mark - UIPageViewControllerDelegate

// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    //    self.leftButton.enabled = NO;
    //    self.rightButton.enabled = NO;
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self updateButtons];
}

#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
