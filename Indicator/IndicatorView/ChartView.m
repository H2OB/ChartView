//
//  ChartView.m
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//

#import "ChartView.h"

@interface ChartView ()

@property (retain ,nonatomic) DrawView *scaleView;//标尺视图
@property (retain ,nonatomic) DrawView *otherScaleView;//标尺视图
@property (retain ,nonatomic) UIScrollView *scrollView;
@property (retain ,nonatomic) DrawView *contentView;//主内容视图
@property (retain ,nonatomic) DrawView *otherView; //其他视图


@end

@implementation ChartView

- (void)setUpView{
    
    self.otherView = [DrawView new];
    [self addSubview:self.otherView];
    
    self.otherScaleView = [DrawView new];
    [self addSubview:self.otherScaleView];
    
    
    self.scaleView = [DrawView new];
    self.scaleView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scaleView];
    
    self.scrollView = [UIScrollView new];
    self.scaleView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    self.contentView = [DrawView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contentView];

    
    
}

- (void)setHandle:(NodeHandle *)handle{
    
    _handle = handle;
    
    self.scaleView.nodeArray = _handle.scaleNodes;
    self.otherScaleView.nodeArray = _handle.otherScaleNodes;
    self.contentView.nodeArray = _handle.contentNodes;
    self.otherView.nodeArray = _handle.otherNodes;
    
    [self setNeedsLayout];
    
}

- (void)layoutSubviews{
    
    self.scaleView.frame = self.handle.scaleFrame;
    self.otherScaleView.frame = self.handle.otherScaleFrame;
    self.scrollView.frame = self.handle.contentFrame;
    self.scrollView.contentSize = self.handle.contentSize;
    self.contentView.frame = CGRectMake(0, 0, self.handle.contentSize.width, self.handle.contentSize.height);
    self.otherView.frame = self.handle.otherFrame;
    
}


@end
