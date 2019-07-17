//
//  ExcelView.m
//  ChartView
//
//  Created by North on 2019/7/12.
//  Copyright © 2019 North. All rights reserved.
//

#import "ExcelView.h"
#import "ExcelHandle.h"
#import "DrawView.h"

@interface ExcelView ()<UIScrollViewDelegate>


@property (assign ,nonatomic) BOOL changeFrame;
@property (retain ,nonatomic) DrawView *titleView;
@property (retain ,nonatomic) DrawView *headView;
@property (retain ,nonatomic) UIScrollView *scrollView;
@property (retain ,nonatomic) DrawView *groupView;
@property (retain ,nonatomic) DrawView *contentView;

@end

@implementation ExcelView

- (void)setUpView{
    
    {
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.directionalLockEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
    }
    

    {
        self.contentView = [[DrawView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.contentView];
    }
    
    
    {
        self.headView = [[DrawView alloc]init];
        self.headView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.headView];
    }
    
    {
        self.groupView = [[DrawView alloc]init];
        self.groupView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.groupView];
    }
    
    {
        self.titleView = [[DrawView alloc]init];
        self.titleView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.titleView];
    }
    
}

- (void)setHandle:(ExcelHandle *)handle{
    
    _handle = handle;
    self.titleView.nodeArray = self.handle.titleNodes;
    self.headView.nodeArray = self.handle.headNodes;
    self.groupView.nodeArray = self.handle.groupNodes;
    self.contentView.nodeArray = self.handle.contentNodes;
    self.scrollView.contentSize = self.handle.contentSize;
    
    self.changeFrame = YES;
    [self setNeedsLayout];
    
}

- (void)layoutSubviews{
    
    if(self.changeFrame){
        
        self.scrollView.frame = self.handle.scrollviewFrame;
        self.titleView.frame = self.handle.titleFrame;
        self.headView.frame = self.handle.headFrame;
        self.groupView.frame = self.handle.groupFrame;
        self.contentView.frame = self.handle.contentFrame;
        self.changeFrame = NO;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    
    {

        CGRect rect = self.handle.titleFrame;
        rect.origin.x = rect.origin.x + offset.x;
        rect.origin.y = rect.origin.y + offset.y;
        self.titleView.frame = rect;
    }
    
    {
        
        CGRect rect = self.handle.headFrame;
        rect.origin.y = rect.origin.y + offset.y;
        self.headView.frame = rect;
    }
    
    {
        
        CGRect rect = self.handle.groupFrame;
        rect.origin.x = rect.origin.x + offset.x;
        self.groupView.frame = rect;
    }
    
    
    
    
}


@end
