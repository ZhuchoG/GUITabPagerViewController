//
//  GUITabScrollView.m
//  GUITabPagerViewController
//
//  Created by Guilherme Araújo on 26/02/15.
//  Copyright (c) 2015 Guilherme Araújo. All rights reserved.
//

#import "GUITabScrollView.h"

#define MAP(a, b, c) MIN(MAX(a, b), c)

@interface GUITabScrollView ()

- (void)_initTabbatAtIndex:(NSInteger)index;

@property (strong, nonatomic) NSArray *tabViews;
@property (strong, nonatomic) NSLayoutConstraint *tabIndicatorDisplacement;
@property (strong, nonatomic) NSLayoutConstraint *tabIndicatorWidth;

@end

@implementation GUITabScrollView

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame tabViews:(NSArray *)tabViews tabBarHeight:(CGFloat)height tabColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor selectedTabIndex:(NSInteger)index {
    self = [self initWithFrame:frame tabViews:tabViews tabBarHeight:height tabColor:color backgroundColor:backgroundColor];
    if (self) {
        NSInteger tabIndex = 0;
        if (index) {
            tabIndex = index;
        }
        [self _initTabbatAtIndex:index];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame tabViews:(NSArray *)tabViews tabBarHeight:(CGFloat)height tabColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
  self = [super initWithFrame:frame];
  
  if (self) {
    [self setShowsHorizontalScrollIndicator:NO];
    [self setBounces:NO];
    
    [self setTabViews:tabViews];
    
    CGFloat width = 10;
    
    for (UIView *view in tabViews) {
      width += view.frame.size.width + 10;
    }
    
    [self setContentSize:CGSizeMake(MAX(width, self.frame.size.width), height)];
    
    CGFloat widthDifference = MAX(0, self.frame.size.width * 1.0f - width);
    
    UIView *contentView = [UIView new];
    [contentView setFrame:CGRectMake(0, 0, MAX(width, self.frame.size.width), height)];
    [contentView setBackgroundColor:backgroundColor];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:contentView];
  }
  
  return self;
}

#pragma mark - Public Methods

- (void)animateToTabAtIndex:(NSInteger)index {
    [self animateToTabAtIndex:index animated:YES];
}

- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat animatedDuration = 0.4f;
    if (!animated) {
        animatedDuration = 0.0f;
    }
    
    CGFloat x = [[self tabViews][0] frame].origin.x - 5;
    
    for (int i = 0; i < index; i++) {
        x += [[self tabViews][i] frame].size.width + 10;
    }
    
    CGFloat w = [[self tabViews][index] frame].size.width + 10;
    [UIView animateWithDuration:animatedDuration
                     animations:^{
                         CGFloat p = x - (self.frame.size.width - w) / 2;
                         CGFloat min = 0;
                         CGFloat max = MAX(0, self.contentSize.width - self.frame.size.width);
                         
                         [self setContentOffset:CGPointMake(MAP(p, min, max), 0)];
                         [[self tabIndicatorDisplacement] setConstant:x];
                         [[self tabIndicatorWidth] setConstant:w];
                         [self layoutIfNeeded];
                     }];
}

- (void)tabTapHandler:(UITapGestureRecognizer *)gestureRecognizer {
  if ([[self tabScrollDelegate] respondsToSelector:@selector(tabScrollView:didSelectTabAtIndex:)]) {
    NSInteger index = [[gestureRecognizer view] tag];
    [[self tabScrollDelegate] tabScrollView:self didSelectTabAtIndex:index];
    [self animateToTabAtIndex:index];
  }
}

#pragma mark - Private Methods

- (void)_initTabbatAtIndex:(NSInteger)index {
    CGFloat x = [[self tabViews][0] frame].origin.x - 5;
    
    for (int i = 0; i < index; i++) {
        x += [[self tabViews][i] frame].size.width + 10;
    }
    
    CGFloat w = [[self tabViews][index] frame].size.width + 10;
    
    CGFloat p = x - (self.frame.size.width - w) / 2;
    CGFloat min = 0;
    CGFloat max = MAX(0, self.contentSize.width - self.frame.size.width);
    
    [self setContentOffset:CGPointMake(MAP(p, min, max), 0)];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight) {
        x = x + (w/2);
    }
    
    [[self tabIndicatorDisplacement] setConstant:x];
    [[self tabIndicatorWidth] setConstant:w];
    [self layoutIfNeeded];
}


@end
