//
//  DrawView.h
//  Indicator
//
//  Created by North on 2019/6/11.
//  Copyright © 2019 North. All rights reserved.
//


#import "BaseView.h"
#import "DrawNode.h"

@interface DrawView :BaseView

@property (retain ,nonatomic) NSMutableArray <DrawNode *> *nodeArray;

@property (assign ,nonatomic) IBInspectable BOOL superDraw;

@end


