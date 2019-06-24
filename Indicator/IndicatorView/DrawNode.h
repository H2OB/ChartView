//
//  DrawNode.h
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MAXSIZE  CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)


@interface DrawNode : NSObject

/**
 关联数据
 */
@property (retain ,nonatomic) id associateData;


@property (copy ,nonatomic) NSString *router;

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

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size origin:(CGPoint)origin;

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size center:(CGPoint)center;

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

+ (instancetype)initWithImage:(UIImage *)image
                       center:(CGPoint)center;

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


/**
 点击节点
 */
@interface TouchNode : DrawNode

@property (assign ,nonatomic) BOOL isBubble;//是否气泡类型

@property (assign ,nonatomic) CGPoint aimPoint;

@property (retain ,nonatomic) NSArray *nodesArray;

@property (assign ,nonatomic) CGRect touchRect;

@property (assign ,nonatomic) CGSize contentSize;


+ (instancetype)initWithTouchRect:(CGRect)touchRect;


+ (instancetype)initWithNodes:(NSArray *)nodesArray
                    touchRect:(CGRect)touchRect
                     aimPoint:(CGPoint)aimPoint;

+ (instancetype)initWithNodes:(NSArray *)nodesArray
                    touchRect:(CGRect)touchRect
                     aimPoint:(CGPoint)aimPoint
                     isBubble:(BOOL)isBubble;

@end
