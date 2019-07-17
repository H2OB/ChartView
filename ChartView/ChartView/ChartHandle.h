//
//  ChartHandle.h
//  ChartView
//
//  Created by North on 2019/7/1.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, AdaptType) {
    
    AdaptTypeFixedSize = 1 << 0, //在固定尺寸内适应
    AdaptTypeAutoFitSize  = 1 << 1, //根据给定属性适应尺寸
};

typedef NS_OPTIONS(NSUInteger, ScaleLocation) {

    ScaleLocationTop =    1 << 0,  //刻度尺在上边
    ScaleLocationLeft =   1 << 1,  //刻度尺在左边
    ScaleLocationBottom = 1 << 2,  //刻度尺在下边
    ScaleLocationRight =  1 << 3,   //刻度尺在右边
};

typedef NS_OPTIONS(NSUInteger, TextAdaptType) {
    
    TextAdaptTypeAuto =                 1 << 0,    //自适应 用最大文字宽度来做宽度 放不下自动旋转
    TextAdaptTypeFixed =                1 << 1,    //固定宽度  固定文字宽度 多余的文字用...
    TextAdaptTypeFixedRadianRotate =    1 << 2,    //固定角度旋转文字
    TextAdaptTypeFixedRadianWidthRotate =    1 << 2, //同时固定角度长度旋转且文字
};


typedef NS_OPTIONS(NSUInteger, DisplayType) {
    
    DisplayTypeNone   = 1 << 0, //不显示值
    DisplayTypeShow   = 1 << 1,  //全部显示
    DisplayTypeShowLimit = 1 << 2 //显示极限值 -> 最大值最小值
};


typedef NS_OPTIONS(NSUInteger, MutableBarDisplayStyle) {
    
    MutableBarDisplayStyleTiling = 1 << 0,   //平铺 //默认平铺
    MutableBarDisplayStyleStack   = 1 << 1,  //堆叠
    
};


typedef void(^TouchAction)(NSInteger index);


@class ScaleHandle,GroupHandle,TipsHandle,DescHandle;

@interface ChartHandle : NSObject

/**
 适配类型
 */
@property (assign ,nonatomic) AdaptType adaptType;

/**
 最开始初始化的时候给定的尺寸 如果 adaptType = AdaptTypeFixedHeight 那么会和 finalSize 尺寸相等
 */
@property (assign ,nonatomic) CGSize initSize;

/**
 最终尺寸 如果 adaptType = AdaptTypeFixedHeight 那么会和 initSize 尺寸相等
 */
@property (assign ,nonatomic) CGSize finalSize;

@property (copy ,nonatomic) NSString * errorMessage;

@property (retain ,nonatomic) UIFont *errorFont;

@property (retain ,nonatomic) UIColor *errorColor;

@property (copy ,nonatomic) NSString * noneMessage;

@property (retain ,nonatomic) UIFont *noneFont;

@property (retain ,nonatomic) UIColor *noneColor;


///**
// 显示刻度尺
// */
//@property (assign ,nonatomic) BOOL showScale;
//
///**
// 显示分组文字
// */
//@property (assign ,nonatomic) BOOL showGroup;
//
//
//@property (assign ,nonatomic)  showGroup;


#pragma mark - 下列属性不允许调用

@property (assign ,nonatomic) CGRect scale1Frame;

@property (assign ,nonatomic) CGRect scale2Frame;

@property (retain ,nonatomic) NSMutableArray *scale1Nodes;

@property (retain ,nonatomic) NSMutableArray *scale2Nodes;

@property (assign ,nonatomic) CGRect contentFrame;

@property (assign ,nonatomic) CGSize contentSize;

@property (retain ,nonatomic) NSMutableArray *contentNodes;

@property (assign ,nonatomic) CGRect descFrame;

@property (retain ,nonatomic) NSMutableArray *descNodes;

#pragma mark - init

+ (instancetype)initWithAdaptType:(AdaptType)adaptType initSize:(CGSize)initSize;

- (instancetype)initWithAdaptType:(AdaptType)adaptType initSize:(CGSize)initSize;

#pragma mark - 设置刻度尺


- (void)appendScaleHandle:(ScaleHandle *)handle;

- (void)configGroupHandle:(GroupHandle *)handle;

- (void)configTipsHandle:(TipsHandle *)handle;

- (void)configDescHandle:(DescHandle *)handle;

#pragma mark - 开始计算
- (void)beginCalculate;

@end




@class GroupHandle , BarHandle ,LineHandle;

/**
 刻度尺
 */
@interface ScaleHandle : NSObject

/**
 刻度尺显示位置 默认刻度尺在左边
 */
@property (assign ,nonatomic) ScaleLocation location;

/**
 刻度尺文字适应类型
 */
@property (assign ,nonatomic) TextAdaptType adapeType;

/**
 是否显示刻度尺
 */
@property (assign ,nonatomic) DisplayType displayType;

/**
 是否显示刻度线
 */
@property (assign ,nonatomic) DisplayType lineDisplayType;

/**
 刻度上的文字颜色
 */
@property (retain ,nonatomic) UIColor * textColor;

/**
 刻度上的文字字体
 */
@property (retain ,nonatomic) UIFont  * textFont;

/**
 刻度线颜色
 */
@property (retain ,nonatomic) UIColor * lineColor;

/**
 刻度线颜色
 */
@property (assign ,nonatomic) CGFloat  lineWidth;

/**
 分割线颜色
 */
@property (retain ,nonatomic) UIColor * separatorColor;

/**
 分割线颜色
 */
@property (assign ,nonatomic) CGFloat  separatorWidth;


/**
 基准线颜色
 */
@property (retain ,nonatomic) UIColor * datumColor;

/**
  基准线宽度
 */
@property (assign ,nonatomic) CGFloat  datumWidth;

/**
 基准线值
 */
@property (assign ,nonatomic) CGFloat  datumValue;//datum


/**
 基准线文字颜色
 */
@property (retain ,nonatomic) UIColor * datumTextColor;

/**
 基准线文字字体
 */
@property (retain ,nonatomic) UIFont  * datumTextFont;



/**
 刻度文字旋转角度
 */
@property (assign ,nonatomic) CGFloat radian;

/**
 刻度线之间的间距
 */
@property (assign ,nonatomic) CGFloat spacing;

/**
 刻度文字宽度
 */
@property (assign ,nonatomic) CGFloat textWidth;

/**
 刻度个数
 */
@property (assign ,nonatomic) NSUInteger scaleNum;

/**
 单位
 */
@property (copy ,nonatomic) NSString * unit;

/**
 小数点位数
 */
@property (assign ,nonatomic) NSUInteger decimals;

/**
 多个bar之间的间距
 */
@property (assign ,nonatomic) CGFloat barSpeace;

/**
 柱状图显示方式  默认平铺
 */
@property (assign ,nonatomic) MutableBarDisplayStyle barStyle;

/**
 文字跟点/bar之家的距离
 */
@property (assign ,nonatomic) CGFloat valueSpeace;



/**
 多个bar 加上间距 的宽度总和
 */
@property (assign ,nonatomic) CGFloat totalBarWdith;
/**
 文本最大宽度
 */
@property (assign ,nonatomic) CGFloat textMaxWidth;

/**
 文本最大宽度
 */
@property (assign ,nonatomic) CGFloat textMaxHeight;


/**
 文本最最终宽度
 */
@property (assign ,nonatomic) CGFloat textFinalWdith;

/**
 文本最终宽度
 */
@property (assign ,nonatomic) CGFloat textFinalHeight;

/**
 最大值
 */
@property (assign ,nonatomic) double maxScaleValue;

/**
 最小值
 */
@property (assign ,nonatomic) double minScaleValue;


//每一段刻度的平均值
@property (assign ,nonatomic) double scaleAverage;


@property (assign ,nonatomic) double averageValue;

/**
 line/bar文本最最大宽度
 */
@property (assign ,nonatomic) CGFloat subTextMaxWdith;

/**
 line/bar文本最最大高度
 */
@property (assign ,nonatomic) CGFloat subTextMaxHeight;

/**
 显示值对应的文本
 */
@property (assign ,nonatomic) DisplayType subTextDisplay;


@property (retain ,nonatomic) GroupHandle *groupHandle;

@property (readonly ,nonatomic) NSMutableArray <BarHandle *> *barArray;

@property (readonly ,nonatomic) NSMutableArray <LineHandle *> *lineArray;

- (void)beginCalculate;

- (void)fitFinalSizeWithSpeacing:(CGFloat)speacing;

@end

/**
group属性设置
 */
@interface GroupHandle : NSObject

/**
 标题 这个只跟Excel有关，统计图u不需要设置
 */
@property (copy ,nonatomic) NSString * title;

/**
 显示还是不显示
 */
@property (assign ,nonatomic) DisplayType displayType;

/**
 是否显示刻度线
 */
@property (assign ,nonatomic) DisplayType lineDisplayType;


/**
 每一组数据的对应的文字的颜色
 */
@property (retain ,nonatomic) UIColor * textColor;

/**
 每一组数据的对应的文字的字体
 */
@property (retain ,nonatomic) UIFont  * textFont;

/**
 每一组数据的对应的文字适应类型
 */
@property (assign ,nonatomic) TextAdaptType adapeType;

/**
 组文字之间的间距
 */
@property (assign ,nonatomic) CGFloat spacing;

/**
 组文字宽度
 */
@property (assign ,nonatomic) CGFloat textWidth;

/**
 分割线颜色
 */
@property (retain ,nonatomic) UIColor * separatorColor;

/**
 分割线颜色
 */
@property (assign ,nonatomic) CGFloat  separatorWidth;

/**
 屏幕中能显示数量
 */
@property (assign ,nonatomic) NSInteger groupNum;

@property (assign ,nonatomic) CGFloat radian;

/**
 文本最大宽度
 */
@property (assign ,nonatomic) CGFloat textMaxWidth;

/**
 文本最大宽度
 */
@property (assign ,nonatomic) CGFloat textMaxHeight;

/**
 文本最最终宽度
 */
@property (assign ,nonatomic) CGFloat textFinalWdith;

/**
 文本最终宽度
 */
@property (assign ,nonatomic) CGFloat textFinalHeight;


@property (retain ,nonatomic) NSMutableArray *textArray;

- (void)beginCalculate;

- (void)fitFinalSizeWithSpeacing:(CGFloat)speacing;

@end

/**
 值
 */
@interface NodeHandle : NSObject

/**
 最大值
 */
@property (assign ,nonatomic) double maxValue;

/**
 最小值
 */
@property (assign ,nonatomic) double minValue;


@property (weak ,nonatomic) ScaleHandle * scale;

/**
 值对应的文字的颜色
 */
@property (retain ,nonatomic) UIColor * textColor;

/**
 值对应的文字的字体
 */
@property (retain ,nonatomic) UIFont  * textFont;

/**
 是否显示值
 */
@property (assign ,nonatomic) DisplayType displayType;


/**
 对应值数组
 */
@property (retain ,nonatomic) NSMutableArray *valueArray;

/**
 单位
 */
@property (copy ,nonatomic) NSString * unit;

/**
 小数点位数
 */
@property (assign ,nonatomic) NSUInteger decimals;

/**
 分类文字
 */
@property (copy ,nonatomic) NSString *descString;

/**
 主要颜色
 */
@property (retain ,nonatomic) UIColor * themeColor;

@end

/**
 柱状图
 */
@interface BarHandle : NodeHandle


@property (assign ,nonatomic) NSInteger index;

/**
 纯色的填充色
 */
@property (retain ,nonatomic) UIColor *fillColor;


/**
 渐变起点颜色
 */
@property (retain ,nonatomic) UIColor *startColor;

/**
 渐变终点颜色
 */
@property (retain ,nonatomic) UIColor *endColor;

/**
 bar宽度
 */
@property (assign ,nonatomic) CGFloat barWidth;

/**
 bar与bar 之间的间隔
 */
@property (assign ,nonatomic) CGFloat spacing;


@end


@class GradientNode,PathNode;

/**
 折线图
 */
@interface LineHandle : NodeHandle


/**
 折线颜色
 */
@property (retain ,nonatomic) UIColor *lineColor;

/**
 点颜色
 */
@property (retain ,nonatomic) UIColor *pointColor;


/**
 点内部半径
 */
@property (assign ,nonatomic) CGFloat insideRadius;

/**
 点外部半径
 */
@property (assign ,nonatomic) CGFloat outsideRadius;

/**
 点内部半径
 */
@property (retain ,nonatomic) UIColor * insideColor;

/**
 点外部半径
 */
@property (assign ,nonatomic) UIColor * outsideColor;

/**
 线宽度
 */
@property (assign ,nonatomic) CGFloat lineWidth;


@property (assign ,nonatomic) BOOL Smooth;

@property (assign ,nonatomic) BOOL closeArea;


@property (retain ,nonatomic) UIColor *areaStartColor;


@property (retain ,nonatomic) UIColor *areaEndColor;


@property (retain ,nonatomic) NSMutableArray * pointArray;

- (PathNode *)lineNode;


@end


@interface TipsHandle : NSObject

/**
 每一组数据的对应的文字的颜色
 */
@property (retain ,nonatomic) UIColor * groupTextColor;

/**
 每一组数据的对应的文字的字体
 */
@property (retain ,nonatomic) UIFont  * groupTextFont;


/**
 值对应的文字的颜色
 */
@property (retain ,nonatomic) UIColor * valueTextColor;

/**
 值对应的文字的字体
 */
@property (retain ,nonatomic) UIFont  * valueTextFont;

/**
 颜色的宽度
 */
@property (assign ,nonatomic) CGFloat colorWidth;

/**
 颜色的圆角
 */
@property (assign ,nonatomic) CGFloat colorRadius;

/**
 颜色跟文字之间的间距
 */
@property (assign ,nonatomic) CGFloat xSpecing;

/**
 不同的值之间的兼顾
 */
@property (assign ,nonatomic) CGFloat ySpecing;

/**
 优先箭头指向
 */
@property (assign ,nonatomic) BOOL firstRight;


@property (copy ,nonatomic) TouchAction touchAction;



@end

@interface DescHandle : NSObject

@property (assign ,nonatomic) CGFloat topSpeace;

@property (assign ,nonatomic) CGFloat midSpeace;

@property (assign ,nonatomic) CGFloat bottomSpeace;

@property (assign ,nonatomic) NSUInteger rouNum;

/**
文字的颜色
 */
@property (retain ,nonatomic) UIColor * textColor;

/**
文字的字体
 */
@property (retain ,nonatomic) UIFont  * textFont;

/**
 颜色的宽度
 */
@property (assign ,nonatomic) CGFloat colorWidth;

/**
 颜色的圆角
 */
@property (assign ,nonatomic) CGFloat colorRadius;

/**
 文字跟颜色之间的间距
 */
@property (assign ,nonatomic) CGFloat colorTextSpeace;

/**
 不同描述之间的间隔
 */
@property (assign ,nonatomic) CGFloat nodeSpeace;

@end;


@interface CircleHandle : NSObject


/**
 图形距离左边的记录
 */
@property (assign ,nonatomic) CGFloat circleLeft;

/**
 最大半径
 */
@property (assign ,nonatomic) CGFloat maxRadiu;






@end

