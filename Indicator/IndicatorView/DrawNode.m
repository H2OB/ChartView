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

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size center:(CGPoint)center{
    
    TextNode *node = [TextNode initWithAttrString:attrString rotation:rotation];
    
    CGRect rect = [attrString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    rect.origin.x = center.x - rect.size.width/2.0;
    rect.origin.y = center.y - rect.size.height/2.0;
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
    rect.origin = origin;
    node.rect = rect;
    return node;
}

+ (instancetype)initWithImage:(UIImage *)image
                       center:(CGPoint)center{
    
    ImageNode *node = [ImageNode new];
    node.image = image;
    CGRect rect = CGRectZero;
    rect.size = image.size;
    rect.origin.x = center.x - image.size.width/2.0;
    rect.origin.y = center.y - image.size.height/2.0;
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

@implementation TouchNode

+ (instancetype)initWithTouchRect:(CGRect)touchRect;{
    
    return [TouchNode initWithNodes:nil touchRect:touchRect aimPoint:CGPointZero];
}


+ (instancetype)initWithNodes:(NSArray *)nodesArray
                    touchRect:(CGRect)touchRect
                     aimPoint:(CGPoint)aimPoint{
    
    return [TouchNode initWithNodes:nodesArray touchRect:touchRect aimPoint:aimPoint isBubble:NO];
    
}

+ (instancetype)initWithNodes:(NSArray *)nodesArray
                    touchRect:(CGRect)touchRect
                     aimPoint:(CGPoint)aimPoint
                     isBubble:(BOOL)isBubble{
    
    TouchNode *node = [[TouchNode alloc]init];
    node.nodesArray = nodesArray;
    node.touchRect = touchRect;
    node.aimPoint =aimPoint;
    node.isBubble = isBubble;
    
    return node;
    
}

@end
