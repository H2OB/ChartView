//
//  FFChartView.m
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFChartView.h"
#import "FFTipsView.h"
#import "FFChartHandle.h"
#import "FFDrawView.h"

@interface FFChartView ()

@property (retain ,nonatomic) FFDrawView *scale1View;//刻度视图1
@property (retain ,nonatomic) FFDrawView *scale2View;//刻度视图2
@property (retain ,nonatomic) UIScrollView *scrollView;
@property (retain ,nonatomic) FFDrawView *contentView;//主内容视图
@property (retain ,nonatomic) FFTipsView *tipsView;
@property (retain ,nonatomic) FFDrawView *descView;//主内容视图

@end
@implementation FFChartView

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

- (void)setUpView{
    
    {
        self.scale1View = [[FFDrawView alloc]init];
        [self addSubview:self.scale1View];
    }
    
    {
        self.scale2View = [[FFDrawView alloc]init];
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
        self.contentView = [[FFDrawView alloc]init];
        [self.scrollView addSubview:self.contentView];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nodeTapAction:)]];
        
        
    }
    
    {
        self.descView = [[FFDrawView alloc]init];
        [self addSubview:self.descView];
    }
    
    
}

- (void)setHandle:(FFChartHandle *)handle{
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
    
    for (FFTouchNode *node in self.contentView.touchArray) {
        
        if(CGRectContainsPoint(node.touchRect, point)){
            hasTouch = YES;
            if(node.touchAction){
                
                node.touchAction(node.idx);
                
            }else{
                
                if(self.tipsView)[self.tipsView hide];
                
                FFDrawView * drawView = [[FFDrawView alloc]init];
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
