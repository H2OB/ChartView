//
//  ChartView.m
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//

#import "ChartView.h"
#import "FFTipsView.h"
#import "ChartHandle.h"

@interface ChartView ()

@property (retain ,nonatomic) DrawView *scale1View;//刻度视图1
@property (retain ,nonatomic) DrawView *scale2View;//刻度视图2
@property (retain ,nonatomic) UIScrollView *scrollView;
@property (retain ,nonatomic) DrawView *contentView;//主内容视图
@property (retain ,nonatomic) FFTipsView *tipsView;
@property (retain ,nonatomic) DrawView *descView;//主内容视图

@end

@implementation ChartView

- (void)setUpView{
    
    {
        self.scale1View = [[DrawView alloc]init];
        [self addSubview:self.scale1View];
    }
    
    {
        self.scale2View = [[DrawView alloc]init];
        [self addSubview:self.scale2View];
    }
    
    {
        
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.bounces = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.directionalLockEnabled = YES;
        [self addSubview:self.scrollView];
        
    }
    
    {
        self.contentView = [[DrawView alloc]init];
        [self.scrollView addSubview:self.contentView];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nodeTapAction:)]];
        
        
    }
    
    {
        self.descView = [[DrawView alloc]init];
        [self addSubview:self.descView];
    }
    
    
}

- (void)setHandle:(ChartHandle *)handle{
    _handle = handle;
    
    self.scale1View.nodeArray = _handle.scale1Nodes;
    self.scale2View.nodeArray = _handle.scale2Nodes;
    self.contentView.nodeArray = _handle.contentNodes;
    self.descView.nodeArray = _handle.descNodes;
    
    [self setNeedsLayout];
}

- (void)nodeTapAction:(UITapGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:self.scrollView];
    
    BOOL hasTouch = NO;
    
    for (TouchNode *node in self.contentView.touchArray) {
        
        if(CGRectContainsPoint(node.touchRect, point)){
            hasTouch = YES;
            if(node.touchAction){
    
                node.touchAction(node.idx);
                
            }else{
                
                if(self.tipsView)[self.tipsView hide];
                
                DrawView * drawView = [[DrawView alloc]init];
                drawView.displaysAsynchronously = NO;
                CGRect frame = CGRectZero;
                frame.size = node.contentSize;
                drawView.frame = frame;
                drawView.nodeArray = node.nodesArray.mutableCopy;
                
                
                FFTipsView *tipsView = [[FFTipsView alloc]initWithContentView:drawView inView:self.scrollView];
                
                if(node.isRignt) tipsView.arrowDirection = FFArrowDirectionLeft;
                
                [tipsView showOnPoint:node.aimPoint];
                
                self.tipsView = tipsView;
                
            }
            
            break;
        }
    }
    
    if(!hasTouch && self.contentView.touchArray.count > 0){
        
        if(self.tipsView)[self.tipsView hide];
    }
    
}


- (void)layoutSubviews{
    
    self.scale1View.frame = self.handle.scale1Frame;
    self.scale2View.frame = self.handle.scale2Frame;
    self.scrollView.frame = self.handle.contentFrame;
    self.scrollView.contentSize = self.handle.contentSize;
    self.contentView.frame = CGRectMake(0, 0, self.handle.contentSize.width, self.handle.contentSize.height);
    self.descView.frame = self.handle.descFrame;
}



@end
