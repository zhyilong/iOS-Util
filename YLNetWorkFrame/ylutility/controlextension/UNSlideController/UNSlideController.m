//
//  UNSlideController.m
//  UNSlideController
//
//  Created by zhangyilong on 16/1/13.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "UNSlideController.h"

@implementation UNSlideController
{
    BOOL        isHorizontalSlide;
    BOOL        isVerticalSlide;
    CGPoint     panStartPoint;
    CGPoint     panMovePoint;
    
    UITapGestureRecognizer*     tapGesture;
}

@synthesize menuController;
@synthesize homeController;
@synthesize rightBoundry;
@synthesize minScale;

- (void)dealloc
{
    self.homeController = nil;
    self.menuController = nil;
}

- (instancetype)initWithController:(UIViewController *)homecontroller MenuController:(UIViewController *)menucontroller
{
    if ([super init])
    {
        isHorizontalSlide = NO;
        isVerticalSlide = NO;
        minScale = 0.9;
        rightBoundry = [UIScreen mainScreen].bounds.size.width + [UIScreen mainScreen].bounds.size.width / 2 * 0.5;
        
        homeController = homecontroller;
        menuController = menucontroller;
        
        return self;
    }
    
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuController.view.transform = CGAffineTransformMakeScale(minScale, minScale);
    [self.view addSubview:menuController.view];
    
    NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:menuController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:menuController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];;
    NSLayoutConstraint* constraint3 = [NSLayoutConstraint constraintWithItem:menuController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];;
    NSLayoutConstraint* constraint4 = [NSLayoutConstraint constraintWithItem:menuController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
    
    [self.view addSubview:homeController.view];
    
    constraint1 = [NSLayoutConstraint constraintWithItem:homeController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    constraint2 = [NSLayoutConstraint constraintWithItem:homeController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];;
    constraint3 = [NSLayoutConstraint constraintWithItem:homeController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];;
    constraint4 = [NSLayoutConstraint constraintWithItem:homeController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
    
    menuController.view.center = CGPointMake(-self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanGestureDown:)];
    gesture.delegate = self;
    [homeController.view addGestureRecognizer:gesture];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureDown:)];
    tapGesture.enabled = NO;
    [homeController.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didTapGestureDown:(UITapGestureRecognizer*)sender
{
    if (UIGestureRecognizerStateEnded == sender.state)
    {
        [self slideLeft];
    }
}

- (void)didPanGestureDown:(UIPanGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self.view];
    
    if (UIGestureRecognizerStateBegan == sender.state)
    {
        panStartPoint = point;
    }
    else if (UIGestureRecognizerStateChanged == sender.state)
    {
        float xvar = point.x - panMovePoint.x;
        
        //向右侧滑动
        if (xvar > 0)
        {
            //到达最右侧
            if ( (homeController.view.center.x + xvar) > rightBoundry)
            {
                xvar = rightBoundry - homeController.view.center.x;
            }
        }
        else
        {
            //到达最左侧
            if ( (homeController.view.center.x + xvar) <= self.view.frame.size.width / 2)
            {
                xvar = self.view.frame.size.width / 2 - homeController.view.center.x;
            }
        }
        
        CGSize size = self.view.frame.size;
        float scale = ((homeController.view.center.x + xvar) - size.width / 2) / (rightBoundry - size.width / 2);
        float inscale = 1 - minScale;
        
        [UIView beginAnimations:nil context:nil];
        homeController.view.center = CGPointMake(homeController.view.center.x + xvar, homeController.view.center.y);
        homeController.view.transform = CGAffineTransformMakeScale(1 - scale * inscale, 1 - scale * inscale);
        menuController.view.center = CGPointMake(menuController.view.center.x + xvar, menuController.view.center.y);
        menuController.view.transform = CGAffineTransformMakeScale(minScale + scale * inscale, minScale + scale * inscale);
        [UIView commitAnimations];
    }
    else
    {
        CGSize size = self.view.frame.size;
        float xvar = size.width / 2;
        float maxside = (rightBoundry - xvar) / 2;
        
        //滑动到最左侧
        if ( (homeController.view.center.x - xvar) < maxside)
        {
            [self slideLeft]; return;
        }
        //滑动最右侧
        else
        {
            [self slideRight]; return;
        }
    }
    
    panMovePoint = point;
}

- (void)slideRight
{
    [UIView beginAnimations:nil context:nil];
    homeController.view.center = CGPointMake(rightBoundry, homeController.view.center.y);
    homeController.view.transform = CGAffineTransformMakeScale(minScale, minScale);
    menuController.view.center = CGPointMake(-self.view.frame.size.width / 2 + rightBoundry - self.view.frame.size.width / 2, menuController.view.center.y);
    menuController.view.transform = CGAffineTransformMakeScale(1, 1);
    tapGesture.enabled = YES;
    [UIView commitAnimations];
}

- (void)slideLeft
{
    [UIView beginAnimations:nil context:nil];
    homeController.view.center = CGPointMake(self.view.frame.size.width / 2, homeController.view.center.y);
    homeController.view.transform = CGAffineTransformMakeScale(1, 1);
    menuController.view.center = CGPointMake(-self.view.frame.size.width / 2, menuController.view.center.y);
    menuController.view.transform = CGAffineTransformMakeScale(minScale, minScale);
    tapGesture.enabled = NO;
    [UIView commitAnimations];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL isout = YES;
    
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]])
    {
        CGPoint point = [gestureRecognizer locationInView:homeController.view];
        
        if (fabs(point.x) > 44)
        {
            isout = NO;
        }
    }
    
    return isout;
}

@end
