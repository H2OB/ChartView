//
//  NSNumber+Helper.m
//  OneApp
//
//  Created by North on 2019/6/30.
//  Copyright © 2019 North. All rights reserved.
//

#import "NSNumber+Helper.h"

@implementation NSNumber (Helper)

// 离某个整数 * 10 n次方 最大的数
- (double)nearbyNumFromBase:(NSInteger)num{
    
    long long intValue = [self unsignedLongLongValue];
    
    NSString *intString = @(intValue).stringValue;
    
    double baseNum = intString.length > 1 ?  pow(10, intString.length - 2) * num : num;
    
    long long fiveNum  =  [@(baseNum)longLongValue];
    
    long long value = intValue / fiveNum;
    
    if(intValue % fiveNum > 0) value += 1;
    
    long long  nearValue = value * fiveNum;
    
    if(self < 0) nearValue = -nearValue;
    
    return [@(nearValue) doubleValue];
}
- (NSString *)stringWithdecimals:(NSUInteger)decimals{
    
    NSString *formart = @"###,###";
    for (NSUInteger index = 0 ; index < decimals ; index ++) {
        if (![formart containsString:@"."]) {
            formart = [formart stringByAppendingString:@"."];
        }
        formart = [formart stringByAppendingString:@"0"];
    }
    formart = [formart stringByAppendingString:@";"];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:formart];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:self];
    
    return formattedNumberString;
}


@end
