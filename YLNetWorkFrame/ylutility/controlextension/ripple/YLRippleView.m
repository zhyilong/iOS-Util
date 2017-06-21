//
//  RippleView.m
//  YLAppUtility
//
//  Created by yilong zhang on 2017/3/29.
//  Copyright © 2017年 zhangyilong. All rights reserved.
//

#import "YLRippleView.h"

@implementation YLRippleView

- (instancetype)initWithFrame:(CGRect)frame Count:(NSInteger)count
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        for (NSInteger i=0; i<count; i++)
        {
            [self performSelector:@selector(initShapeLayer) withObject:nil afterDelay:0.5 * i];
        }
    }
    
    return self;
}

- (void)initShapeLayer
{
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.frame = CGRectMake(0, 0, 20, 20);
    layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    layer.borderWidth = 0;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.cornerRadius = layer.frame.size.width / 2;
    
    [self.layer addSublayer:layer];
    [self annimation:layer];
}

- (void)annimation:(CAShapeLayer*)layer
{
    float scale = self.frame.size.width / layer.frame.size.width;
    
    CABasicAnimation* scaleannimate = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleannimate.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
    scaleannimate.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation* alphaanimate = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaanimate.fromValue = @1;
    alphaanimate.toValue = @0;
    
    CAAnimationGroup* group = [[CAAnimationGroup alloc] init];
    group.animations = @[scaleannimate, alphaanimate];
    group.repeatCount = NSIntegerMax;
    group.removedOnCompletion = YES;
    group.duration = 3;
    group.delegate = self;
    
    [layer addAnimation:group forKey:@"scale"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        NSLog(@"动画停止");
    }
}

@end
