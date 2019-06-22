//
//  DrawNode.m
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//

#import "DrawNode.h"

@implementation DrawNode

@end

@implementation TextNode

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation{
    
    TextNode *node = [TextNode new];
    node.attrString = attrString;
    node.rotation = rotation;
    return node;
}

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size origin:(CGPoint)origin{
    
    TextNode *node = [TextNode initWithAttrString:attrString rotation:rotation];
    
    CGRect rect = [attrString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    rect.origin =origin;
    
    node.rect = rect;
    
    return node;
    
}


@end

@implementation ImageNode

+ (instancetype)initWithImage:(UIImage *)image origin:(CGPoint)origin{
    
    ImageNode *node = [ImageNode new];
    node.image = image;
    CGRect rect = CGRectZero;
    rect.size = image.size;
    node.rect = rect;
    return node;
}

@end

@implementation PathNode

+ (instancetype)initWithPath:(UIBezierPath *)path
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor{
    
    PathNode *node = [PathNode new];
    node.path = path;
    node.fillColor = fillColor;
    node.strokeColor = strokeColor;
    
    return node;
    
}

@end

@implementation ShadowNode

+ (instancetype)initWithPath:(UIBezierPath *)path
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor{
    
    ShadowNode *node = [ShadowNode new];
    node.path = path;
    node.fillColor = fillColor;
    node.strokeColor = strokeColor;
    
    return node;
    
}


@end

@implementation GradientNode

+ (instancetype)initWithPath:(UIBezierPath *)path{
    
    GradientNode *node = [GradientNode new];
    node.path = path;
    return node;
    
}
@end
