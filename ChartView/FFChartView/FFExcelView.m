//
//  FFExcelView.m
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFExcelView.h"
#import "FFExcelHandle.h"
#import "FFDrawView.h"

@interface FFExcelView ()<UIScrollViewDelegate>


@property (assign ,nonatomic) BOOL changeFrame;
@property (retain ,nonatomic) FFDrawView *titleView;
@property (retain ,nonatomic) FFDrawView *headView;
@property (retain ,nonatomic) UIScrollView *scrollView;
@property (retain ,nonatomic) FFDrawView *groupView;
@property (retain ,nonatomic) FFDrawView *contentView;

@end

@implementation FFExcelView

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
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.directionalLockEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
    }
    
    
    {
        self.contentView = [[FFDrawView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.contentView];
    }
    
    
    {
        self.headView = [[FFDrawView alloc]init];
        self.headView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.headView];
    }
    
    {
        self.groupView = [[FFDrawView alloc]init];
        self.groupView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.groupView];
    }
    
    {
        self.titleView = [[FFDrawView alloc]init];
        self.titleView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.titleView];
    }
    
}

- (void)setHandle:(FFExcelHandle *)handle{
    
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
