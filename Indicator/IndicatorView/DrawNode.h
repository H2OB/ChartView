//
//  DrawNode.h
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawNode : NSObject

/**
 是否允许点击 默认NO
 */
@property (assign ,nonatomic) BOOL allowTouch;

/**
 点击范围 默认
 */
@property (assign ,nonatomic) CGRect touchRect;


@end


@interface TextNode : DrawNode

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


+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation;


+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size origin:(CGPoint)origin;

@end

@interface ImageNode : DrawNode

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

@end

@interface PathNode : DrawNode

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

@interface ShadowNode : DrawNode

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

@interface GradientNode : DrawNode

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

