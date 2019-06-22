//
//  BaseView.m
//  OneApp
//
//  Created by North on 2019/5/30.
//  Copyright © 2019 North. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        [self setUpView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self setUpView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        [self setUpView];
    }
    
    return self;
}


- (void)setUpView{
    
    
}

@end
