//
//  NSMutableAttributedString+Helper.m
//  OneApp
//
//  Created by North on 2019/6/14.
//  Copyright © 2019 North. All rights reserved.
//

#import "NSMutableAttributedString+Helper.h"

@implementation NSMutableAttributedString (Helper)

+ (instancetype)initWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSMutableDictionary * attrDic = @{}.mutableCopy;
    if(font)[attrDic setValue:font forKey:NSFontAttributeName];
    if(color)[attrDic setValue:color forKey:NSForegroundColorAttributeName];
    [attrString setAttributes:attrDic range:NSMakeRange(0, attrString.string.length)];
    
    
    return attrString;
}

- (void)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color{
    
    NSMutableAttributedString * attrString = [NSMutableAttributedString initWithString:string font:font color:color];
    
    [self appendAttributedString:attrString];
}

- (CGSize)sizeForContainerSize:(CGSize)size{
    
     return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
}
@end
