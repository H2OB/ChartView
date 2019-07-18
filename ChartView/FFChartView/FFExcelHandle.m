//
//  FFExcelHandle.m
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import "FFExcelHandle.h"
#import "NSMutableAttributedString+Helper.h"
#import "FFDrawNode.h"

@interface FFExcelHandle ()

@property (retain ,nonatomic) FFRowHandle *headHandle;

@end
@implementation FFExcelHandle

- (instancetype)initWithInitSize:(CGSize)size{
    
    self = [super init];
    
    if (self) {
        
        self.initSize = size;
        
        self.headNodes = @[].mutableCopy;
        self.contentNodes = @[].mutableCopy;
        self.groupNodes = @[].mutableCopy;
        self.contentNodes = @[].mutableCopy;
        self.titleNodes = @[].mutableCopy;
        self.rowArray = @[].mutableCopy;
    }
    
    return self;
}


- (void)configHeadHandele:(FFRowHandle *)handle{
    
    self.headHandle = handle;
}

- (void)beginCalculate{
    
    //计算
    
    CGFloat titleMaxWidth = 0;
    CGFloat headHeight = 0;
    CGFloat valueTextWidth = 0;
    
    NSInteger rowNum = MIN(self.rowArray.count, self.visibleRowNum);
    FFRowHandle * headHandle = self.headHandle ? self.headHandle : [self.rowArray firstObject];
    NSInteger columnNum = MIN(headHandle.valueArray.count, self.visibleColumnNum);
    
    NSInteger totalColumn = headHandle.valueArray.count;
    
    
#pragma mark - 计算每行的title的最大宽度 他将是title的宽度
    for (FFRowHandle * row in self.rowArray) {
        
        NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:row.title font:row.textFont color:row.textColor];
        
        CGFloat textWidth = [attrString sizeForContainerSize:CGSizeMake(self.titleWidth, self.titleHeight)].width;
        titleMaxWidth = titleMaxWidth < textWidth ? textWidth : titleMaxWidth;
    }
    
    //计算右边文字宽度
    valueTextWidth = (self.initSize.width - titleMaxWidth - self.titleValueSpeace - (columnNum  - 1) * self.valueSpeace)/columnNum;
    
#pragma mark - 计算headview 最大高度
    if(self.headHandle){
        {
            
            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:self.headHandle.title font:self.headHandle.titleFont color:self.headHandle.titleColor];
            
            CGFloat textHeight = [attrString sizeForContainerSize:CGSizeMake(titleMaxWidth, self.titleHeight)].height;
            
            headHeight = headHeight < textHeight ? textHeight : headHeight;
        }
        
        for (NSString * string in self.headHandle.valueArray) {
            
            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:string font:self.headHandle.textFont color:self.headHandle.textColor];
            
            CGFloat textHeight = [attrString sizeForContainerSize:CGSizeMake(valueTextWidth, CGFLOAT_MAX)].height;
            
            headHeight = headHeight < textHeight ? textHeight : headHeight;
            
        }
        
        headHeight += 2 * self.headHandle.verticalMagin;
        
    }
    
#pragma mark - 设置frame
    
    CGFloat frameW = titleMaxWidth + self.titleValueSpeace + columnNum * valueTextWidth + (columnNum - 1 ) * self.valueSpeace;
    
    CGFloat frameH = headHeight + rowNum * self.rowHeight;
    
    CGFloat contentW = titleMaxWidth + self.titleValueSpeace + totalColumn * valueTextWidth + (totalColumn - 1 ) * self.valueSpeace;
    
    CGFloat contentH = headHeight + self.rowArray.count * self.rowHeight;
    
    self.finalSize = CGSizeMake(frameW, frameH);
    self.scrollviewFrame = CGRectMake(0, 0, frameW, frameH);
    self.contentSize = CGSizeMake(contentW, contentH);
    self.titleFrame = CGRectMake(0, 0, titleMaxWidth, headHeight);
    self.headFrame = CGRectMake(titleMaxWidth, 0, self.contentSize.width - titleMaxWidth, headHeight);
    self.groupFrame = CGRectMake(0, headHeight, titleMaxWidth, self.contentSize.height - headHeight);
    
    self.contentFrame = CGRectMake(titleMaxWidth, headHeight, self.contentSize.width - titleMaxWidth, self.contentSize.height - headHeight);
    
#pragma mark - 设置node
    
    
    //绘制head
    if(self.headHandle){
        
        
        if(self.headHandle.backgroudColor){
            
            //titleView
            {
                UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.titleFrame), CGRectGetHeight(self.titleFrame))];
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:self.headHandle.backgroudColor strokeColor:nil];
                
                [self.titleNodes addObject:node];
            }
            //headView
            {
                UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.headFrame), CGRectGetHeight(self.headFrame))];
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:self.headHandle.backgroudColor strokeColor:nil];
                
                [self.headNodes addObject:node];
            }
            
        }
        
        if(self.separatorColor && self.separatorWidth > CGFLOAT_MIN){
            
            CGFloat lineWidht = self.separatorWidth/[UIScreen mainScreen].scale;
            
            //titleView
            {
                
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(CGRectGetWidth(self.titleFrame) - lineWidht/2.0, 0)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(self.titleFrame) - lineWidht/2.0, CGRectGetHeight(self.titleFrame))];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.separatorColor];
                
                [self.titleNodes addObject:node];
                
            }
            
        }
        
        
        if(self.headHandle.separatorColor && self.headHandle.separatorWidth > CGFLOAT_MIN){
            
            CGFloat lineWidht = self.headHandle.separatorWidth/[UIScreen mainScreen].scale;
            
            //titleView
            {
                
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.titleFrame) - lineWidht/2.0)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(self.titleFrame), CGRectGetHeight(self.titleFrame) - lineWidht/2.0)];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.headHandle.separatorColor];
                
                
                [self.titleNodes addObject:node];
                
            }
            {
                
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.headFrame) - lineWidht/2.0)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(self.headFrame), CGRectGetHeight(self.headFrame) - lineWidht/2.0)];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.headHandle.separatorColor];
                
                [self.headNodes addObject:node];
                
            }
            
            
        }
        
        //文字
        {
            
            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:self.headHandle.title font:self.headHandle.titleFont color:self.headHandle.titleColor];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = self.headHandle.titleTextAlignment;
            [attrString setAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, attrString.string.length)];
            
            FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:CGSizeMake(titleMaxWidth, CGRectGetHeight(self.headFrame)) origin:CGPointZero];
            
            CGRect rect = node.rect;
            
            if(self.headHandle.titleTextAlignment == NSTextAlignmentLeft){
                
                rect.origin.x = 0;
                rect.origin.y = CGRectGetHeight(self.headFrame)/2.0 -rect.size.height/2.0;
            }
            
            if(self.headHandle.titleTextAlignment == NSTextAlignmentCenter){
                
                rect.origin.x = titleMaxWidth/2.0 -rect.size.width/2.0;;
                rect.origin.y = CGRectGetHeight(self.headFrame)/2.0 -rect.size.height/2.0;
            }
            
            if(self.headHandle.titleTextAlignment == NSTextAlignmentRight){
                
                rect.origin.x = titleMaxWidth -rect.size.width/2.0;;
                rect.origin.y = CGRectGetHeight(self.headFrame)/2.0 -rect.size.height/2.0;
                
            }
            
            node.rect = rect;
            
            [self.titleNodes addObject:node];
            
        }
        
        [self.headHandle.valueArray enumerateObjectsUsingBlock:^(NSString * string, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat valueX = self.titleValueSpeace + idx *(valueTextWidth + self.valueSpeace);
            {
                
                NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:string font:self.headHandle.textFont color:self.headHandle.textColor];
                
                NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.alignment = self.headHandle.valueTextAlignment;
                [attrString setAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, attrString.string.length)];
                
                FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:CGSizeMake(valueTextWidth, CGRectGetHeight(self.headFrame)) origin:CGPointZero];
                
                CGRect rect = node.rect;
                
                if(self.headHandle.valueTextAlignment == NSTextAlignmentLeft){
                    
                    rect.origin.x = valueX;
                    rect.origin.y = CGRectGetHeight(self.headFrame)/2.0 -rect.size.height/2.0;
                }
                
                if(self.headHandle.valueTextAlignment == NSTextAlignmentCenter){
                    
                    rect.origin.x = valueX + valueTextWidth/2.0 -rect.size.width/2.0;;
                    rect.origin.y = CGRectGetHeight(self.headFrame)/2.0 -rect.size.height/2.0;
                }
                
                if(self.headHandle.valueTextAlignment == NSTextAlignmentRight){
                    
                    rect.origin.x = valueX + valueTextWidth -rect.size.width;
                    rect.origin.y = CGRectGetHeight(self.headFrame)/2.0 -rect.size.height/2.0;
                    
                }
                
                node.rect = rect;
                
                [self.headNodes addObject:node];
            }
            
            if(self.separatorWidth >CGFLOAT_MIN && self.separatorColor && idx < self.headHandle.valueArray.count -1)
            {
                CGFloat lineWidht = self.separatorWidth/[UIScreen mainScreen].scale;
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(valueX + valueTextWidth - lineWidht/2.0, 0)];
                [path addLineToPoint:CGPointMake(valueX + valueTextWidth - lineWidht/2.0, CGRectGetHeight(self.headFrame))];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.separatorColor];
                
                [self.headNodes addObject:node];
                
            }
            
            
            
        }];
        
    }
    
    
    
    
    
    
    [self.rowArray enumerateObjectsUsingBlock:^(FFRowHandle *FFRowHandle, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat contentY = idx * self.rowHeight;
        
        if(FFRowHandle.backgroudColor){
            
            //groupView
            {
                
                UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, contentY, CGRectGetWidth(self.groupFrame), self.rowHeight)];
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:FFRowHandle.backgroudColor strokeColor:nil];
                
                [self.groupNodes addObject:node];
                
            }
            //contentView
            {
                
                UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, contentY, CGRectGetWidth(self.contentFrame), self.rowHeight)];
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:FFRowHandle.backgroudColor strokeColor:nil];
                
                [self.contentNodes addObject:node];
                
            }
            
            
            
        }
        
        if(FFRowHandle.separatorColor && FFRowHandle.separatorWidth > CGFLOAT_MIN){
            
            {
                
                CGFloat lineWidht = FFRowHandle.separatorWidth/[UIScreen mainScreen].scale;
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, contentY +self.rowHeight - lineWidht/2.0)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(self.groupFrame), contentY +self.rowHeight - lineWidht/2.0)];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:FFRowHandle.separatorColor];
                
                [self.groupNodes addObject:node];
                
            }
            
            {
                
                CGFloat lineWidht = FFRowHandle.separatorWidth/[UIScreen mainScreen].scale;
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, contentY +self.rowHeight - lineWidht/2.0)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(self.contentFrame), contentY +self.rowHeight - lineWidht/2.0)];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:FFRowHandle.separatorColor];
                
                [self.contentNodes addObject:node];
                
            }
            
            
            
        }
        
        {
            
            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:FFRowHandle.title font:FFRowHandle.titleFont color:FFRowHandle.titleColor];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = FFRowHandle.titleTextAlignment;
            [attrString setAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, attrString.string.length)];
            
            FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:CGSizeMake(titleMaxWidth, CGRectGetHeight(self.headFrame)) origin:CGPointZero];
            
            CGRect rect = node.rect;
            
            if(FFRowHandle.titleTextAlignment == NSTextAlignmentLeft){
                
                rect.origin.x = 0;
                rect.origin.y = contentY + self.rowHeight/2.0 -rect.size.height/2.0;
            }
            
            if(FFRowHandle.titleTextAlignment == NSTextAlignmentCenter){
                
                rect.origin.x = titleMaxWidth/2.0 -rect.size.width/2.0;;
                rect.origin.y = contentY + self.rowHeight/2.0 -rect.size.height/2.0;
            }
            
            if(FFRowHandle.titleTextAlignment == NSTextAlignmentRight){
                
                rect.origin.x = titleMaxWidth -rect.size.width/2.0;;
                rect.origin.y = contentY + self.rowHeight/2.0 -rect.size.height/2.0;
                
            }
            
            node.rect = rect;
            
            [self.groupNodes addObject:node];
            
        }
        
        [FFRowHandle.valueArray enumerateObjectsUsingBlock:^(NSString * string, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat valueX = self.titleValueSpeace + idx *(valueTextWidth + self.valueSpeace);
            
            NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:string font:FFRowHandle.textFont color:FFRowHandle.textColor];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = FFRowHandle.valueTextAlignment;
            [attrString setAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, attrString.string.length)];
            
            FFTextNode * node = [FFTextNode initWithAttrString:attrString angle:0 size:CGSizeMake(valueTextWidth, CGRectGetHeight(self.headFrame)) origin:CGPointZero];
            
            CGRect rect = node.rect;
            
            if(FFRowHandle.valueTextAlignment == NSTextAlignmentLeft){
                
                rect.origin.x = valueX;
                rect.origin.y = contentY + self.rowHeight/2.0 -rect.size.height/2.0;
            }
            
            if(FFRowHandle.valueTextAlignment == NSTextAlignmentCenter){
                
                rect.origin.x = valueX + valueTextWidth/2.0 -rect.size.width/2.0;;
                rect.origin.y = contentY + self.rowHeight/2.0 -rect.size.height/2.0;
            }
            
            if(FFRowHandle.valueTextAlignment == NSTextAlignmentRight){
                
                rect.origin.x = valueX + valueTextWidth -rect.size.width;
                rect.origin.y = contentY + self.rowHeight/2.0 -rect.size.height/2.0;
                
            }
            
            node.rect = rect;
            
            [self.contentNodes addObject:node];
            
        }];
        
        
    }];
    
    if(self.separatorWidth > CGFLOAT_MIN && self.separatorColor){
        
        CGFloat lineWidht = self.separatorWidth/[UIScreen mainScreen].scale;
        
        //groupView
        {
            
            
            UIBezierPath * path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetWidth(self.groupFrame) - lineWidht/2.0, 0)];
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.groupFrame), CGRectGetHeight(self.groupFrame) )];
            path.lineWidth = lineWidht;
            
            FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.separatorColor];
            
            
            [self.groupNodes addObject:node];
            
        }
        
        [headHandle.valueArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat valueX = self.titleValueSpeace + idx *(valueTextWidth + self.valueSpeace);
            
            if(idx < headHandle.valueArray.count -1){
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(valueX + valueTextWidth - lineWidht/2.0, 0)];
                [path addLineToPoint:CGPointMake(valueX + valueTextWidth - lineWidht/2.0, CGRectGetHeight(self.contentFrame))];
                path.lineWidth = lineWidht;
                
                FFPathNode * node = [FFPathNode initWithPath:path fillColor:nil strokeColor:self.separatorColor];
                
                [self.contentNodes addObject:node];
            }
            
        }];
        
        
    }
    
}


@end

@implementation FFRowHandle

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.valueArray = @[].mutableCopy;
        
    }
    
    return self;
}

@end
