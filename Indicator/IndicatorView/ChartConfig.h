//
//  ChartConfig.h
//  OneApp
//
//  Created by North on 2019/6/22.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface ChartConfig : NSObject

@property (assign ,nonatomic) CGSize size;//大小
@property (assign ,nonatomic) BOOL showBubblu;//弹出说明

@property (retain ,nonatomic) UIFont *groupFont;
@property (retain ,nonatomic) UIFont *scaleFont;
@property (retain ,nonatomic) UIFont *valueFont;

@property (retain ,nonatomic) UIColor *groupColor;
@property (retain ,nonatomic) UIColor *scaleColor;
@property (retain ,nonatomic) UIColor *valueColor;


@end



