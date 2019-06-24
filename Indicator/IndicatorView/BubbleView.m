//
//  BubbleView.m
//  OneApp
//
//  Created by North on 2019/6/17.
//  Copyright © 2019 North. All rights reserved.
//

#import "BubbleView.h"
#import "DrawView.h"

@interface BubbleView ()

{
    NSArray *nodeArray;
    UIEdgeInsets maginEdge;
    CGFloat width ,height;
    CGFloat bubbleHeight , bubbleWidht;//三角形高度/宽度
    DrawView *drawView;
    CAShapeLayer *shapeLayer;
    
    CGFloat maginSpeace;//气泡距离上下左右的距离

}

@end


@implementation BubbleView


- (void)setUpView{
    
    self.backgroundColor = [UIColor clearColor];
    shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor;
    [self.layer addSublayer:shapeLayer];
    
    
    maginEdge = UIEdgeInsetsMake(5, 5, 5, 5);
    drawView = [DrawView new];
    drawView.backgroundColor = [UIColor clearColor];
    drawView.superDraw = YES;
    bubbleHeight = 5;
    maginSpeace = 5;
    bubbleWidht = 10;

    [self addSubview:drawView];

}


- (void)fitSize:(CGSize)size nodes:(NSArray *)nodes aimPoint:(CGPoint)point{
    
    drawView.nodeArray = nodes.mutableCopy;
    
    
    
    
}


@end
