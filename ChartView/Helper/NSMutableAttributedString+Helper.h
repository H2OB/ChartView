//
//  NSMutableAttributedString+Helper.h
//  OneApp
//
//  Created by North on 2019/6/14.
//  Copyright © 2019 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSMutableAttributedString (Helper)

+ (instancetype)initWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

- (void)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

- (CGSize)sizeForContainerSize:(CGSize)size;
@end


