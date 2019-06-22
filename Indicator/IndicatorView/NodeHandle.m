//
//  NodeHandle.m
//  Indicator
//
//  Created by North on 2019/6/10.
//  Copyright © 2019 North. All rights reserved.
//

#import "NodeHandle.h"

@implementation NodeHandle



+ (NodeHandle *)nodeFromBar{
    
    NodeHandle *handle = [NodeHandle new];
    
    
    NSArray * array = @[@{@"name":@"拿地",@"value":@"8"},
                        @{@"name":@"开工",@"value":@"2"},
                        @{@"name":@"示范",@"value":@"1"},
                        @{@"name":@"开盘",@"value":@"3"},
                        @{@"name":@"交付",@"value":@"5"},
                        @{@"name":@"测试",@"value":@"8"},
                        @{@"name":@"开发",@"value":@"7"},
                        @{@"name":@"物业",@"value":@"4"},
                        @{@"name":@"管理",@"value":@"3"},
                        @{@"name":@"借宿",@"value":@"6"}
                        ];
    
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 295);
    
    NSInteger screenMaxNum = 5;//一屏幕最多显示5个
    NSInteger scaleNum = 5;//刻度尺数量
    double barWidth = 30;

    UIEdgeInsets maginEdge = UIEdgeInsetsMake(10, 20, 10, 20);//内边距
    CGSize finalSize = CGSizeMake(size.width - maginEdge.left - maginEdge.right, size.height - maginEdge.top - maginEdge.bottom);
    
    BOOL rotation = NO;//文字是否旋转 默认不旋转
    //刻度字体
    UIFont *scaleFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    //刻度颜色
    UIColor *scaleColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1];
    
    //名字字体
    UIFont *stepFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    //名字颜色
    UIColor *stepColor = [UIColor colorWithRed:67/255.0 green:69/255.0 blue:64/255.0 alpha:1];
    
    
#pragma mark 刻度尺相关
    
   
    ScaleDirection scaleDirction = ScaleDirectionBottom;
    
    double maxScaleWidth = 0;  //刻度计算出来的最大宽度
    double scaleHeight = 0;    //刻度通过计算出来的最大高度度 一般是刻度在底部可能会有旋转
    double minValue = 0;       //最大值
    double maxValue = 0;       //最小值
    double maxNameWidth = 0;   //最大名字宽度
    double maxMagin = 0;       //最大值的距离上方或者右边的边距
    double pointWidth = 6;     //点直径
    
    
    for (NSDictionary *dic in array) {
        
        double value = [dic[@"value"] doubleValue];
        maxValue = maxValue < value?value:maxValue;
        minValue = minValue > value?value:minValue;
        
        {
            
            NSMutableAttributedString *attrString = [handle attrStringFromString:[NSString stringWithFormat:@"%.2f",value] color:scaleColor font:scaleFont];
            
            double textWidth  = [handle sizeForAttrString:attrString size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            
            maxScaleWidth = maxScaleWidth < textWidth ? textWidth : maxScaleWidth;
            
        }
        
        {
          
            NSMutableAttributedString *attrString = [handle attrStringFromString:dic[@"name"] color:stepColor font:stepFont];
            
            double textWidth  = [handle sizeForAttrString:attrString size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            
            maxNameWidth = maxNameWidth < textWidth ? textWidth : maxNameWidth;
            
        }
        
    }
    

    //每一段距离的值
    double averageValue = (maxValue - minValue)/scaleNum;
    double averageLong = 0;
    
    handle.scaleNodes = @[].mutableCopy;
    
        //刻度尺在左边
        if(scaleDirction == ScaleDirectionLeft){
        
            handle.scaleFrame = CGRectMake(maginEdge.left, maginEdge.top, maxScaleWidth, finalSize.height);
            
            handle.contentFrame = CGRectMake(CGRectGetMaxX(handle.scaleFrame), CGRectGetMinY(handle.scaleFrame),finalSize.width -CGRectGetWidth(handle.scaleFrame), finalSize.height);
            
            maxMagin = scaleFont.lineHeight + 5;
             averageLong = (CGRectGetHeight(handle.contentFrame) - stepFont.lineHeight -maxMagin)/scaleNum;
            
            //设置刻度尺节点
            for (NSInteger index = 0; index <= scaleNum; index ++) {
                
               NSString * scaleValue = [NSString stringWithFormat:@"%.2f",maxValue - index * averageValue];
                
                NSMutableAttributedString *attrString = [handle attrStringFromString:scaleValue color:scaleColor font:scaleFont];
                
                CGPoint origin = CGPointMake(0, maxMagin + index * averageLong);
                
                TextNode *node = [TextNode initWithAttrString:attrString rotation:rotation size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) origin:origin];
                
                //调整刻度右边对齐
                origin.x = maxScaleWidth - node.rect.size.width;
                origin.y =  origin.y - node.rect.size.height/2.0;
                CGRect rect = CGRectZero;
                rect.origin = origin;
                rect.size = node.rect.size;
                node.rect = rect;
                
                [handle.scaleNodes  addObject:node];
                
            }
            
            
            
            
            //刻度尺在底部
        } else  if(scaleDirction == ScaleDirectionBottom){
            
            //如果小于一屏幕的数量 修改一屏幕的数量
            NSInteger stepNum = array.count > screenMaxNum ? screenMaxNum : array.count;
            
            //判断名字是否需要旋转
            double speace = (finalSize.width - maxNameWidth)/ (stepNum + 1);
            
            rotation = maxScaleWidth > speace;
            scaleHeight = rotation?25:scaleFont.lineHeight;
            
            handle.scaleFrame = CGRectMake(maginEdge.left, size.height - scaleHeight - maginEdge.bottom, finalSize.width,scaleHeight);
            
            handle.contentFrame = CGRectMake(maginEdge.left, maginEdge.top, finalSize.width, finalSize.height - CGRectGetHeight(handle.scaleFrame));
            
            maxMagin = maxScaleWidth + 5;
            averageLong = (CGRectGetWidth(handle.scaleFrame) - maxNameWidth - maxMagin)/scaleNum;
            
            //设置刻度尺节点
            for (NSInteger index = 0; index <= scaleNum; index ++) {
                
                NSString * scaleValue = [NSString stringWithFormat:@"%.2f",minValue + index * averageValue];
                
                NSMutableAttributedString *attrString = [handle attrStringFromString:scaleValue color:scaleColor font:scaleFont];
                
                CGPoint origin = CGPointMake(maxNameWidth + index * averageLong, 0);
                
                TextNode *node = [TextNode initWithAttrString:attrString rotation:rotation size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) origin:origin];
                
                //调整刻度居中对齐
                origin.x = origin.x - node.rect.size.width/2.0;
                origin.y = (CGRectGetHeight(handle.scaleFrame) - node.rect.size.height)/2.0;
                CGRect rect = CGRectZero;
                rect.origin = origin;
                rect.size = node.rect.size;
                node.rect = rect;
                
                [handle.scaleNodes  addObject:node];
                
            }
            
            
            
        } else {
            
            handle.scaleFrame = CGRectZero;
            handle.contentFrame = CGRectMake(maginEdge.left, maginEdge.top,finalSize.width , finalSize.height);
            
            maxMagin = scaleFont.lineHeight + 5;
            averageLong = (CGRectGetHeight(handle.contentFrame) - stepFont.lineHeight -maxMagin)/scaleNum;
        }
    
    
#pragma mark 内容视图相关
    
    handle.contentNodes = @[].mutableCopy;
    
    NSMutableArray *stepArray = @[].mutableCopy;//名字数组
    NSMutableArray *barArray = @[].mutableCopy;//柱状图数组
    NSMutableArray *lineArray = @[].mutableCopy;//分割线数组
    NSMutableArray *valueArray = @[].mutableCopy;//值对应文字数组
    NSMutableArray *pointArray = @[].mutableCopy;//点数组
    
    double average = averageLong/averageValue;//每一个单位的高度
    
    //如果小于一屏幕的数量 修改一屏幕的数量
    NSInteger stepNum = array.count > screenMaxNum ? screenMaxNum : array.count;
    
    
    //如果刻度尺在左边 // 或者 没有刻度尺
    
    if(scaleDirction == ScaleDirectionLeft || scaleDirction == ScaleDirectionNone){
        
        //计算setp值
        double stepSpeace = CGRectGetWidth(handle.contentFrame)/(stepNum + 1);
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            double value = [dic[@"value"] doubleValue];
            //值的点
            CGPoint valuePoint = CGPointMake((idx + 1) * stepSpeace, maxMagin + (maxValue - value) * average);
            
            
            
            //step点
            CGPoint stepPoint = CGPointMake((idx + 1) * stepSpeace, CGRectGetHeight(handle.contentFrame) - stepFont.lineHeight);
            
            NSString *name =  [NSString stringWithFormat:@"%@",dic[@"name"]];
            NSString *valueStr =  [NSString stringWithFormat:@"%.2f",value];
            
            
            NSMutableAttributedString *valueAttr = [handle attrStringFromString:valueStr color:scaleColor font:scaleFont];
            
            
            NSMutableAttributedString *setpAttr = [handle attrStringFromString:name color:stepColor font:stepFont];
            
            if(idx == array.count -1){
                
                double contentWidth = (idx + 2) * stepSpeace < CGRectGetWidth(handle.contentFrame) ? CGRectGetWidth(handle.contentFrame):(idx + 2) * stepSpeace;
                
                handle.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(handle.contentFrame));
                
                
            }
            //step文字
            {
                TextNode *node = [TextNode initWithAttrString:setpAttr rotation:NO size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) origin:stepPoint];
                
                CGRect rect = node.rect;
                rect.origin.x = stepPoint.x - rect.size.width/2.0;
                node.rect = rect;
                
                [stepArray addObject:node];
                
            }
            
            //value文字
            {
                TextNode *node = [TextNode initWithAttrString:valueAttr rotation:NO size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) origin:valuePoint];
                
                CGRect rect = node.rect;
                rect.origin.x = valuePoint.x - rect.size.width/2.0;
                rect.origin.y = valuePoint.y - rect.size.height - pointWidth - 2;
                node.rect = rect;
                
                [valueArray addObject:node];
                
            }
            
            //柱状
            {
                
                CGRect barRect = CGRectMake(valuePoint.x - barWidth/2.0, valuePoint.y, barWidth, stepPoint.y - valuePoint.y);
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRect:barRect];
                
                GradientNode * node = [GradientNode initWithPath:path];
                node.startColor = [UIColor yellowColor];
                node.endColor = [UIColor blueColor];
                node.startPoint = valuePoint;
                node.endPoint = stepPoint;
                
                [barArray addObject:node];
                
                
            }
            
            //point
            {
                
                CGRect point = CGRectMake(valuePoint.x - pointWidth/2.0, valuePoint.y - pointWidth/2.0, pointWidth, pointWidth);
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:point cornerRadius:pointWidth/2.0];
                
                PathNode * node = [PathNode initWithPath:path fillColor:UIColor.redColor strokeColor:nil];
                
                [pointArray addObject:node];
                
                
            }
            

        }];
        
        
        //分割线
        
        
        for (TextNode *node in handle.scaleNodes) {
            
            double scale = [node.attrString.string doubleValue];
            double y = maxMagin + (maxValue - scale) * average;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, y)];
            [path addLineToPoint:CGPointMake(handle.contentSize.width, y)];
            path.lineWidth = 1.0/[UIScreen mainScreen].scale;
            PathNode *node = [PathNode initWithPath:path fillColor:nil strokeColor:UIColor.lightGrayColor];
            
            [lineArray addObject:node];
            
            
        }
        
        if(pointArray.count > 0)
        {
            UIBezierPath *path = [handle smoothedPathWithGranularity:10 pointArray:pointArray];
            
            //连接的折线
            {
                path.lineWidth = 1.0/[UIScreen mainScreen].scale;
                
                PathNode *node = [PathNode initWithPath:path fillColor:nil strokeColor:UIColor.lightGrayColor];
                
                [pointArray addObject:node];
                
            }
            
            
            
            //曲线图的渐变
            {
                
                UIBezierPath *gradientPath = path.copy;
                
                {
                
                TextNode *node = [stepArray lastObject];
                [gradientPath addLineToPoint:CGPointMake(CGRectGetMidX(node.rect), CGRectGetMinY(node.rect))];
                }
                
                {
                    
                    TextNode *node = [stepArray firstObject];
                    [gradientPath addLineToPoint:CGPointMake(CGRectGetMidX(node.rect), CGRectGetMinY(node.rect))];
                }
                
                [gradientPath closePath];
                gradientPath.lineWidth = CGFLOAT_MIN;
                CGRect gradientRect = CGPathGetBoundingBox(gradientPath.CGPath);
                
                GradientNode *node = [GradientNode initWithPath:gradientPath];
                node.startColor = UIColor.greenColor;
                node.endColor = UIColor.redColor;
                node.startPoint = CGPointMake(0, CGRectGetMinY(gradientRect));
                node.endPoint = CGPointMake(0, CGRectGetMaxY(gradientRect));
                
                [pointArray insertObject:node atIndex:0];
                
            }
            
        }
        
        //刻度尺在底部
    } else {
        
        
        //计算setp值
        double stepSpeace = CGRectGetHeight(handle.contentFrame)/(stepNum + 1);
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            double value = [dic[@"value"] doubleValue];
            //值的点
            CGPoint valuePoint = CGPointMake(maxNameWidth + value * average, (idx + 1) * stepSpeace);
            
            //step点
            CGPoint stepPoint = CGPointMake(0, (idx + 1) * stepSpeace);
            
            NSString *name =  [NSString stringWithFormat:@"%@",dic[@"name"]];
            NSString *valueStr =  [NSString stringWithFormat:@"%.2f",value];
            
            
            NSMutableAttributedString *valueAttr = [handle attrStringFromString:valueStr color:scaleColor font:scaleFont];
            
            NSMutableAttributedString *setpAttr = [handle attrStringFromString:name color:stepColor font:stepFont];
            
            if(idx == array.count -1){
                
                double contentHeight = (idx + 2) * stepSpeace < CGRectGetHeight(handle.contentFrame) ? CGRectGetHeight(handle.contentFrame):(idx + 2) * stepSpeace;
                handle.contentSize = CGSizeMake( CGRectGetWidth(handle.contentFrame),contentHeight);
                
                
            }
            //step文字
            {
                TextNode *node = [TextNode initWithAttrString:setpAttr rotation:NO size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) origin:stepPoint];
                
                //设置文字右边对齐
                CGRect rect = node.rect;
                rect.origin.y = stepPoint.y - rect.size.height/2.0;
                rect.origin.x = maxNameWidth - rect.size.width;
                node.rect = rect;
                
                [stepArray addObject:node];
                
            }
            
            //value文字
            {
                TextNode *node = [TextNode initWithAttrString:valueAttr rotation:NO size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) origin:valuePoint];

                CGRect rect = node.rect;
                rect.origin.x = valuePoint.x + pointWidth;
                rect.origin.y = valuePoint.y - rect.size.height/2.0;
                node.rect = rect;

                [valueArray addObject:node];

            }
//
            //柱状
            {

                CGRect barRect = CGRectMake(maxNameWidth,valuePoint.y - barWidth/2.0,valuePoint.x - maxNameWidth, barWidth);

                UIBezierPath *path = [UIBezierPath bezierPathWithRect:barRect];

                GradientNode * node = [GradientNode initWithPath:path];
                node.startColor = [UIColor yellowColor];
                node.endColor = [UIColor blueColor];
                node.startPoint = CGPointMake(maxNameWidth, valuePoint.y);
                node.endPoint = valuePoint;

                [barArray addObject:node];


            }
            //point
            {

                CGRect point = CGRectMake(valuePoint.x - pointWidth/2.0, valuePoint.y - pointWidth/2.0, pointWidth, pointWidth);

                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:point cornerRadius:pointWidth/2.0];

                PathNode * node = [PathNode initWithPath:path fillColor:UIColor.redColor strokeColor:nil];

                [pointArray addObject:node];


            }
            
            
        }];
        
        
        //分割线


        for (TextNode *node in handle.scaleNodes) {

            double scale = [node.attrString.string doubleValue];
            double x = maxNameWidth + scale * average;

            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(x, 0)];
            [path addLineToPoint:CGPointMake(x,handle.contentSize.height)];
            path.lineWidth = 1.0/[UIScreen mainScreen].scale;
            PathNode *node = [PathNode initWithPath:path fillColor:nil strokeColor:UIColor.lightGrayColor];

            [lineArray addObject:node];


        }

        
        if(pointArray.count > 0)
        {
            UIBezierPath *path = [handle smoothedPathWithGranularity:10 pointArray:pointArray];
            
            //连接的折线
            {
                path.lineWidth = 1.0/[UIScreen mainScreen].scale;
                
                PathNode *node = [PathNode initWithPath:path fillColor:nil strokeColor:UIColor.lightGrayColor];
                
                [pointArray addObject:node];
                
            }
            
            
            
            //曲线图的渐变
            {
                
                UIBezierPath *gradientPath = path.copy;
                
                {
                    
                    TextNode *node = [stepArray lastObject];
                    [gradientPath addLineToPoint:CGPointMake(CGRectGetMaxX(node.rect), CGRectGetMidY(node.rect))];
                }
                
                {
                    
                    TextNode *node = [stepArray firstObject];
                    [gradientPath addLineToPoint:CGPointMake(CGRectGetMaxX(node.rect), CGRectGetMidY(node.rect))];
                }
                
                [gradientPath closePath];
                gradientPath.lineWidth = CGFLOAT_MIN;
                CGRect gradientRect = CGPathGetBoundingBox(gradientPath.CGPath);
                
                GradientNode *node = [GradientNode initWithPath:gradientPath];
                node.startColor = UIColor.greenColor;
                node.endColor = UIColor.redColor;
                node.startPoint = CGPointMake(0, CGRectGetMinY(gradientRect));
                node.endPoint = CGPointMake(0, CGRectGetMaxY(gradientRect));
                
                [pointArray insertObject:node atIndex:0];
                
            }
            
        }
        
    }
    
    [handle.contentNodes addObjectsFromArray:stepArray];
    [handle.contentNodes addObjectsFromArray:lineArray];
    [handle.contentNodes addObjectsFromArray:barArray];
    [handle.contentNodes addObjectsFromArray:pointArray];
    [handle.contentNodes addObjectsFromArray:valueArray];
    
    

    
    return handle;
    
}


- (NSMutableAttributedString *)attrStringFromString:(NSString *)string color:(UIColor*)color font:(UIFont *)font{
    
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [textAttr setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:NSMakeRange(0, textAttr.string.length)];
    
    return textAttr;
}

- (CGSize)sizeForAttrString:(NSAttributedString *)attrString size:(CGSize )size{
    
    
    return  [attrString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
}


- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity pointArray:(NSMutableArray *)pointArray;
{
    
    NSMutableArray *array  = pointArray.mutableCopy;
    
    if(array.count <4){
        
        [array insertObject:[pointArray firstObject] atIndex:0];
        [array addObject:[pointArray lastObject]];
    }
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:[self centerFormPathNode:[pointArray firstObject]]];
    [path addLineToPoint:[self centerFormPathNode:pointArray[1]]];
    
    for (NSUInteger index = 1; index <pointArray.count - 2; index++)
    {
        CGPoint p0 = [self centerFormPathNode:pointArray[index - 1]];
        CGPoint p1 = [self centerFormPathNode:pointArray[index]];;
        CGPoint p2 = [self centerFormPathNode:pointArray[index + 1]];;
        CGPoint p3 = [self centerFormPathNode:pointArray[index + 2]];;
        
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
    [path addLineToPoint:[self centerFormPathNode:[pointArray lastObject]]];
    
    return path;
}

- (CGPoint)centerFormPathNode:(PathNode *)node{
    
    CGRect pointRect =CGPathGetBoundingBox(node.path.CGPath);
    
    CGPoint point =CGPointMake(CGRectGetMidX(pointRect), CGRectGetMidY(pointRect));
    
    return point;
}

@end
