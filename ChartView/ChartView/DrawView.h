//
//  DrawView.h
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DrawNode.h"

@interface DrawView :UIView

@property (retain ,nonatomic) NSMutableArray <DrawNode *> *nodeArray;

@property (retain ,nonatomic) NSMutableArray <TouchNode *> *touchArray;

/**
 是否异步 默认异步
 */
@property (assign ,nonatomic) IBInspectable BOOL displaysAsynchronously;

@end


