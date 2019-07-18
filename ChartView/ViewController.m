//
//  ViewController.m
//  ChartView
//
//  Created by North on 2019/6/22.
//  Copyright © 2019 North. All rights reserved.
//

#import "ViewController.h"
#import "FFChartView.h"
#import "FFChartHandle.h"
#import "FFExcelView.h"
#import "FFExcelHandle.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet FFChartView *chartView;
@property (weak, nonatomic) IBOutlet FFExcelView *excelView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self showChartView];
    
    [self showExcelView];
    
}


- (void)showChartView{
    
    NSArray * valueArray = @[@(10000),@(400),@(466),@(200),@(700),@(400),@(612),@(200)];
    NSArray * groupArray = @[@"一月中国银行债券",@"二月中国银行债券",@"三月中国银行债券",@"四月中国银行债券",@"五月中国银行债券",@"六月中国银行债券",@"七月中国银行债券",@"八月中国银行债券"];
    
//    NSArray * groupArray = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月"];
    
    
    LineHandle *lineHandle = [[LineHandle alloc]init];
    lineHandle.displayType = DisplayTypeShowLimit; //全部显示文字
    lineHandle.textFont = [UIFont systemFontOfSize:12];
    lineHandle.textColor = [UIColor blueColor];
    lineHandle.decimals = 2;
    lineHandle.unit = @"个";
    lineHandle.lineColor = [UIColor blueColor];
    lineHandle.lineWidth = 1;
    lineHandle.Smooth = NO;
    lineHandle.insideColor = [UIColor blueColor];
    lineHandle.insideRadius = 3;
    lineHandle.descString = @"折线图";
    
    [lineHandle.valueArray  addObjectsFromArray:valueArray];
    
    
    BarHandle * barHandle = [[BarHandle alloc]init];
    
    
    barHandle.textFont = [UIFont systemFontOfSize:12];
    barHandle.textColor = [UIColor blueColor];
    barHandle.decimals = 2;
    barHandle.unit = @"个";
    barHandle.fillColor = [UIColor blueColor];
    barHandle.barWidth = 20;
    barHandle.descString = @"柱状图";
   
    [barHandle.valueArray  addObjectsFromArray:valueArray];
    
    GroupHandle * groupHandle = [[GroupHandle alloc]init];
    
    groupHandle.textFont = [UIFont systemFontOfSize:12];
    groupHandle.textColor = [UIColor redColor];
    groupHandle.adapeType = TextAdaptTypeFixedRadianWidthRotate;
    groupHandle.textWidth = 50;
//    groupHandle.displayType = DisplayTypeNone;
    groupHandle.groupNum = 5; //屏幕显示几条数据
    groupHandle.textArray = groupArray.mutableCopy;
    groupHandle.spacing = 40;
    groupHandle.radian = M_PI_4;
    groupHandle.textWidth = 70;
    
    ScaleHandle * scaleHandle = [[ScaleHandle alloc]init];
    scaleHandle.adapeType = TextAdaptTypeFixed;
    scaleHandle.location = ScaleLocationLeft;
//    scaleHandle.displayType = DisplayTypeNone;
    scaleHandle.textFont = [UIFont systemFontOfSize:12];
    scaleHandle.textColor = [UIColor blackColor];
    scaleHandle.scaleNum =4;
    scaleHandle.spacing = 60;
    scaleHandle.unit = @"个";
    scaleHandle.decimals = 0;
    scaleHandle.lineWidth = 1;
    scaleHandle.lineColor = UIColor.redColor;
    scaleHandle.barSpeace =5;
    scaleHandle.textWidth = 40;
    
    scaleHandle.barStyle = MutableBarDisplayStyleStack;
    
    [scaleHandle.lineArray addObject:lineHandle];
    
//    {
//
//        BarHandle * barHandle = [[BarHandle alloc]init];
//
//        barHandle.textFont = [UIFont systemFontOfSize:12];
//        barHandle.textColor = [UIColor greenColor];
//        barHandle.decimals = 2;
//        barHandle.unit = @"个";
////        barHandle.fillColor = [UIColor greenColor];
//        barHandle.startColor = UIColor.orangeColor;
//        barHandle.endColor = [UIColor.orangeColor colorWithAlphaComponent:.1];
//
//        barHandle.barWidth = 5;
//        barHandle.descString = @"柱状图";
//
//
//        [barHandle.valueArray  addObjectsFromArray:valueArray];
//        [scaleHandle.barArray addObject:barHandle];
//    }
//
//    {
//
//        BarHandle * barHandle = [[BarHandle alloc]init];
//
//
//        barHandle.textFont = [UIFont systemFontOfSize:12];
//        barHandle.textColor = [UIColor yellowColor];
//        barHandle.decimals = 2;
//        barHandle.unit = @"个";
//        barHandle.fillColor = [UIColor yellowColor];
//        barHandle.barWidth = 5;
//        barHandle.descString = @"柱状图";
//
//
//        [barHandle.valueArray  addObjectsFromArray:valueArray];
//        [scaleHandle.barArray addObject:barHandle];
//    }
//    {
//
//        BarHandle * barHandle = [[BarHandle alloc]init];
//
//
//        barHandle.textFont = [UIFont systemFontOfSize:12];
//        barHandle.textColor = [UIColor blueColor];
//        barHandle.decimals = 2;
//        barHandle.unit = @"个";
//        barHandle.fillColor = [UIColor blueColor];
//        barHandle.barWidth = 5;
//        barHandle.descString = @"柱状图";
//
//
//        [barHandle.valueArray  addObjectsFromArray:valueArray];
//        [scaleHandle.barArray addObject:barHandle];
//    }
    
    
    
    TipsHandle *tipHandle = [[TipsHandle alloc]init];
    tipHandle.groupTextFont = [UIFont systemFontOfSize:14];
    tipHandle.groupTextColor = [UIColor whiteColor];
    
    tipHandle.valueTextFont = [UIFont systemFontOfSize:10];
    tipHandle.valueTextColor = [UIColor whiteColor];
    
    
    DescHandle * descHandle = [[DescHandle alloc]init];
    descHandle.textFont = [UIFont systemFontOfSize:12];
    descHandle.textColor = [UIColor redColor];
    descHandle.colorRadius = 2;
    descHandle.colorWidth = 10;
    
    descHandle.colorTextSpeace = 4;
    descHandle.nodeSpeace = 10;
    
    
    CGRect frame = CGRectMake(10, 50, self.view.bounds.size.width - 2 * 10, 300);
    FFChartHandle * chartHandle = [[FFChartHandle alloc]initWithAdaptType:AdaptTypeFixedSize initSize:frame.size];
    
    [chartHandle appendScaleHandle:scaleHandle];
    [chartHandle configGroupHandle:groupHandle];
    [chartHandle configTipsHandle:tipHandle];
    [chartHandle configDescHandle:descHandle];
    [chartHandle beginCalculate];
    frame.size = chartHandle.finalSize;
    self.chartView.frame = frame;
    
    self.chartView.handle = chartHandle;
}

- (void)showExcelView{
    
    FFExcelHandle * excelHandle = [[FFExcelHandle alloc]initWithInitSize:CGSizeMake(self.view.bounds.size.width - 2 * 10, 300)];
    excelHandle.titleValueSpeace = 20;
    excelHandle.valueSpeace = 10;
    excelHandle.visibleRowNum = 5;
    excelHandle.visibleColumnNum = 2;
    excelHandle.rowHeight = 44;
    excelHandle.separatorColor = [UIColor lightGrayColor];
    excelHandle.separatorWidth = 1;
    excelHandle.titleWidth = 0;
    excelHandle.titleHeight = 0;
    
    FFRowHandle * handle = [[FFRowHandle alloc]init];
    handle.title = @"我是标题";
    handle.valueArray = @[@"我是分类一",@"我是分类二",@"我是分类三",@"我是分类四",@"我是分类五"].mutableCopy;
    handle.titleFont = [UIFont systemFontOfSize:12];
    handle.titleColor = [UIColor blackColor];
    handle.textFont = [UIFont systemFontOfSize:12];
    handle.textColor = [UIColor blackColor];
    handle.verticalMagin = 5;
    handle.separatorColor = [UIColor lightGrayColor];
    handle.separatorWidth = 1;
    handle.backgroudColor = [UIColor redColor];
    handle.valueTextAlignment = NSTextAlignmentCenter;

    [excelHandle configHeadHandele:handle];
    
    for (NSInteger index = 0;index < 20 ; index ++) {
        
        FFRowHandle * rowHandle = [[FFRowHandle alloc]init];
        rowHandle.title = [@(index).stringValue stringByAppendingString:@"测试名字"];
        rowHandle.valueArray = @[@"我是值一",@"我是值二",@"我是值三",@"我是值四",@"我是值五"].mutableCopy;
        rowHandle.titleFont = [UIFont systemFontOfSize:12];
        rowHandle.titleColor = [UIColor blackColor];
        rowHandle.textFont = [UIFont systemFontOfSize:12];
        rowHandle.textColor = [UIColor blackColor];
        rowHandle.separatorColor = [UIColor lightGrayColor];
        rowHandle.separatorWidth = 1;
        rowHandle.backgroudColor = [UIColor greenColor];
        rowHandle.valueTextAlignment = NSTextAlignmentCenter;
        [excelHandle.rowArray addObject:rowHandle];
        
    }
    [excelHandle beginCalculate];
    self.excelView.handle = excelHandle;
    
    self.excelView.frame = CGRectMake(10, 400, excelHandle.finalSize.width, excelHandle.finalSize.height);
    
    
}

@end
