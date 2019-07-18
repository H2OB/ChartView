//
//  FFDrawNode.m
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFDrawNode.h"

@implementation FFDrawNode

@end

@implementation FFTextNode

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation{
    
    FFTextNode *node = [FFTextNode new];
    node.attrString = attrString;
    node.rotation = rotation;
    node.angle = rotation ?M_1_PI :0;
    return node;
}

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size origin:(CGPoint)origin{
    
    FFTextNode *node = [FFTextNode initWithAttrString:attrString rotation:rotation];
    
    CGRect rect = [attrString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    rect.origin =origin;
    
    node.rect = rect;
    
    return node;
    
}

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString rotation:(BOOL)rotation size:(CGSize)size center:(CGPoint)center{
    
    FFTextNode *node = [FFTextNode initWithAttrString:attrString rotation:rotation];
    
    CGRect rect = [attrString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    rect.origin.x = center.x - rect.size.width/2.0;
    rect.origin.y = center.y - rect.size.height/2.0;
    node.rect = rect;
    
    return node;
    
}

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString angle:(CGFloat)angle size:(CGSize)size origin:(CGPoint)origin{
    
    FFTextNode *node = [FFTextNode initWithAttrString:attrString rotation:YES size:size origin:origin];
    node.angle = angle;
    return node;
    
}

+ (instancetype)initWithAttrString:(NSMutableAttributedString *)attrString angle:(CGFloat)angle size:(CGSize)size center:(CGPoint)center{
    
    FFTextNode *node = [FFTextNode initWithAttrString:attrString rotation:YES size:size center:center];
    node.angle = angle;
    return node;
    
}

@end

@implementation FFImageNode

+ (instancetype)initWithImage:(UIImage *)image origin:(CGPoint)origin{
    
    FFImageNode *node = [FFImageNode new];
    node.image = image;
    CGRect rect = CGRectZero;
    rect.size = image.size;
    rect.origin = origin;
    node.rect = rect;
    return node;
}

+ (instancetype)initWithImage:(UIImage *)image
                       center:(CGPoint)center{
    
    FFImageNode *node = [FFImageNode new];
    node.image = image;
    CGRect rect = CGRectZero;
    rect.size = image.size;
    rect.origin.x = center.x - image.size.width/2.0;
    rect.origin.y = center.y - image.size.height/2.0;
    node.rect = rect;
    
    return node;
}

@end

@implementation FFPathNode

+ (instancetype)initWithPath:(UIBezierPath *)path
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor{
    
    FFPathNode *node = [FFPathNode new];
    node.path = path;
    node.fillColor = fillColor;
    node.strokeColor = strokeColor;
    
    return node;
    
}

@end

@implementation FFShadowNode

+ (instancetype)initWithPath:(UIBezierPath *)path
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor{
    
    FFShadowNode *node = [FFShadowNode new];
    node.path = path;
    node.fillColor = fillColor;
    node.strokeColor = strokeColor;
    
    return node;
    
}


@end

@implementation FFGradientNode

+ (instancetype)initWithPath:(UIBezierPath *)path{
    
    FFGradientNode *node = [FFGradientNode new];
    node.path = path;
    return node;
    
}
@end

@implementation FFTouchNode

+ (instancetype)initWithTouchRect:(CGRect)touchRect;{
    
    return [FFTouchNode initWithNodes:nil touchRect:touchRect aimPoint:CGPointZero];
}

+ (instancetype)initWithNodes:(NSArray *)nodesArray
                    touchRect:(CGRect)touchRect
                     aimPoint:(CGPoint)aimPoint{
    
    FFTouchNode *node = [[FFTouchNode alloc]init];
    
    if(self){
        
        node.nodesArray = nodesArray;
        node.touchRect = touchRect;
        node.aimPoint = aimPoint;
    }
    
    return node;
}


@end
