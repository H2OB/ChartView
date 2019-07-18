//
//  FFExcelHandle.h
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FFRowHandle,FFDrawNode;

@interface FFExcelHandle : NSObject

@property (assign ,nonatomic) CGSize   initSize;

@property (assign ,nonatomic) CGSize   finalSize;

/**
 文字宽度 只适应传 CGFLOAT_MAX
 */
@property (assign ,nonatomic) CGFloat titleWidth;

@property (assign ,nonatomic) CGFloat titleHeight;

/**
 一屏幕显示行数
 */
@property (assign ,nonatomic) CGFloat visibleRowNum;

/**
 一屏幕显示列数
 */
@property (assign ,nonatomic) CGFloat visibleColumnNum;

/**
 每一行高度
 */
@property (assign ,nonatomic) CGFloat rowHeight;

/**
 分割线颜色
 */
@property (retain ,nonatomic) UIColor * separatorColor;

/**
 分割线颜色
 */
@property (assign ,nonatomic) CGFloat  separatorWidth;

/**
 边框颜色
 */
@property (retain ,nonatomic) UIColor * borderColor;

/**
 边框宽度
 */
@property (assign ,nonatomic) CGFloat  borderWidth;

@property (assign ,nonatomic) CGFloat  titleValueSpeace;

@property (assign ,nonatomic) CGFloat  valueSpeace;


@property (retain ,nonatomic) NSMutableArray <FFRowHandle *> * rowArray;

@property (assign ,nonatomic) CGRect   scrollviewFrame;

@property (assign ,nonatomic) CGRect   headFrame;

@property (assign ,nonatomic) CGRect   titleFrame;

@property (assign ,nonatomic) CGRect   groupFrame;

@property (assign ,nonatomic) CGSize   contentSize;

@property (assign ,nonatomic) CGRect   contentFrame;

@property (retain ,nonatomic) NSMutableArray <FFDrawNode *> * titleNodes;

@property (retain ,nonatomic) NSMutableArray <FFDrawNode *> * headNodes;

@property (retain ,nonatomic) NSMutableArray <FFDrawNode *> * groupNodes;

@property (retain ,nonatomic) NSMutableArray <FFDrawNode *> * contentNodes;

- (void)configHeadHandele:(FFRowHandle *)handle;

- (void)beginCalculate;

- (instancetype)initWithInitSize:(CGSize)size;


@end


/**
 表格
 */
@interface FFRowHandle : NSObject


@property (copy ,nonatomic) NSString * title;

@property (assign ,nonatomic) NSTextAlignment  titleTextAlignment;

@property (assign ,nonatomic) NSTextAlignment  valueTextAlignment;


/**
 分割线颜色
 */
@property (retain ,nonatomic) UIColor * separatorColor;

/**
 分割线颜色
 */
@property (assign ,nonatomic) CGFloat  separatorWidth;

/**
 文字字体
 */
@property (retain ,nonatomic) UIFont * textFont;
/**
 文字颜色
 */
@property (retain ,nonatomic) UIColor * textColor;
/**
 title字体
 */
@property (retain ,nonatomic) UIFont * titleFont;
/**
 title颜色
 */
@property (retain ,nonatomic) UIColor * titleColor;

/**
 背景颜色
 */
@property (retain ,nonatomic) UIColor * backgroudColor;


@property (assign ,nonatomic) CGFloat verticalMagin;


@property (retain ,nonatomic) NSMutableArray <NSString *> * valueArray;



@end


