//
//  FFTipsView.h
//  FFTipsView
//
//  Created by North on 2019/6/27.
//  Copyright © 2019 North. All rights reserved.
//

#import <UIKit/UIKit.h>

//箭头指向方向
typedef NS_OPTIONS(NSUInteger, FFArrowDirection) {
    
    FFArrowDirectionNone   = 1 << 0, //自适应指向方向
    FFArrowDirectionTop    = 1 << 1, //箭头指向上方
    FFArrowDirectionLeft   = 1 << 2, //箭头指向左方
    FFArrowDirectionBottom = 1 << 3, //箭头指向下方
    FFArrowDirectionRight  = 1 << 4  //箭头指向右方
};

@interface FFTipsView : UIView

/**
 三角形的宽高
 */
@property (assign ,nonatomic) CGSize arrowSize;//三角形的宽高

/**
 背景填充色
 */
@property (retain ,nonatomic) UIColor *fillColor;
/**
 内边距
 */
@property (assign ,nonatomic) UIEdgeInsets inset;

/**
 转角半径
 */
@property (assign ,nonatomic) CGFloat radius;


/**
 设置箭头指向方向 不调用默认按上左下右来适应
 */
@property (assign ,nonatomic) FFArrowDirection arrowDirection;


- (instancetype)initWithContentView:(UIView *)contentView inView:(UIView *)superView;

- (void)showOnPoint:(CGPoint)point;

- (void)hide;

@end


