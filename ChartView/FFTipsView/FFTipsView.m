//
//  FFTipsView.m
//  FFTipsView
//
//  Created by North on 2019/6/27.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFTipsView.h"


@interface FFTipsView ()

@property (weak ,nonatomic) UIView *fakerView;
@property (retain ,nonatomic) UIView *contentView;
@property (retain ,nonatomic) CAShapeLayer *shapelayer;

@end



@implementation FFTipsView

- (instancetype)initWithContentView:(UIView *)contentView inView:(UIView *)superView{
    
    self = [super init];
    
    if(self){
        
        self.fakerView = superView;
        self.contentView = contentView;
        [self addSubview:self.contentView];
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    
    self.arrowSize = CGSizeMake(10, 5);
    self.radius = 5;
    self.fillColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
    
    self.backgroundColor = [UIColor clearColor];
    self.inset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.shapelayer = [CAShapeLayer layer];
    self.shapelayer.shadowColor = UIColor.blackColor.CGColor;
    self.shapelayer.shadowOffset = CGSizeZero;
    self.shapelayer.shadowOpacity = .3;
    
    [self.layer insertSublayer:self.shapelayer atIndex:0];
    
    
}

- (void)showOnPoint:(CGPoint)point{
    
    //    父视图的bounds
    CGRect superBounds = self.fakerView.bounds;
    if([self.fakerView isKindOfClass:[UIScrollView class]]){
        superBounds.size = ((UIScrollView *)self.fakerView).contentSize;
    }
    
    //背景的大小
    CGSize bgSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds)+ self.inset.left + self.inset.right, CGRectGetHeight(self.contentView.frame) + self.inset.top + self.inset.bottom);
    
    CGRect frame = CGRectZero;
    frame.size = bgSize;
    CGRect bgFrame = CGRectZero;
    bgFrame.size = bgSize;
    
    //计算 在哪一个方位
    
#pragma mark 上方能放下 箭头指向下方
    
    if((self.arrowDirection == FFArrowDirectionBottom || self.arrowDirection == FFArrowDirectionNone) && point.y - bgSize.height - self.arrowSize.height > 0){
        
        frame.size.height = bgSize.height + self.arrowSize.height;
        CGFloat distance = 0 ;
        //箭头居中
        if (point.x - bgSize.width/2.0 > 0 && CGRectGetWidth(superBounds) - point.x > bgSize.width/2.0) {
            distance = 0;
            //箭头居左
        } else if (point.x - bgSize.width/2.0 < 0) {
            
            distance =  bgSize.width/2.0 - point.x;
            
        } else {
            
            distance = CGRectGetWidth(superBounds) - point.x - bgSize.width/2.0;
        }
        
        
        frame.origin.x = point.x - bgSize.width/2.0 + distance;
        frame.origin.y = point.y - frame.size.height;
        
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:bgFrame cornerRadius:self.radius];
        
        
        {
            UIBezierPath * arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint:CGPointMake(bgSize.width/2.0 - self.arrowSize.width/2.0 -distance, bgSize.height)];
            [arrowPath addLineToPoint:CGPointMake(bgSize.width/2.0 + self.arrowSize.width/2.0 - distance, bgSize.height)];
            [arrowPath addLineToPoint:CGPointMake(bgSize.width/2.0 - distance, bgSize.height + self.arrowSize.height)];
            [arrowPath closePath];
            [bezierPath appendPath:arrowPath];
        }
        
        
        self.shapelayer.path = bezierPath.CGPath;
        self.contentView.frame = CGRectMake(self.inset.left, self.inset.top, CGRectGetWidth(self.contentView.bounds),CGRectGetHeight(self.contentView.bounds));
        
        self.shapelayer.fillColor = self.fillColor.CGColor;
        [self.fakerView addSubview:self];
        self.frame = frame;
        return;
        
    }
    
#pragma mark 右边能放下 箭头指向左边
    
    else if((self.arrowDirection == FFArrowDirectionLeft || self.arrowDirection == FFArrowDirectionNone) && CGRectGetWidth(superBounds)- point.x > bgSize.width + self.arrowSize.height){
        
        frame.size.width = bgSize.width + self.arrowSize.height;
        bgFrame.origin.x = self.arrowSize.height;
        CGFloat distance = 0 ;
        
        //居中
        if (point.y - bgSize.height/2.0 > 0 && CGRectGetHeight(superBounds) - point.y > bgSize.height/2.0){
            
            distance = 0;
            
        } else if (point.y - bgSize.height/2.0 < 0){
            
            distance = bgSize.height/2.0 - point.y;
            
        } else {
            
            distance = CGRectGetHeight(superBounds) - point.y - bgSize.height/2.0;
        }
        
        frame.origin.x = point.x;
        frame.origin.y = point.y - bgSize.height/2.0 + distance;
        
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:bgFrame cornerRadius:self.radius];
        
        //画三角形
        {
            UIBezierPath * arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint:CGPointMake(self.arrowSize.height, bgSize.height/2.0 - self.arrowSize.width/2.0 - distance)];
            [arrowPath addLineToPoint:CGPointMake(self.arrowSize.height, bgSize.height/2.0 + self.arrowSize.width/2.0 - distance)];
            [arrowPath addLineToPoint:CGPointMake(0, bgSize.height/2.0 - distance)];
            [arrowPath closePath];
            [bezierPath appendPath:arrowPath];
        }
        
        self.shapelayer.path = bezierPath.CGPath;
        self.contentView.frame = CGRectMake(self.inset.left + self.arrowSize.height, self.inset.top, CGRectGetWidth(self.contentView.bounds),CGRectGetHeight(self.contentView.bounds));
        
        self.shapelayer.fillColor = self.fillColor.CGColor;
        [self.fakerView addSubview:self];
        self.frame = frame;
        
        return;
        
        
    }
    
#pragma mark 下方能放下 箭头指向上边
    
    else  if((self.arrowDirection == FFArrowDirectionTop || self.arrowDirection == FFArrowDirectionNone) && CGRectGetHeight(superBounds) - point.y > bgSize.height + self.arrowSize.height){
        
        frame.size.height = bgSize.height + self.arrowSize.height;
        bgFrame.origin.y = self.arrowSize.height;
        CGFloat distance = 0 ;
        //箭头居中
        if (point.x - bgSize.width/2.0 > 0 && CGRectGetWidth(superBounds) - point.x > bgSize.width/2.0) {
            distance = 0;
            //箭头居左
        } else if (point.x - bgSize.width/2.0 < 0) {
            
            distance =  bgSize.width/2.0 - point.x;
            
        } else {
            
            distance = CGRectGetWidth(superBounds) - point.x - bgSize.width/2.0;
        }
        
        
        frame.origin.x = point.x - bgSize.width/2.0 + distance;
        frame.origin.y = point.y;
        
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:bgFrame cornerRadius:self.radius];
        
        
        {
            UIBezierPath * arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint:CGPointMake(bgSize.width/2.0 - self.arrowSize.width/2.0 -distance, self.arrowSize.height)];
            [arrowPath addLineToPoint:CGPointMake(bgSize.width/2.0 + self.arrowSize.width/2.0 - distance, self.arrowSize.height)];
            [arrowPath addLineToPoint:CGPointMake(bgSize.width/2.0 - distance, 0)];
            [arrowPath closePath];
            [bezierPath appendPath:arrowPath];
        }
        
        
        self.shapelayer.path = bezierPath.CGPath;
        self.contentView.frame = CGRectMake(self.inset.left, self.inset.top + self.arrowSize.height, CGRectGetWidth(self.contentView.bounds),CGRectGetHeight(self.contentView.bounds));
        
        self.shapelayer.fillColor = self.fillColor.CGColor;
        [self.fakerView addSubview:self];
        self.frame = frame;
        return;
        
    }
    
    
#pragma mark 左方能放下 箭头指向右边
    
    
    else  if((self.arrowDirection == FFArrowDirectionRight || self.arrowDirection == FFArrowDirectionNone) &&point.x - bgSize.width - self.arrowSize.height > 0){
        
        frame.size.width = bgSize.width + self.arrowSize.height;
        CGFloat distance = 0 ;
        
        //居中
        if (point.y - bgSize.height/2.0 > 0 && CGRectGetHeight(superBounds) - point.y > bgSize.height/2.0){
            
            distance = 0;
            
        } else if (point.y - bgSize.height/2.0 < 0){
            
            distance = bgSize.height/2.0 - point.y;
            
        } else {
            
            distance = CGRectGetHeight(superBounds) - point.y - bgSize.height/2.0;
        }
        
        frame.origin.x = point.x - bgSize.width - self.arrowSize.height;
        frame.origin.y = point.y - bgSize.height/2.0 + distance;
        
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:bgFrame cornerRadius:self.radius];
        
        //画三角形
        {
            UIBezierPath * arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint:CGPointMake(bgSize.width, bgSize.height/2.0 - self.arrowSize.width/2.0 - distance)];
            [arrowPath addLineToPoint:CGPointMake(bgSize.width, bgSize.height/2.0 + self.arrowSize.width/2.0 - distance)];
            [arrowPath addLineToPoint:CGPointMake(bgSize.width + self.arrowSize.height, bgSize.height/2.0 - distance)];
            [arrowPath closePath];
            [bezierPath appendPath:arrowPath];
        }
        
        self.shapelayer.path = bezierPath.CGPath;
        self.contentView.frame = CGRectMake(self.inset.left, self.inset.top, CGRectGetWidth(self.contentView.bounds),CGRectGetHeight(self.contentView.bounds));
        
        self.shapelayer.fillColor = self.fillColor.CGColor;
        [self.fakerView addSubview:self];
        self.frame = frame;
        
        return;
        
    } else {
        
        self.arrowDirection = FFArrowDirectionNone;
        [self showOnPoint:point];
        
    }
    
    
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hide];
}


- (void)hide{
    
    [self removeFromSuperview];
}


@end
