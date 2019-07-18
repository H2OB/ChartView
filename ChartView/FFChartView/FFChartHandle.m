//
//  FFChartHandle.m
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFChartHandle.h"
#import "NSMutableAttributedString+Helper.h"
#import "NSNumber+Helper.h"
#import "FFDrawNode.h"

#define MAXSIZE CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)

//计算两点间的弧度
NS_INLINE CGFloat radianBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = second.x - first.x;
    CGFloat rads = atan(height/width);
    return rads;
}

//通过中心店 弧度 半径计算 某弧度上的点坐标
NS_INLINE CGPoint calcPointFromCenter(CGPoint center,CGFloat radian,CGFloat radius){
    
    CGPoint point = CGPointZero;
    point.x = radius * cosf(radian) + center.x;
    point.y = radius * sinf(radian) + center.y;
    return point;
}


NS_INLINE CGFloat PixWidth(CGFloat width){
    
    return width/[UIScreen mainScreen].scale;
}

@interface FFChartHandle ()

@property (retain ,nonatomic) ScaleHandle * scaleHandle1;
@property (retain ,nonatomic) ScaleHandle * scaleHandle2;
@property (retain ,nonatomic) GroupHandle * groupHandle;
@property (retain ,nonatomic) DescHandle *  descHandle;
@property (retain ,nonatomic) TipsHandle *  tipsHandle;

@end

@implementation FFChartHandle

- (instancetype)initWithAdaptType:(AdaptType)adaptType initSize:(CGSize)initSize{
    
    self = [super init];
    
    if(self){
        
        self.adaptType = adaptType;
        self.initSize = initSize;
        self.contentNodes = @[].mutableCopy;
        self.scale1Nodes = @[].mutableCopy;
        self.scale2Nodes = @[].mutableCopy;
        self.descNodes = @[].mutableCopy;
        
    }
    return self;
    
}

+ (instancetype)initWithAdaptType:(AdaptType)adaptType initSize:(CGSize)initSize{
    
    return [[FFChartHandle alloc]initWithAdaptType:adaptType initSize:initSize];
}


- (void)configScaleHandle1:(ScaleHandle *)handle{
    
    self.scaleHandle1 = handle;
    [self.scaleHandle1 beginCalculate];
    
}

- (void)configScaleHandle2:(ScaleHandle *)handle{
    
    self.scaleHandle2 = handle;
    [self.scaleHandle2 beginCalculate];
    
}

- (void)configGroupHandle:(GroupHandle *)handle{
    
    self.groupHandle = handle;
}

- (void)appendScaleHandle:(ScaleHandle *)handle{
    
    if(!self.scaleHandle1){
        self.scaleHandle1 = handle;
    }
    else if(!self.scaleHandle2){
        self.scaleHandle2 = handle;
        
    }
}

- (void)configTipsHandle:(TipsHandle *)handle{
    
    self.tipsHandle = handle;
}

- (void)configDescHandle:(DescHandle *)handle{
    
    self.descHandle = handle;
}

- (void)beginCalculate{
    
    if (self.scaleHandle1 || self.scaleHandle2) [self calculateBarOrLine];
    else [self setNoneView];
    
}

- (void)calculateBarOrLine{
    
    
    CGRect scale1Frame = CGRectZero;
    CGRect scale2Frame = CGRectZero;
    CGRect contentFrame = CGRectZero;
    CGSize contentSize  = CGSizeZero;
    CGRect descFrame  = CGRectZero;
    
    NSMutableArray * barArray = @[].mutableCopy;
    NSMutableArray * valueTextArray = @[].mutableCopy;
    NSMutableArray * pointArray = @[].mutableCopy;
    NSMutableArray * groupTextArray = @[].mutableCopy;
    NSMutableArray * lineArray = @[].mutableCopy;
    NSMutableArray * areaArray = @[].mutableCopy;
    
    //如果两边的刻度线数量不相同 取最大的刻度线数量
    NSInteger scaleNum = MAX(self.scaleHandle1.scaleNum, self.scaleHandle2.scaleNum);
    
    if(self.scaleHandle1.scaleNum != self.scaleHandle2.scaleNum){
        
        self.scaleHandle1.scaleAverage = (self.scaleHandle1.maxScaleValue - self.scaleHandle1.minScaleValue)/scaleNum;
        self.scaleHandle2.scaleAverage = (self.scaleHandle2.maxScaleValue - self.scaleHandle2.minScaleValue)/scaleNum;
    }
    
    
    CGFloat barSpeace = self.scaleHandle2 ? MIN(self.scaleHandle1.barSpeace, self.scaleHandle2.barSpeace) : self.scaleHandle1.barSpeace;
    
    //一屏幕显示多少分组数据
    NSUInteger groupNum = self.groupHandle.textArray.count > self.groupHandle.groupNum ? self.groupHandle.groupNum :  self.groupHandle.textArray.count;
    
    //刻度尺显示
    
    BOOL showScale = NO;
    BOOL showScaleLine = NO;
    if(self.scaleHandle1 && !self.scaleHandle2){
        
        showScale = self.scaleHandle1.displayType == DisplayTypeShow;
        showScaleLine = self.scaleHandle1.lineDisplayType == DisplayTypeShow;
        
        [self.scaleHandle1 beginCalculate];
        
    }else if(self.scaleHandle1 && self.scaleHandle2){
        
        showScale = YES;
        showScaleLine = YES;
        self.scaleHandle1.displayType = DisplayTypeShow;
        self.scaleHandle2.displayType = DisplayTypeShow;
        [self.scaleHandle1 beginCalculate];
        [self.scaleHandle2 beginCalculate];
    }
    
    //
    
    [self.groupHandle beginCalculate];
    
    
    
    NSMutableArray *nodeArray = @[].mutableCopy;
    if(self.scaleHandle1.barArray) [nodeArray addObjectsFromArray:self.scaleHandle1.barArray];
    if(self.scaleHandle1.lineArray) [nodeArray addObjectsFromArray:self.scaleHandle1.lineArray];
    if(self.scaleHandle2.barArray) [nodeArray addObjectsFromArray:self.scaleHandle2.lineArray];
    if(self.scaleHandle2.lineArray) [nodeArray addObjectsFromArray:self.scaleHandle2.lineArray];
    
    BOOL isMutalbe = nodeArray.count > 1;//有多个bar/line
    
    CGFloat descHeight = 0;
    
    if(isMutalbe && self.descHandle){
        
        NSInteger row = (nodeArray.count + (self.descHandle.rouNum -1))/self.descHandle.rouNum;
        descHeight = (row - 1) * self.descHandle.midSpeace + self.descHandle.textFont.lineHeight *row + self.descHandle.topSpeace + self.descHandle.bottomSpeace;
        descFrame.size = CGSizeMake(self.initSize.width, descHeight);
    }
    
    NSInteger totalBarNum = self.scaleHandle1.barArray.count + self.scaleHandle2.barArray.count;
    CGFloat totalBarSpeace = self.scaleHandle1.barStyle == MutableBarDisplayStyleTiling ? (totalBarNum - 1) * barSpeace : 0;
    CGFloat totalBarWidth = totalBarNum > 0 ? self.scaleHandle1.totalBarWdith + self.scaleHandle2.totalBarWdith + totalBarSpeace : 0;
    
    
    //文本显示
    
#pragma mark - 刻度尺在左方/右方
    if( self.scaleHandle1.location == ScaleLocationLeft
       || self.scaleHandle1.location == ScaleLocationRight){
        
        
        
        CGFloat maxScaleHeight = fmaxf(self.scaleHandle1.subTextMaxHeight, self.scaleHandle2.subTextMaxHeight);
        
        CGFloat maxValueSpeace = fmaxf(self.scaleHandle1.valueSpeace, self.scaleHandle2.valueSpeace);
        
        CGFloat maxSpacing = fmaxf(self.scaleHandle1.spacing, self.scaleHandle2.spacing);
        
        //最终绘制宽度
        CGFloat finalWidth = self.initSize.width - self.scaleHandle1.textFinalWdith - self.scaleHandle2.textFinalWdith;
        //平均长度
        CGFloat groupSpecing = finalWidth/ groupNum;
        
        contentSize = CGSizeMake(groupSpecing * self.groupHandle.textArray.count, self.initSize.height);
        
        [self.groupHandle fitFinalSizeWithSpeacing:groupSpecing];
        
        
        if(self.adaptType == AdaptTypeAutoFitSize){
            
            CGSize size = self.initSize;
            size.height = scaleNum * maxSpacing + maxValueSpeace + maxScaleHeight + self.groupHandle.textFinalHeight + descHeight;
            
            self.finalSize = size;
        }else {
            
            self.finalSize = self.initSize;
        }
        
        
        //通过 scaleHandle的固定值来算高度
        contentFrame.size = CGSizeMake(finalWidth, self.finalSize.height - descHeight);
        contentSize.height = self.finalSize.height - descHeight;
        
        if(self.scaleHandle1.location == ScaleLocationLeft){
            
            scale1Frame.origin = CGPointZero;
            scale1Frame.size = CGSizeMake(self.scaleHandle1.textFinalWdith, self.finalSize.height - descHeight);
            
            contentFrame.origin = CGPointMake(CGRectGetMaxX(scale1Frame), 0);
            
            scale2Frame.origin = CGPointMake(CGRectGetMaxX(contentFrame), 0);
            scale2Frame.size = CGSizeMake(self.scaleHandle2.textFinalWdith, self.finalSize.height - descHeight);
            
            descFrame.origin = CGPointMake(0, CGRectGetMaxY(scale2Frame));
            
            
        }
        
        if(self.scaleHandle1.location == ScaleLocationRight){
            
            scale2Frame.origin = CGPointZero;
            scale2Frame.size = CGSizeMake(self.scaleHandle2.textFinalWdith, self.finalSize.height - descHeight);
            contentFrame.origin = CGPointMake(CGRectGetMaxX(scale2Frame), 0);
            
            scale1Frame.origin = CGPointMake(CGRectGetMaxX(contentFrame), 0);
            scale1Frame.size = CGSizeMake(self.scaleHandle1.textFinalWdith, self.finalSize.height - descHeight);
            
            descFrame.origin = CGPointMake(0, CGRectGetMaxY(scale1Frame));
            
        }
        
        
        
        //如果是自动适应高度
        
        CGFloat  averageLong = (contentSize.height - self.groupHandle.textFinalHeight - maxScaleHeight - maxValueSpeace)/scaleNum;
        
        CGFloat maxY = CGRectGetHeight(contentFrame) - self.groupHandle.textFinalHeight;
        
        self.scaleHandle1.averageValue =  averageLong/self.scaleHandle1.scaleAverage;//1对应的高度
        self.scaleHandle2.averageValue =  averageLong/self.scaleHandle2.scaleAverage;//1对应的高度
        
#pragma mark - 刻度分割线 刻度文字
        
        for (NSInteger index = 0; index <= scaleNum ; index ++){
            
            double y = maxY - index * averageLong;
            
            //绘制刻度分割线
            if(showScaleLine)
            {
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, y)];
                [path addLineToPoint:CGPointMake(contentSize.width, y)];
                path.lineWidth = PixWidth(self.scaleHandle1.lineWidth);
                
                FFPathNode *node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.scaleHandle1.lineColor];
                
                [self.contentNodes addObject:node];
            }
            
            //绘制刻度尺刻度值
            if(self.scaleHandle1 && showScale)
            {
                double scaleValue = self.scaleHandle1.maxScaleValue + index * self.scaleHandle1.scaleAverage;
                NSString * scaleString = [@(scaleValue) stringWithdecimals:self.scaleHandle1.decimals];
                
                if(self.scaleHandle1.unit) scaleString = [scaleString stringByAppendingString:self.scaleHandle1.unit];
                
                CGSize fitSize = (self.scaleHandle1.adapeType == TextAdaptTypeFixed || self.scaleHandle1.adapeType == TextAdaptTypeFixedRadianWidthRotate) ? CGSizeMake(self.scaleHandle1.textFinalWdith, self.scaleHandle1.textMaxHeight) : CGSizeMake(self.scaleHandle1.textMaxWidth, self.scaleHandle1.textMaxHeight);
                
                NSMutableAttributedString * attrString =  [NSMutableAttributedString initWithString:scaleString font:self.scaleHandle1.textFont color:self.scaleHandle1.textColor];
                
                
                FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:self.scaleHandle1.radian size:fitSize origin:CGPointZero];
                
                //调整右边对齐
                
                CGRect rect = node.rect;
                rect.origin.y = y - rect.size.height/2.0;
                rect.origin.x = self.scaleHandle1.textFinalWdith - rect.size.width;
                node.rect = rect;
                
                [self.scale1Nodes addObject:node];
                
            }
            if(self.scaleHandle2 && showScale)
            {
                
                double scaleValue = self.scaleHandle2.minScaleValue +  index * self.scaleHandle2.scaleAverage;
                
                NSString * scaleString = [@(scaleValue) stringWithdecimals:self.scaleHandle2.decimals];
                
                if(self.scaleHandle2.unit) scaleString = [scaleString stringByAppendingString:self.scaleHandle2.unit];
                
                CGSize fitSize = (self.scaleHandle2.adapeType == TextAdaptTypeFixed || self.scaleHandle2.adapeType == TextAdaptTypeFixedRadianWidthRotate) ? CGSizeMake(self.scaleHandle2.textFinalWdith, self.scaleHandle2.textMaxHeight) : CGSizeMake(self.scaleHandle2.textMaxWidth, self.scaleHandle2.textMaxHeight);
                
                NSMutableAttributedString * attrString =  [NSMutableAttributedString initWithString:scaleString font:self.scaleHandle2.textFont color:self.scaleHandle2.textColor];
                
                FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:self.scaleHandle2.radian size:fitSize origin:CGPointZero];
                
                //调整右边对齐
                
                CGRect rect = node.rect;
                rect.origin.y = y - rect.size.height/2.0;
                rect.origin.x = self.scaleHandle2.textFinalWdith - rect.size.width;
                node.rect = rect;
                
                [self.scale2Nodes addObject:node];
                
            }
        }
        
        
        
        [self.groupHandle.textArray enumerateObjectsUsingBlock:^(NSString * group, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            CGFloat x = idx * groupSpecing + groupSpecing /2.0;
            
#pragma mark - 分组文字
            
            //绘制分组文字
            if(self.groupHandle.displayType == DisplayTypeShow)
            {
                NSMutableAttributedString * groupString = [NSMutableAttributedString initWithString:group font:self.groupHandle.textFont color:self.groupHandle.textColor];
                
                CGSize fitSize = (self.groupHandle.adapeType == TextAdaptTypeFixed || self.groupHandle.adapeType == TextAdaptTypeFixedRadianWidthRotate) ? CGSizeMake(self.groupHandle.textFinalWdith, self.groupHandle.textMaxHeight) : CGSizeMake(self.groupHandle.textMaxWidth, self.groupHandle.textMaxHeight);
                
                FFTextNode * node = [FFTextNode initWithAttrString:groupString angle:self.groupHandle.radian size:fitSize center:CGPointMake(x, maxY + self.groupHandle.textFinalHeight/2.0)];
                
                [groupTextArray addObject:node];
                
            }
            
            CGFloat startX = x - totalBarWidth/2.0;
            CGFloat bottomY = maxY;
            
            for (NodeHandle * handle in nodeArray){
                
                NSNumber *number = handle.valueArray[idx];
                CGPoint valuePoint = CGPointMake(x, bottomY - handle.scale.averageValue * [number doubleValue]);
                
                
                //文字
                BOOL limitShow = ([number doubleValue] == handle.maxValue || [number doubleValue] == handle.minValue) && handle.displayType == DisplayTypeShowLimit;
                
                if(handle.displayType == DisplayTypeShow || limitShow)
                {
                    NSString * valueText = [number stringWithdecimals:handle.decimals];
                    
                    if(handle.unit) valueText = [valueText stringByAppendingString:handle.unit];
                    
                    CGPoint textPoint = CGPointMake(valuePoint.x, valuePoint.y - maxValueSpeace - handle.textFont.lineHeight/2.0);
                    
                    NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:valueText font:handle.textFont color:handle.textColor];
                    
                    FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:MAXSIZE center:textPoint];
                    
                    [valueTextArray addObject:node];
                    
                }
                
                
                
                if ([handle isKindOfClass:[BarHandle class]]) {
                    
                    BarHandle * barHandle = (BarHandle *)handle;
                    
                    CGFloat barLong = handle.scale.averageValue * [number doubleValue];
                    
                    CGRect barRect = CGRectMake(startX, valuePoint.y, barHandle.barWidth, barLong);
                    UIBezierPath * path = [UIBezierPath bezierPathWithRect:barRect];
                    
                    //柱状
                    if (barHandle.fillColor) {
                        
                        FFPathNode * node = [FFPathNode initWithPath:path fillColor:barHandle.fillColor strokeColor:nil];
                        
                        [barArray addObject:node];
                        
                    } else if( barHandle.startColor && barHandle.endColor){
                        
                        
                        FFGradientNode * node = [FFGradientNode initWithPath:path];
                        node.startColor = barHandle.startColor;
                        node.endColor = barHandle.endColor;
                        node.startPoint = valuePoint;
                        node.endPoint = CGPointMake(valuePoint.x, maxY);
                        
                        [barArray addObject:node];
                    }
                    
                    if(self.scaleHandle1.barStyle == MutableBarDisplayStyleTiling) startX += barHandle.barWidth + barSpeace;
                    else bottomY -= barLong;
                    
                    
                    
                    
                } else {
                    
                    LineHandle * lineHandle = (LineHandle *)handle;
                    
                    [lineHandle.pointArray addObject:NSStringFromCGPoint(valuePoint)];
                    
                    //点
                    {
                        
                        if(lineHandle.outsideRadius > CGFLOAT_MIN && lineHandle.outsideColor){
                            
                            UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:valuePoint radius:lineHandle.outsideRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
                            
                            FFPathNode * node = [FFPathNode initWithPath:path fillColor:lineHandle.outsideColor strokeColor:nil];
                            
                            [pointArray addObject:node];
                        }
                        
                        if(lineHandle.insideRadius > CGFLOAT_MIN && lineHandle.insideColor){
                            
                            UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:valuePoint radius:lineHandle.insideRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
                            
                            FFPathNode * node = [FFPathNode initWithPath:path fillColor:lineHandle.insideColor strokeColor:nil];
                            
                            [pointArray addObject:node];
                        }
                        
                    }
                }
                
                
                
            }
            
            
#pragma mark - 点击事件
            
            if(self.tipsHandle){
                
                CGRect touchRect = CGRectMake(x- groupSpecing/2.0, 0, groupSpecing, self.finalSize.height);
                
                if(!self.tipsHandle.touchAction){
                    
                    
                    
                    CGFloat initX = 0;
                    CGFloat initY = 0;
                    CGFloat xSpeace = self.tipsHandle.xSpecing;
                    CGFloat ySpeace = self.tipsHandle.ySpecing;
                    CGFloat width = self.tipsHandle.colorWidth;
                    CGFloat radius = self.tipsHandle.colorRadius;
                    CGFloat beginY = initY;
                    CGFloat aimY = maxY;
                    CGFloat contentW = 0;
                    
                    
                    NSMutableArray *tipArray = @[].mutableCopy;
                    
                    NSMutableAttributedString *  groupSring = [NSMutableAttributedString initWithString:group font:self.tipsHandle.groupTextFont color:self.tipsHandle.groupTextColor];
                    
                    
                    if(isMutalbe){
                        
                        FFTextNode * node = [FFTextNode initWithAttrString:groupSring angle:0 size:MAXSIZE origin:CGPointMake(initX, beginY)];
                        [tipArray addObject:node];
                        beginY += ySpeace + node.rect.size.height;
                        contentW  = contentW < node.rect.size.width ? node.rect.size.width : contentW;
                    }
                    
                    for (NodeHandle * handle in nodeArray) {
                        
                        NSNumber *number = handle.valueArray[idx];
                        CGFloat valueY = maxY - handle.scale.averageValue * [number doubleValue];
                        aimY = aimY > valueY ? valueY : aimY;
                        NSString * valueText = [number stringWithdecimals:handle.decimals];
                        if(handle.unit) valueText = [valueText stringByAppendingString:handle.unit];
                        
                        if(!isMutalbe){
                            
                            [groupSring appendString:valueText font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            
                            FFTextNode * node = [FFTextNode initWithAttrString:groupSring angle:0 size:MAXSIZE origin:CGPointMake(initX, beginY)];
                            [tipArray addObject:node];
                            beginY += ySpeace + node.rect.size.height;
                            contentW  = contentW < node.rect.size.width ? node.rect.size.width : contentW;
                            
                        } else {
                            
                            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:handle.descString font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            [attrString appendString:@"\n" font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            [attrString appendString:valueText font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            
                            
                            FFTextNode *textNode = [FFTextNode initWithAttrString:attrString angle:0 size:MAXSIZE origin:CGPointMake(initX + width + xSpeace, beginY)];
                            contentW  = contentW < CGRectGetMaxX(textNode.rect) ? CGRectGetMaxX(textNode.rect) : contentW;
                            beginY += ySpeace + textNode.rect.size.height;
                            [tipArray addObject:textNode];
                            
                            CGRect colorRect = CGRectMake(initX, CGRectGetMidY(textNode.rect) - width/2.0, width, width);
                            
                            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:colorRect cornerRadius:radius];
                            FFPathNode * pathNode = [FFPathNode initWithPath:path fillColor:handle.themeColor strokeColor:nil];
                            
                            [tipArray addObject:pathNode];
                            
                        }
                        
                    }
                    
                    FFTouchNode *touchNode = [FFTouchNode initWithNodes:tipArray touchRect:touchRect aimPoint:CGPointMake(x, aimY)];
                    touchNode.contentSize = CGSizeMake(contentW, beginY - ySpeace);
                    touchNode.isRignt = self.tipsHandle.firstRight;
                    [self.contentNodes addObject:touchNode];
                    
                } else {
                    
                    FFTouchNode *touchNode = [FFTouchNode initWithTouchRect:touchRect];
                    touchNode.idx = idx;
                    touchNode.touchAction = self.tipsHandle.touchAction;
                    [self.contentNodes addObject:touchNode];
                    
                }
                
            }
            
        }];
        
        
        
        
        NSMutableArray * finalArray = @[].mutableCopy;
        [finalArray addObjectsFromArray:self.scaleHandle1.lineArray];
        [finalArray addObjectsFromArray:self.scaleHandle2.lineArray];
        
        for (LineHandle *line in finalArray) {
            
            
            FFPathNode * node = [line lineNode];
            
            [lineArray addObject:node];
            
            if(line.closeArea){
                
                CGPoint firstPoint = CGPointFromString(line.pointArray.firstObject);
                CGPoint lastPoint = CGPointFromString(line.pointArray.lastObject);
                
                UIBezierPath * areaPath  = [node.path copy];
                [areaPath addLineToPoint:CGPointMake(lastPoint.x, maxY)];
                [areaPath addLineToPoint:CGPointMake(firstPoint.x, maxY)];
                [areaPath closePath];
                
                CGRect rect = CGPathGetBoundingBox(areaPath.CGPath);
                
                FFGradientNode * areaNode = [FFGradientNode initWithPath:areaPath];
                areaNode.startColor = line.areaStartColor;
                areaNode.endColor = line.areaEndColor;
                areaNode.startPoint = CGPointMake(0, CGRectGetMinY(rect));
                areaNode.endPoint = CGPointMake(0, CGRectGetMaxY(rect));
                
                [areaArray addObject:areaNode];
                
                
            }
            
            
        }
        
        
#pragma mark - 刻度尺在上方/下方
        
    } else if (self.scaleHandle1.location == ScaleLocationTop ||
               self.scaleHandle1.location == ScaleLocationBottom){
        
        CGFloat maxScaleWdith = fmaxf(self.scaleHandle1.subTextMaxWdith, self.scaleHandle2.subTextMaxWdith);
        CGFloat maxValueSpeace = fmaxf(self.scaleHandle1.valueSpeace, self.scaleHandle2.valueSpeace);
        CGFloat scaleLong = (self.initSize.width - self.groupHandle.textFinalWdith - maxValueSpeace - maxScaleWdith)/scaleNum;
        
        [self.scaleHandle1 fitFinalSizeWithSpeacing:scaleLong];
        [self.scaleHandle2 fitFinalSizeWithSpeacing:scaleLong];
        
        if(self.adaptType == AdaptTypeAutoFitSize){
            
            CGSize size = self.initSize;
            size.height = self.scaleHandle1.textFinalHeight + self.scaleHandle2.textFinalHeight + self.groupHandle.groupNum * self.groupHandle.spacing + descHeight;
            self.finalSize = size;
            
        }else {
            
            self.finalSize = self.initSize;
        }
        
        
        CGFloat finalHeight = self.finalSize.height - self.scaleHandle1.textFinalHeight - self.scaleHandle2.textFinalHeight - descHeight;
        
        contentFrame.size = CGSizeMake(self.finalSize.width, finalHeight);
        
        if(self.scaleHandle1.location == ScaleLocationTop){
            
            scale1Frame.origin = CGPointZero;
            scale1Frame.size = CGSizeMake(self.finalSize.width, self.scaleHandle1.textFinalHeight);
            
            contentFrame.origin = CGPointMake(0, self.scaleHandle1.textFinalHeight);
            
            scale2Frame.origin = CGPointMake(0, CGRectGetMaxY(contentFrame));
            scale2Frame.size = CGSizeMake(self.finalSize.width, self.scaleHandle2.textFinalHeight);
            
            descFrame.origin = CGPointMake(0, CGRectGetMaxY(scale2Frame));
            
        }
        
        if(self.scaleHandle1.location == ScaleLocationBottom){
            
            scale2Frame.origin = CGPointZero;
            scale2Frame.size = CGSizeMake(self.finalSize.width, self.scaleHandle2.textFinalHeight);
            
            contentFrame.origin = CGPointMake(0, self.scaleHandle2.textFinalHeight);
            
            scale1Frame.origin = CGPointMake(0, CGRectGetMaxY(contentFrame));
            scale1Frame.size = CGSizeMake(self.finalSize.width, self.scaleHandle1.textFinalHeight);
            
            descFrame.origin = CGPointMake(0, CGRectGetMaxY(scale1Frame));
            
        }
        
        //平均长度
        CGFloat groupSpecing = finalHeight/ groupNum;
        
        contentSize = CGSizeMake(self.finalSize.width,groupSpecing * self.groupHandle.textArray.count);
        
        
        
        CGFloat  averageLong = (contentSize.width - self.groupHandle.textFinalWdith - maxScaleWdith - maxValueSpeace)/scaleNum;
        
        CGFloat minX = self.groupHandle.textFinalWdith;
        
        
        self.scaleHandle1.averageValue = averageLong/self.scaleHandle1.scaleAverage;//1对应的高度
        self.scaleHandle2.averageValue = averageLong/self.scaleHandle2.scaleAverage;//1对应的高度
#pragma mark - 刻度分割线 刻度文字
        
        //绘制分割线
        for (NSInteger index = 0; index <= scaleNum ; index ++){
            
            double X = minX + index * averageLong;
            
            if(showScaleLine)
            {
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(X, 0)];
                [path addLineToPoint:CGPointMake(X, contentSize.height)];
                path.lineWidth = PixWidth(self.scaleHandle1.lineWidth);
                
                FFPathNode *node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.scaleHandle1.lineColor];
                
                [self.contentNodes addObject:node];
            }
            
            //绘制刻度尺
            if(self.scaleHandle1 && showScale)
            {
                double scaleValue = self.scaleHandle1.minScaleValue + index * self.scaleHandle1.scaleAverage;
                
                NSString * scaleString = [@(scaleValue) stringWithdecimals:self.scaleHandle1.decimals];
                
                if(self.scaleHandle1.unit) scaleString = [scaleString stringByAppendingString:self.scaleHandle1.unit];
                
                CGSize fitSize = (self.scaleHandle1.adapeType == TextAdaptTypeFixed || self.scaleHandle1.adapeType == TextAdaptTypeFixedRadianWidthRotate) ? CGSizeMake(self.scaleHandle1.textFinalWdith, self.scaleHandle1.textMaxHeight) : CGSizeMake(self.scaleHandle1.textMaxWidth, self.scaleHandle1.textMaxHeight);
                
                NSMutableAttributedString * attrString =  [NSMutableAttributedString initWithString:scaleString font:self.scaleHandle1.textFont color:self.scaleHandle1.textColor];
                
                FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:self.scaleHandle1.radian size:fitSize origin:CGPointZero];
                
                //调整右边对齐
                
                CGRect rect = node.rect;
                rect.origin.x = X - rect.size.width/2.0;
                rect.origin.y = (self.scaleHandle1.textFinalHeight - rect.size.height)/2.0;
                node.rect = rect;
                
                [self.scale1Nodes addObject:node];
                
            }
            if(self.scaleHandle2 && showScale)
            {
                
                double scaleValue = self.scaleHandle2.minScaleValue +  index * self.scaleHandle2.scaleAverage;
                
                NSString * scaleString = [@(scaleValue) stringWithdecimals:self.scaleHandle2.decimals];
                
                if(self.scaleHandle2.unit) scaleString = [scaleString stringByAppendingString:self.scaleHandle2.unit];
                
                CGSize fitSize = (self.scaleHandle2.adapeType == TextAdaptTypeFixed || self.scaleHandle2.adapeType == TextAdaptTypeFixedRadianWidthRotate) ? CGSizeMake(self.scaleHandle2.textFinalWdith, self.scaleHandle2.textMaxHeight) : CGSizeMake(self.scaleHandle2.textMaxWidth, self.scaleHandle2.textMaxHeight);
                
                NSMutableAttributedString * attrString =  [NSMutableAttributedString initWithString:scaleString font:self.scaleHandle2.textFont color:self.scaleHandle2.textColor];
                
                FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:self.scaleHandle2.radian size:fitSize origin:CGPointZero];
                
                //调整右边对齐
                
                CGRect rect = node.rect;
                rect.origin.x = X - rect.size.width/2.0;
                rect.origin.y = (self.scaleHandle1.textFinalHeight - rect.size.height)/2.0;
                node.rect = rect;
                
                [self.scale2Nodes addObject:node];
                
            }
        }
        
        [self.groupHandle.textArray enumerateObjectsUsingBlock:^(NSString * group, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            CGFloat y = idx * groupSpecing + groupSpecing /2.0;
            
#pragma mark - 分组文字
            //绘制分组文字
            if(self.groupHandle.displayType == DisplayTypeShow)
            {
                NSMutableAttributedString * groupString = [NSMutableAttributedString initWithString:group font:self.groupHandle.textFont color:self.groupHandle.textColor];
                
                CGSize fitSize =(self.groupHandle.adapeType == TextAdaptTypeFixed || self.groupHandle.adapeType == TextAdaptTypeFixedRadianWidthRotate) ? CGSizeMake(self.groupHandle.textFinalWdith, self.groupHandle.textMaxHeight) : CGSizeMake(self.groupHandle.textMaxWidth, self.groupHandle.textMaxHeight);
                
                FFTextNode * node = [FFTextNode initWithAttrString:groupString angle:self.groupHandle.radian size:fitSize origin:CGPointZero];
                
                CGRect rect = node.rect;
                rect.origin.x = 0;
                rect.origin.y = y- rect.size.height/2.0;
                node.rect = rect;
                
                [groupTextArray addObject:node];
                
            }
            
            CGFloat startY = y - totalBarWidth/2.0;
            CGFloat StartX = minX;
            
            for (NodeHandle * handle in nodeArray) {
                
                NSNumber *number = handle.valueArray[idx];
                CGPoint valuePoint = CGPointMake(minX + [number doubleValue] *  handle.scale.averageValue, y);
                
                //文字
                BOOL limitShow = ([number doubleValue] == handle.maxValue || [number doubleValue] == handle.minValue) && handle.displayType == DisplayTypeShowLimit;
                
                if(handle.displayType == DisplayTypeShow || limitShow)
                {
                    NSString * valueText = [number stringWithdecimals:handle.decimals];
                    
                    if(handle.unit) valueText = [valueText stringByAppendingString:handle.unit];
                    
                    NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:valueText font:handle.textFont color:handle.textColor];
                    
                    FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:MAXSIZE origin:valuePoint];
                    
                    CGRect rect = node.rect;
                    rect.origin.x = valuePoint.x + maxValueSpeace;
                    rect.origin.y = y- rect.size.height/2.0;
                    node.rect = rect;
                    
                    [valueTextArray addObject:node];
                    
                }
                
                if ([handle isKindOfClass:[BarHandle class]]) {
                    
                    BarHandle * barHandle = (BarHandle *)handle;
                    
                    CGFloat barLong =  handle.scale.averageValue * [number doubleValue];
                    
                    CGRect barRect = CGRectMake(StartX, startY, barLong, barHandle.barWidth);
                    
                    UIBezierPath * path = [UIBezierPath bezierPathWithRect:barRect];
                    
                    if (barHandle.fillColor) {
                        
                        FFPathNode * node = [FFPathNode initWithPath:path fillColor:barHandle.fillColor strokeColor:nil];
                        
                        [barArray addObject:node];
                        
                    } else if( barHandle.startColor && barHandle.endColor){
                        
                        FFGradientNode * node = [FFGradientNode initWithPath:path];
                        node.startColor = barHandle.startColor;
                        node.endColor = barHandle.endColor;
                        node.startPoint = CGPointMake(minX, startY);
                        node.endPoint = valuePoint;
                        
                        [barArray addObject:node];
                    }
                    
                    if(self.scaleHandle1.barStyle == MutableBarDisplayStyleTiling) startY += barHandle.barWidth + barSpeace;
                    else StartX += barLong;
                    
                    
                    
                } else {
                    
                    LineHandle * lineHandle = (LineHandle *)handle;
                    
                    //记录每个点
                    [lineHandle.pointArray addObject:NSStringFromCGPoint(valuePoint)];
                    
                    if(lineHandle.outsideRadius > CGFLOAT_MIN && lineHandle.outsideColor){
                        
                        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:valuePoint radius:lineHandle.outsideRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
                        
                        FFPathNode * node = [FFPathNode initWithPath:path fillColor:lineHandle.outsideColor strokeColor:nil];
                        
                        [pointArray addObject:node];
                    }
                    
                    if(lineHandle.insideRadius > CGFLOAT_MIN && lineHandle.insideColor){
                        
                        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:valuePoint radius:lineHandle.insideRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
                        
                        FFPathNode * node = [FFPathNode initWithPath:path fillColor:lineHandle.insideColor strokeColor:nil];
                        
                        [pointArray addObject:node];
                    }
                    
                }
                
            }
            
            
#pragma mark - 点击事件
            
            if(self.tipsHandle){
                
                CGRect touchRect = CGRectMake(0, y- groupSpecing/2.0, self.finalSize.width,groupSpecing);
                
                if(!self.tipsHandle.touchAction){
                    
                    CGFloat initX = 0;
                    CGFloat initY = 0;
                    CGFloat xSpeace = self.tipsHandle.xSpecing;
                    CGFloat ySpeace = self.tipsHandle.ySpecing;
                    CGFloat width = self.tipsHandle.colorWidth;
                    CGFloat radius = self.tipsHandle.colorRadius;
                    CGFloat beginY = initY;
                    CGFloat aimX = minX;
                    CGFloat contentW = 0;
                    
                    NSMutableArray *tipArray = @[].mutableCopy;
                    
                    NSMutableAttributedString *  groupSring = [NSMutableAttributedString initWithString:group font:self.tipsHandle.groupTextFont color:self.tipsHandle.groupTextColor];
                    
                    
                    if(isMutalbe){
                        
                        FFTextNode * node = [FFTextNode initWithAttrString:groupSring angle:0 size:MAXSIZE origin:CGPointMake(initX, beginY)];
                        [tipArray addObject:node];
                        beginY += ySpeace + node.rect.size.height;
                        contentW  = contentW < node.rect.size.width ? node.rect.size.width : contentW;
                    }
                    
                    for (NodeHandle * handle in nodeArray) {
                        
                        NSNumber *number = handle.valueArray[idx];
                        CGFloat valueX = minX + self.scaleHandle1.averageValue * [number doubleValue];
                        aimX = aimX < valueX ? valueX : aimX;
                        NSString * valueText = [number stringWithdecimals:handle.decimals];
                        if(handle.unit) valueText = [valueText stringByAppendingString:handle.unit];
                        
                        if(!isMutalbe){
                            
                            [groupSring appendString:valueText font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            
                            FFTextNode * node = [FFTextNode initWithAttrString:groupSring angle:0 size:MAXSIZE origin:CGPointMake(initX, beginY)];
                            [tipArray addObject:node];
                            beginY += ySpeace + node.rect.size.height;
                            contentW  = contentW < node.rect.size.width ? node.rect.size.width : contentW;
                            
                        } else {
                            
                            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:handle.descString font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            [attrString appendString:@"\n" font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            [attrString appendString:valueText font:self.tipsHandle.valueTextFont color:self.tipsHandle.valueTextColor];
                            
                            
                            FFTextNode *textNode = [FFTextNode initWithAttrString:attrString angle:0 size:MAXSIZE origin:CGPointMake(initX + width + xSpeace, beginY)];
                            contentW  = contentW < CGRectGetMaxX(textNode.rect) ? CGRectGetMaxX(textNode.rect) : contentW;
                            beginY += ySpeace + textNode.rect.size.height;
                            [tipArray addObject:textNode];
                            
                            CGRect colorRect = CGRectMake(initX, CGRectGetMidY(textNode.rect) - width/2.0, width, width);
                            
                            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:colorRect cornerRadius:radius];
                            FFPathNode * pathNode = [FFPathNode initWithPath:path fillColor:handle.themeColor strokeColor:nil];
                            
                            [tipArray addObject:pathNode];
                            
                        }
                        
                    }
                    
                    FFTouchNode *touchNode = [FFTouchNode initWithNodes:tipArray touchRect:touchRect aimPoint:CGPointMake(aimX, y)];
                    touchNode.contentSize = CGSizeMake(contentW, beginY - ySpeace);
                    touchNode.isRignt = self.tipsHandle.firstRight;
                    [self.contentNodes addObject:touchNode];
                    
                    
                    
                    
                } else {
                    
                    FFTouchNode *touchNode = [FFTouchNode initWithTouchRect:touchRect];
                    touchNode.idx = idx;
                    touchNode.touchAction = self.tipsHandle.touchAction;
                    [self.contentNodes addObject:touchNode];
                    
                }
                
                
                
            }
            
        }];
        
        
        
        
        NSMutableArray * finalArray = @[].mutableCopy;
        [finalArray addObjectsFromArray:self.scaleHandle1.lineArray];
        [finalArray addObjectsFromArray:self.scaleHandle2.lineArray];
        
        for (LineHandle *line in finalArray) {
            
            
            FFPathNode * node = [line lineNode];
            
            [lineArray addObject:node];
            
            if(line.closeArea){
                
                CGPoint firstPoint = CGPointFromString(line.pointArray.firstObject);
                CGPoint lastPoint = CGPointFromString(line.pointArray.lastObject);
                
                UIBezierPath * areaPath  = [node.path copy];
                [areaPath addLineToPoint:CGPointMake(minX,lastPoint.y)];
                [areaPath addLineToPoint:CGPointMake(minX,firstPoint.y)];
                [areaPath closePath];
                
                CGRect rect = CGPathGetBoundingBox(areaPath.CGPath);
                
                FFGradientNode * areaNode = [FFGradientNode initWithPath:areaPath];
                areaNode.startColor = line.areaStartColor;
                areaNode.endColor = line.areaEndColor;
                areaNode.startPoint = CGPointMake(CGRectGetMaxX(rect), 0);
                areaNode.endPoint = CGPointMake(CGRectGetMinX(rect), 0);
                
                [areaArray addObject:areaNode];
                
                
            }
            
            
        }
        
        
    }
    
#pragma mark - 说明文字
    
    
    if(isMutalbe && self.descHandle){
        
        //计算绘制起点
        
        CGFloat totalWidth = self.descHandle.rouNum * (self.descHandle.colorWidth + self.descHandle.colorTextSpeace) + (self.descHandle.rouNum - 1) * self.descHandle.nodeSpeace;
        
        for (NSInteger index = 0 ; index < self.descHandle.rouNum ; index++) {
            NodeHandle * handle = nodeArray[index];
            
            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:handle.descString font:self.descHandle.textFont color:self.descHandle.textColor];
            CGFloat  width = [attrString sizeForContainerSize:MAXSIZE].width;
            totalWidth += width;
            
        }
        
        CGFloat initX = (descFrame.size.width - totalWidth)/ 2.0;
        CGFloat initY = self.descHandle.topSpeace;
        __block CGFloat beginX = initX;
        __block CGFloat beginY = initY;
        [nodeArray enumerateObjectsUsingBlock:^(NodeHandle * handle, NSUInteger idx, BOOL * _Nonnull stop) {
            
            {
                CGRect colorRect = CGRectMake(beginX, beginY + self.descHandle.textFont.lineHeight/2.0 - self.descHandle.colorWidth/2.0, self.descHandle.colorWidth, self.descHandle.colorWidth);
                
                UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:colorRect cornerRadius:self.descHandle.colorRadius];
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:handle.themeColor strokeColor:nil];
                [self.descNodes addObject:node];
                
                beginX += self.descHandle.colorWidth + self.descHandle.colorTextSpeace;
                
            }
            {
                NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:handle.descString font:self.descHandle.textFont color:self.descHandle.textColor];
                
                FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:MAXSIZE origin:CGPointZero];
                
                CGRect rect = node.rect;
                rect.origin.x = beginX ;
                rect.origin.y = beginY;
                node.rect = rect;
                
                beginX += rect.size.width + self.descHandle.nodeSpeace;
                
                [self.descNodes addObject:node];
                
            }
            
            if(beginX != initX  && idx != 0 && (idx + 1) % self.descHandle.rouNum == 0){
                
                beginX = initX;
                beginY += self.descHandle.textFont.lineHeight + self.descHandle.midSpeace;
                
            }
            
        }];
        
        
        
        
    }
    
    
    [self.contentNodes addObjectsFromArray:groupTextArray];
    [self.contentNodes addObjectsFromArray:barArray];
    [self.contentNodes addObjectsFromArray:areaArray];
    [self.contentNodes addObjectsFromArray:lineArray];
    [self.contentNodes addObjectsFromArray:pointArray];
    [self.contentNodes addObjectsFromArray:valueTextArray];
    
    
    self.scale1Frame = scale1Frame;
    self.scale2Frame = scale2Frame;
    self.contentFrame = contentFrame;
    self.contentSize = contentSize;
    self.descFrame = descFrame;
    
}

- (void)setErrorView{
    
    
}

- (void)setNoneView{
    
    
}



@end

@implementation ScaleHandle

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.displayType = DisplayTypeShow;
        self.location = ScaleLocationLeft;
        self.adapeType = TextAdaptTypeAuto;
        self.lineDisplayType = DisplayTypeShow;
        self.barStyle = MutableBarDisplayStyleTiling;
        
    }
    return self;
}



- (void)beginCalculate{
    
    
    NSMutableArray *newValueArray = @[].mutableCopy;
    [newValueArray addObjectsFromArray:self.lineArray];
    [newValueArray addObjectsFromArray:self.barArray];
    
    
    //计算最大值 最小值
    
    
    if(self.barStyle == MutableBarDisplayStyleStack){
        
        NodeHandle * firstHandle = [newValueArray firstObject];
        
        [firstHandle.valueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            double value = 0;
            
            for (BarHandle * barHandle in self.barArray) {
                
                value += [barHandle.valueArray[idx] doubleValue];
                
            }
            
            self.minScaleValue = self.minScaleValue > value ? value : self.minScaleValue;
            self.maxScaleValue = self.maxScaleValue < value ? value : self.maxScaleValue;
        }];
        
        
    }
    
    for (NodeHandle *handle in newValueArray) {
        
        handle.scale = self;
        
        self.minScaleValue = self.minScaleValue >handle.minValue ? handle.minValue : self.minScaleValue;
        self.maxScaleValue = self.maxScaleValue < handle.maxValue ? handle.maxValue : self.maxScaleValue;
        
        if(handle.displayType == DisplayTypeNone) continue;
        
        NSString *subValueText = [@(self.maxScaleValue) stringWithdecimals:handle.decimals];
        
        if(handle.unit) subValueText = [subValueText stringByAppendingString:handle.unit];
        
        NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:subValueText font:handle.textFont color:handle.textColor];
        
        CGSize size = [attrString sizeForContainerSize:MAXSIZE];
        
        self.subTextMaxWdith = self.subTextMaxWdith < size.width ? size.width : self.subTextMaxWdith;
        self.subTextMaxHeight = self.subTextMaxHeight < size.height ? size.height : self.subTextMaxHeight;
        
    }
    self.maxScaleValue = [@(self.maxScaleValue) nearbyNumFromBase:5];
    
    //计算bar总宽度
    self.totalBarWdith = 0;
    
    if (self.barStyle == MutableBarDisplayStyleTiling) {
        
        if(self.barArray.count > 0){
            for (BarHandle *handle in self.barArray) {
                self.totalBarWdith += handle.barWidth;
            }
        }
    }else if (self.barArray.count > 0) self.totalBarWdith = [self.barArray firstObject].barWidth;
    
    
    
    //平均值
    self.scaleAverage = (self.maxScaleValue - self.minScaleValue) / self.scaleNum;
    
    
    //如果不显示 宽高都未0
    if(self.displayType == DisplayTypeNone){
        
        self.textMaxWidth = CGFLOAT_MIN;
        self.textMaxHeight = CGFLOAT_MIN;
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    //计算文字 最大 最终 宽度高度
    for (NSInteger index = 0; index <= self.scaleNum; index ++) {
        
        double scaleValue = index * self.scaleAverage + self.minScaleValue;
        
        NSString *scaleValueText = [@(scaleValue) stringWithdecimals:self.decimals];
        
        if(self.unit) scaleValueText = [scaleValueText stringByAppendingString:self.unit];
        
        NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:scaleValueText font:self.textFont color:self.textColor];
        
        CGSize size = [attrString sizeForContainerSize:MAXSIZE];
        
        self.textMaxWidth = self.textMaxWidth < size.width ? size.width : self.textMaxWidth;
        self.textMaxHeight = self.textMaxHeight < size.height ? size.height : self.textMaxHeight;
    }
    
    
    
    //如果是固定宽度
    if(self.adapeType == TextAdaptTypeFixed){
        
        self.textFinalWdith = self.textWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
        
    }
    //固定弧度旋转
    
    if (self.adapeType == TextAdaptTypeFixedRadianRotate){
        
        CGFloat xlong = sqrtf(self.textMaxWidth *self.textMaxWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(self.textMaxWidth, self.textMaxHeight));
        CGFloat radian = radian1 + self.radian;
        CGPoint point = calcPointFromCenter(CGPointZero, radian, xlong);
        self.textFinalHeight = point.y;
        self.textFinalWdith = self.textMaxWidth;
    }
    
    if(self.adapeType == TextAdaptTypeAuto){
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        return;
        
    }
    
    if(self.adapeType == TextAdaptTypeFixedRadianWidthRotate){
        
        CGFloat xlong = sqrtf(self.textWidth *self.textWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(self.textWidth, self.textMaxHeight));
        CGFloat radian = radian1 + self.radian;
        CGPoint point = calcPointFromCenter(CGPointZero, radian, xlong);
        self.textFinalHeight = point.y;
        self.textFinalWdith = self.textWidth;
        
        return;
        
    }
    
    
}
- (void)fitFinalSizeWithSpeacing:(CGFloat)speacing{
    
    
    
    
    //如果不显示 宽高都未0
    if(self.displayType == DisplayTypeNone ){
        
        self.textMaxWidth = CGFLOAT_MIN;
        self.textMaxHeight = CGFLOAT_MIN;
        
        self.textFinalWdith = self.textMaxHeight;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    //如果是固定宽度
    if(self.adapeType == TextAdaptTypeFixed){
        
        self.textFinalWdith = self.textWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
        
    }
    
    if(self.adapeType == TextAdaptTypeFixedRadianWidthRotate){
        
        CGFloat xlong = sqrtf(self.textWidth *self.textWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(self.textWidth, self.textMaxHeight));
        CGFloat radian = radian1 + self.radian;
        CGPoint point = calcPointFromCenter(CGPointZero, radian, xlong);
        self.textFinalHeight = point.y;
        self.textFinalWdith = self.textWidth;
        
        return;
        
    }
    
    if(speacing >= self.textMaxWidth){
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    //计算每组文字最大高度
    if (self.adapeType == TextAdaptTypeAuto){
        
        //根据最小宽度 和最大文本宽度 算旋转弧度
        CGFloat xlong = sqrtf(self.textMaxWidth *self.textMaxWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat height = sqrtf(xlong * xlong - speacing * speacing);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(speacing, height));
        CGFloat radian2 = radianBetweenPoints(CGPointZero, CGPointMake(xlong, self.textMaxHeight));
        self.radian = radian1 - radian2;
        self.textFinalWdith = speacing;
        self.textFinalHeight = height;
        
        return;
    }
    
    
    
}


@synthesize barArray = _barArray;
- (NSMutableArray *)barArray{
    
    if(!_barArray) _barArray = @[].mutableCopy;
    return _barArray;
}

@synthesize lineArray = _lineArray;

- (NSMutableArray *)lineArray{
    
    if(!_lineArray) _lineArray = @[].mutableCopy;
    return _lineArray;
}



@end



@implementation GroupHandle

- (instancetype)init{
    
    self =  [super init];
    
    if(self){
        
        self.displayType = DisplayTypeShow;
        self.adapeType = TextAdaptTypeAuto;
        self.lineDisplayType = DisplayTypeShow;
    }
    
    return self;
}


- (void)beginCalculate{
    
    //计算文字 最大 最终 宽高
    
    
    if(self.displayType != DisplayTypeShow){
        
        self.textMaxWidth = CGFLOAT_MIN;
        self.textMaxHeight = CGFLOAT_MIN;
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    
    for (NSString * groupString in self.textArray ) {
        
        NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:groupString font:self.textFont color:self.textColor];
        CGSize size = [attrString sizeForContainerSize:MAXSIZE];
        self.textMaxWidth = self.textMaxWidth < size.width ? size.width : self.textMaxWidth;
        self.textMaxHeight = self.textMaxHeight < size.height ? size.height : self.textMaxHeight;
        
    }
    
    if(self.adapeType == TextAdaptTypeFixed){
        
        self.textFinalWdith = self.textWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    //固定弧度旋转
    
    if (self.adapeType == TextAdaptTypeFixedRadianRotate){
        
        CGFloat xlong = sqrtf(self.textMaxWidth *self.textMaxWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(self.textMaxWidth, self.textMaxHeight));
        CGFloat radian = radian1 + self.radian;
        CGPoint point = calcPointFromCenter(CGPointZero, radian, xlong);
        self.textFinalHeight = point.y;
        self.textFinalWdith = self.textMaxWidth;
        
        return;
    }
    
    if(self.adapeType == TextAdaptTypeAuto){
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    if(self.adapeType == TextAdaptTypeFixedRadianWidthRotate){
        
        CGFloat xlong = sqrtf(self.textWidth *self.textWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(self.textWidth, self.textMaxHeight));
        CGFloat radian = radian1 + self.radian;
        CGPoint point = calcPointFromCenter(CGPointZero, radian, xlong);
        self.textFinalHeight = point.y;
        self.textFinalWdith = self.textWidth;
        
    }
    
    
}

- (void)fitFinalSizeWithSpeacing:(CGFloat)speacing{
    
    if(self.displayType != DisplayTypeShow){
        
        self.textMaxWidth = CGFLOAT_MIN;
        self.textMaxHeight = CGFLOAT_MIN;
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    
    if(self.adapeType == TextAdaptTypeFixed){
        
        self.textFinalWdith = self.textWidth;
        self.textFinalHeight = self.textMaxHeight;
        
        return;
    }
    
    if(self.adapeType == TextAdaptTypeFixedRadianWidthRotate){
        
        CGFloat xlong = sqrtf(self.textWidth *self.textWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(self.textWidth, self.textMaxHeight));
        CGFloat radian = radian1 + self.radian;
        CGPoint point = calcPointFromCenter(CGPointZero, radian, xlong);
        self.textFinalHeight = point.y;
        self.textFinalWdith = self.textWidth;
        
        return;
        
    }
    
    if(speacing > self.textMaxWidth){
        
        self.textFinalWdith = self.textMaxWidth;
        self.textFinalHeight = self.textMaxHeight;
        return;
    }
    
    //计算每组文字最大高度
    if (self.adapeType == TextAdaptTypeAuto){
        
        //根据最小宽度 和最大文本宽度 算旋转弧度
        CGFloat xlong = sqrtf(self.textMaxWidth *self.textMaxWidth + self.textMaxHeight * self.textMaxHeight);
        CGFloat height = sqrtf(xlong * xlong - speacing * speacing);
        CGFloat radian1 = radianBetweenPoints(CGPointZero, CGPointMake(speacing, height));
        CGFloat radian2 = radianBetweenPoints(CGPointZero, CGPointMake(xlong, self.textMaxHeight));
        self.radian = radian1 - radian2;
        self.textFinalWdith = speacing;
        self.textFinalHeight = height;
        
        return;
    }
    
    
    
}

@end

@interface NodeHandle ()


@property (copy ,nonatomic) NSString * maxString;

@property (copy ,nonatomic) NSString * minString;

@end

@implementation NodeHandle

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        self.valueArray = @[].mutableCopy;
    }
    
    return self;
}

- (double)maxValue{
    
    if(!self.maxString){
        double maxValue = [[self.valueArray valueForKeyPath:@"@max.doubleValue"] doubleValue];
        self.maxString = @(maxValue).stringValue;
    }
    return [self.maxString doubleValue];
}


- (double)minValue{
    
    if(!self.minString){
        double minValue = [[self.valueArray valueForKeyPath:@"@min.doubleValue"] doubleValue];
        self.minString = @(minValue).stringValue;
    }
    return [self.minString doubleValue];
}

@end

@implementation BarHandle

- (UIColor *)themeColor{
    
    return self.startColor ? self.startColor : self.fillColor;
}


@end

@implementation LineHandle

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        self.pointArray = @[].mutableCopy;
    }
    
    return self;
}

- (FFPathNode *)lineNode{
    
    UIBezierPath *path = [self smoothedPathWithGranularity:self.Smooth ? 10 : 0];
    path.lineWidth = PixWidth(self.lineWidth);
    FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.lineColor];
    return node;
    
}


- (CGPoint)pointFromString:(NSString *)string{
    
    return CGPointFromString(string);
}

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity ;
{
    
    NSMutableArray *array = self.pointArray.mutableCopy;
    if(array.count < 4 && granularity > 0){
        
        [array insertObject:self.pointArray.lastObject atIndex:0];
        [array addObject:self.pointArray.lastObject];
    }
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:[self pointFromString:[array firstObject]]];
    [path addLineToPoint:[self pointFromString:array[1]]];
    
    for (NSUInteger index = 1; index <array.count - 2; index++)
    {
        CGPoint p0 = [self pointFromString:array[index - 1]];
        CGPoint p1 = [self pointFromString:array[index]];;
        CGPoint p2 = [self pointFromString:array[index + 1]];;
        CGPoint p3 = [self pointFromString:array[index + 2]];;
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            
            [path addLineToPoint:pi];
        }
        
        // Now add p2
        [path addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [path addLineToPoint:[self pointFromString:[array lastObject]]];
    
    return path;
}

- (UIColor *)themeColor{
    
    return self.lineColor;
}


@end

@implementation TipsHandle

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        self.groupTextFont = [UIFont systemFontOfSize:14];
        self.groupTextColor = UIColor.whiteColor;
        
        self.valueTextFont = [UIFont systemFontOfSize:12];
        self.valueTextColor = UIColor.whiteColor;
        
        self.colorWidth = 10;
        self.colorRadius = 2;
        self.xSpecing = 5;
        self.ySpecing = 10;
        
        
        
    }
    
    return self;
    
}

@end

@implementation DescHandle


- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        self.topSpeace = 10;
        self.midSpeace = 10;
        self.bottomSpeace = 10;
        self.rouNum = 2;
    }
    
    return self;
    
}


@end

