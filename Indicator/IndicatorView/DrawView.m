//
//  DrawView.m
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//

#import "DrawView.h"
#import "BubbleView.h"
@interface DrawView ()

@property (retain ,nonatomic) NSMutableArray *touchArray;

@property (retain ,nonatomic) BubbleView *bubbleView;

@end


@implementation DrawView

- (void)setUpView{
    
    self.backgroundColor = [UIColor clearColor];
   
}

- (void)setNodeArray:(NSMutableArray<DrawNode *> *)nodeArray{
    
    _nodeArray = nodeArray;
    self.bubbleView.hidden = YES;
    
    [self setNeedsDisplay];
}

- (void)setSuperDraw:(BOOL)superDraw{
    
    _superDraw = superDraw;
    
    [self setNeedsDisplay];
}


- (void)layoutSubviews{
    
    self.bubbleView.frame = self.bounds;
    
    if(self.nodeArray.count > 0){
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.superDraw){
        
         [super drawRect:rect];
        
    }else{
        
        
        
        {   CGContextSaveGState(context);
            
            UIBezierPath *path  = [UIBezierPath bezierPathWithRect:rect];
            [[UIColor whiteColor] setFill];
            [path fill];
            
            CGContextRestoreGState(context);
            
        }

    }
    
    if(self.nodeArray.count ==0 || self.nodeArray == nil)return;
    
   
    self.touchArray = @[].mutableCopy;
    
    [self.nodeArray enumerateObjectsUsingBlock:^(DrawNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[TouchNode class]]){
            [self.touchArray addObject:obj];
        }
        
        CGContextSaveGState(context);
        
       
        if([obj isKindOfClass:[TextNode class]]){
            TextNode *node = (TextNode *)obj;
            
            if(node.rotation){
                
                //将绘制原点（0，0）调整到源text的中心
                CGContextConcatCTM(context, CGAffineTransformMakeTranslation(CGRectGetMidX(node.rect),CGRectGetMidY(node.rect)));
                //以绘制原点为中心旋转
                CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_1_PI));
                
                CGRect rect = node.rect;
                rect.origin = CGPointMake(-rect.size.width/2.0, -rect.size.height/2.0);
                
                [node.attrString drawInRect:rect];
            } else {
                
                [node.attrString drawInRect:node.rect];
                
            }
            
            
            
        
        }
        
        
        
        if([obj isKindOfClass:[ImageNode class]]){
            ImageNode *node = (ImageNode *)obj;

            [node.image drawInRect:node.rect];
        }

        if([obj isKindOfClass:[PathNode class]]){
            PathNode *node = (PathNode *)obj;

            if(node.fillColor){

                [node.fillColor setFill];
                [node.path fill];
            }

            if(node.strokeColor){

                [node.strokeColor setStroke];
                [node.path stroke];

            }

        }

        if([obj isKindOfClass:[ShadowNode class]]){
            ShadowNode *node = (ShadowNode *)obj;

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

        if([obj isKindOfClass:[GradientNode class]]){

            GradientNode *node = (GradientNode *)obj;

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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (TouchNode *node in self.touchArray) {
        
        if(CGRectContainsPoint(node.touchRect, point)){
            
            if(!node.isBubble){
                
                [FFRouter routeURL:node.router withParameters:@{@"data":node.associateData}];
                
            }else{
                
                [self.bubbleView fitSize:node.contentSize nodes:node.associateData aimPoint:node.aimPoint];
            }
            
            break;
        }
    }
}


@end
