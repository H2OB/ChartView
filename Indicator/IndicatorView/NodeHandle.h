//
//  NodeHandle.h
//  Indicator
//
//  Created by North on 2019/6/10.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawNode.h"


/**
 刻度尺方向
 */
typedef NS_OPTIONS(NSUInteger, ScaleDirection) {
    
    ScaleDirectionNone       = 1 << 0, //没有刻度尺 默认
    ScaleDirectionLeft       = 1 << 1, //刻度尺在左边
    ScaleDirectionBottom     = 1 << 2  //刻度尺在底部
};

typedef NS_OPTIONS(NSUInteger, ChartType) {
    
    ChartTypeLine       = 1 << 0, //默认折线图
    ChartTypeBar        = 1 << 1,  //柱状图
    ChartTypeBarAll     = 1 << 2  //连个结合
};


@interface NodeHandle : NSObject

@property (retain ,nonatomic) NSMutableArray *scaleNodes;
@property (retain ,nonatomic) NSMutableArray *contentNodes;
@property (retain ,nonatomic) NSMutableArray *otherNodes;

@property (assign ,nonatomic) CGRect scaleFrame;
@property (assign ,nonatomic) CGRect contentFrame;
@property (assign ,nonatomic) CGSize contentSize;
@property (assign ,nonatomic) CGRect otherFrame;


/**
 获取饼状图节点

 @return 节点数组
 */
- (NSMutableArray *)nodeFromPie;
/**
 获取封闭环状节点
 
 @return 节点数组
 */
- (NSMutableArray *)nodeFromCloseLoop;
/**
 获取开口环状节点
 
 @return 节点数组
 */
- (NSMutableArray *)nodeFromOpenLoop;

/**
 获取则线图

 @return 节点数组
 */
+ (NodeHandle *)nodeFromLine;

/**
 获取柱状图

 @return handle
 */
+ (NodeHandle *)nodeFromBar;

@end


