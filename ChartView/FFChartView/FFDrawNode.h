//
//  FFDrawNode.h
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define MAXSIZE  CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)

typedef void(^TouchAction)(NSInteger index);

@interface FFDrawNode : UIView

/**
 关联数据
 */
@property (retain ,nonatomic) id associateData;


@property (copy ,nonatomic) NSString *router;

@end


@interface FFTextNode : FFDrawNode

/**
 富文本字符串
 */
@property (retain ,nonatomic) NSMutableAttributedString * attrString;

/**
 绘制区域
 */
@property (assign ,nonatomic) CGRect rect;


/**
 文字是否旋转
 */
@property (assign ,nonatomic) BOOL rotation;


/**
 文字旋转角度
 */
@property (assign ,nonatomic) CGFloat angle;

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size origin:(CGPoint)origin;

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size center:(CGPoint)center;

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString angle:(CGFloat)angle size:(CGSize)size origin:(CGPoint)origin;

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString angle:(CGFloat)angle size:(CGSize)size center:(CGPoint)center;

@end


@interface FFImageNode : FFDrawNode

/**
 图片
 */
@property (retain ,nonatomic) UIImage *image;

/**
 绘制区域
 */
@property (assign ,nonatomic) CGRect rect;

+ (instancetype)initWithImage:(UIImage *)image
                       origin:(CGPoint)origin;

+ (instancetype)initWithImage:(UIImage *)image
                       center:(CGPoint)center;

@end

@interface FFPathNode : FFDrawNode

/**
 path
 */
@property (retain ,nonatomic) UIBezierPath *path;

/**
 填充色
 */
@property (retain ,nonatomic) UIColor *fillColor;

/**
 画笔颜色
 */
@property (retain ,nonatomic) UIColor *strokeColor;

+ (instancetype)initWithPath:(UIBezierPath *)path
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor;


@end

@interface FFShadowNode : FFDrawNode

/**
 阴影路径
 */
@property (retain ,nonatomic) UIBezierPath *path;

/**
 填充色
 */
@property (retain ,nonatomic) UIColor *fillColor;

/**
 画笔颜色
 */
@property (retain ,nonatomic) UIColor *strokeColor;

+ (instancetype)initWithPath:(UIBezierPath *)path
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor;


@end

@interface FFGradientNode : FFDrawNode

/**
 渐变路径
 */
@property (retain ,nonatomic) UIBezierPath *path;

/**
 渐变开始颜色
 */
@property (retain ,nonatomic) UIColor *startColor;

/**
 渐变结束颜色
 */
@property (retain ,nonatomic) UIColor *endColor;


/**
 渐变开始点
 */
@property (assign ,nonatomic) CGPoint startPoint;

/**
 渐变结束点
 */
@property (assign ,nonatomic) CGPoint endPoint;


+ (instancetype)initWithPath:(UIBezierPath *)path;

@end

@class FFChartHandle;

/**
 点击节点
 */
@interface FFTouchNode : FFDrawNode

@property (assign ,nonatomic) NSInteger idx;

@property (assign ,nonatomic) CGPoint aimPoint;//气泡指向点

@property (retain ,nonatomic) NSArray *nodesArray;

@property (assign ,nonatomic) CGRect touchRect;

@property (assign ,nonatomic) CGSize contentSize;

@property (assign ,nonatomic) BOOL isRignt;//


@property (copy ,nonatomic) TouchAction touchAction;


+ (instancetype)initWithTouchRect:(CGRect)touchRect;


+ (instancetype)initWithNodes:(NSArray *)nodesArray
                    touchRect:(CGRect)touchRect
                     aimPoint:(CGPoint)aimPoint;


@end


