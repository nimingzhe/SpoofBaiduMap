//
//  PathViewController.m
//  My Baidu Map
//
//  Created by Han's MacBook Pro on 14/12/2.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import "PathViewController.h"
#import "ViewController.h"

@interface PathViewController ()

@end

@implementation PathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _routeSearch = [[BMKRouteSearch alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _routeSearch.delegate=self;
    
    [self.startButton setTitle:@"我的位置" forState:UIControlStateNormal];
    [self.endButton setTitle:self.desPoi.name forState:UIControlStateNormal] ;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    _routeSearch.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelAction:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)busAction:(id)sender {
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.pt = self.currentLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
    end.pt = self.desPoi.pt;
    BMKTransitRoutePlanOption *transitRouteSearchOption =[[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    transitRouteSearchOption.city=_city;
    BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}

- (IBAction)driveAction:(id)sender {
}

- (IBAction)walkAction:(id)sender {
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
    // 计算路线方案中的路段数目
    int size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        NSLog(@"换乘信息：%@",transitStep.instruction);
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    ViewController *vc=(ViewController*)self.parentViewController;
    [self.view removeFromSuperview];
    [vc drawPath:polyLine];
    [vc.mapView setCenterCoordinate:polyLine.coordinate];
    [vc.mapView setVisibleMapRect:polyLine.boundingMapRect];
    [self removeFromParentViewController];
    
}

@end
