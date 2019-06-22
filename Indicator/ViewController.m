//
//  ViewController.m
//  Indicator
//
//  Created by North on 2019/5/30.
//  Copyright © 2019 North. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ChartView *chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchData];
}

- (void)fetchData{
    
    NodeHandle *handle = [NodeHandle nodeFromBar];
    self.chartView.handle = handle;
    
}


@end

