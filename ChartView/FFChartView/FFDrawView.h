//
//  FFDrawView.h
//  ChartView
//
//  Created by North on 2019/7/18.
//  Copyright © 2019 North. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDrawNode.h"


@interface FFDrawView : UIView

@property (retain ,nonatomic) NSMutableArray <FFDrawNode *> *nodeArray;

@property (retain ,nonatomic) NSMutableArray <FFTouchNode *> *touchArray;

/**
 是否异步 默认异步
 */
@property (assign ,nonatomic) IBInspectable BOOL displaysAsynchronously;
@end


