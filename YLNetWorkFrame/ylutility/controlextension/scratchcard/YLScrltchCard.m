//
//  YLScrltchCard.m
//  YLAppUtility
//
//  Created by yilong zhang on 2017/3/30.
//  Copyright © 2017年 zhangyilong. All rights reserved.
//

#import "YLScrltchCard.h"

@implementation YLScrltchCard
{
    UIView*             imagev;
    CAShapeLayer*       maskLayer;
    CGMutablePathRef    path;
}

- (void)dealloc
{
    if (path) CGPathRelease(path);
}

- (instancetype)initWithFrame:(CGRect)frame SurfaceText:(NSString*)surface AwardText:(NSString*)Award
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = surface;
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor orangeColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = Award;
        [self addSubview:label];
        
        imagev = label;
        
        [self initMaskLayer];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Surface:(UIImage*)surface Award:(UIImage*)award
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIImageView* imgv = [[UIImageView alloc] initWithFrame:self.bounds];
        imgv.image = surface;
        [self addSubview:imgv];
        
        imgv = [[UIImageView alloc] initWithFrame:self.bounds];
        imgv.image = award;
        [self addSubview:imgv];
        
        imagev = imgv;
        
        [self initMaskLayer];
    };
    
    return self;
}

- (void)initMaskLayer
{
    path = CGPathCreateMutable();
    
    //创建遮罩
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, imagev.frame.size.width, imagev.frame.size.height);
    maskLayer.path = path;
    maskLayer.lineCap = kCALineCapRound;
    maskLayer.lineJoin = kCALineJoinRound;
    maskLayer.lineWidth = 15;
    maskLayer.strokeColor = [UIColor blueColor].CGColor;
    maskLayer.fillColor = nil;
    
    imagev.layer.mask = maskLayer;
}

- (UIImage*)getImageWithColor:(UIColor*)color
{
    //绘图设备上下文一般的使用时在drawRect中调用，测试系统压栈graphicscontext；
    //因此在其它地方使用，需要手动创建griphcscontext
    //graphicscontext是内存块，可以在这块内存中做绘图动作
    
    UIGraphicsBeginImageContextWithOptions(imagev.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctxt, color.CGColor);
    //CGContextAddRect(ctxt, CGRectMake(0, 0, maskImagev.frame.size.width, maskImagev.frame.size.height));
    //CGContextFillPath(ctxt);
    CGContextFillRect(ctxt, CGRectMake(0, 0, imagev.frame.size.width, imagev.frame.size.height));
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)reset
{
    if (path) CGPathRelease(path);
    
    path = CGPathCreateMutable();
    maskLayer.path = path;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:imagev];
    
    if (!CGPathContainsPoint(path, NULL, point, YES))
    {
        CGPathMoveToPoint(path, NULL, point.x, point.y);
        maskLayer.path = path;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:imagev];
    
    if (!CGPathContainsPoint(path, NULL, point, YES))
    {
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
        maskLayer.path = path;
    }
}

@end
