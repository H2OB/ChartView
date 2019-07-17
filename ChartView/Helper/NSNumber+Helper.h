//
//  NSNumber+Helper.h
//  OneApp
//
//  Created by North on 2019/6/30.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Helper)

// 离某个整数 * 10 n次方 最大的数
- (double)nearbyNumFromBase:(NSInteger)num;

// 千分位格式化数组 保留几位小数
- (NSString *)stringWithdecimals:(NSUInteger)decimals;

@end

NS_ASSUME_NONNULL_END
