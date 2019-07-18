//
//  FFDrawView.m
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFDrawView.h"
#import <YYAsyncLayer.h>
@interface FFDrawView ()<YYAsyncLayerDelegate>

@end
@implementation FFDrawView

+ (Class)layerClass{
    
    return [YYAsyncLayer class];
}

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        [self setUpView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self setUpView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        [self setUpView];
    }
    
    return self;
}

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        layer.contentsScale = 2;
    };
    
    __weak typeof(&*self)weakself = self;
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        if (isCancelled()) return;
        if(weakself.nodeArray.count == 0) return;
        [weakself drawInContext:context size:CGRectMake(0, 0, size.width, size.height)];
        
    };
    task.didDisplay = ^(CALayer * _Nonnull layer, BOOL isFinish) {
    };
    return task;
}

- (void)setUpView{
    
    self.backgroundColor = UIColor.clearColor;
    self.displaysAsynchronously = YES;
    
}

- (void)setNodeArray:(NSMutableArray<FFDrawNode *> *)nodeArray{
    
    _nodeArray = nodeArray;
    
    if (self.displaysAsynchronously) {
        
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    } else {
        
        [self contentsNeedUpdated];
    }
    
}

- (void)contentsNeedUpdated{
    
    [self.layer setNeedsDisplay];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.displaysAsynchronously) {
        
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    } else {
        
        [self contentsNeedUpdated];
    }
    
}

- (void)drawInContext:(CGContextRef)context size:(CGRect)rect{
    
    self.touchArray = @[].mutableCopy;
    
    [self.nodeArray enumerateObjectsUsingBlock:^(FFDrawNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[FFTouchNode class]]){
            FFTouchNode *node = (FFTouchNode *)obj;
            [self.touchArray addObject:node];
        }
        
        CGContextSaveGState(context);
        
        
        if([obj isKindOfClass:[FFTextNode class]]){
            FFTextNode *node = (FFTextNode *)obj;
            
            if(node.rotation){
                
                //将绘制原点（0，0）调整到源text的中心
                CGContextConcatCTM(context, CGAffineTransformMakeTranslation(CGRectGetMidX(node.rect),CGRectGetMidY(node.rect)));
                //以绘制原点为中心旋转
                CGContextConcatCTM(context, CGAffineTransformMakeRotation(node.angle));
                
                CGRect rect = node.rect;
                rect.origin = CGPointMake(-rect.size.width/2.0, -rect.size.height/2.0);
                
                NSStringDrawingContext * drawContext = [[NSStringDrawingContext alloc]init];
                
                [node.attrString drawWithRect:rect options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine context:drawContext];
                
            } else {
                
                NSStringDrawingContext * drawContext = [[NSStringDrawingContext alloc]init];
                [node.attrString drawWithRect:rect options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine context:drawContext];
                
            }
        }
        
        
        
        if([obj isKindOfClass:[FFImageNode class]]){
            FFImageNode *node = (FFImageNode *)obj;
            
            [node.image drawInRect:node.rect];
        }
        
        if([obj isKindOfClass:[FFPathNode class]]){
            FFPathNode *node = (FFPathNode *)obj;
            
            if(node.fillColor){
                
                [node.fillColor setFill];
                [node.path fill];
            }
            
            if(node.strokeColor){
                
                [node.strokeColor setStroke];
                [node.path stroke];
                
            }
            
        }
        
        if([obj isKindOfClass:[FFShadowNode class]]){
            FFShadowNode *node = (FFShadowNode *)obj;
            
            CGContextAddPath(context, node.path.CGPath);
            CGContextSetShadow(context,CGSizeZero,10);
            //            CGContextSetShadow(context,CGSizeMake(5, 5),1);
            
            if(node.fillColor){
                CGContextSetFillColorWithColor(context, node.fillColor.CGColor);
                CGContextFillPath(context);
            }
            
            if(node.strokeColor){
                CGContextSetFillColorWithColor(context, node.strokeColor.CGColor);
                CGContextStrokePath(context);
            }
            
        }
        
        if([obj isKindOfClass:[FFGradientNode class]]){
            
            FFGradientNode *node = (FFGradientNode *)obj;
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGFloat locations[] = { 0.0, 1.0 };
            NSArray *colors = @[(__bridge id) node.startColor.CGColor, (__bridge id) node.endColor.CGColor];
            
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
            
            CGContextAddPath(context, node.path.CGPath);
            CGContextClip(context);
            CGContextDrawLinearGradient(context, gradient, node.startPoint, node.endPoint, 0);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);
            
        }
        CGContextRestoreGState(context);
    }];
    
}


@end
