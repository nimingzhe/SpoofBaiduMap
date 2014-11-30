//
//  ViewController.m
//  My Baidu Map
//
//  Created by work on 14/11/29.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.zoomLevel=18;
    
    
    
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    _geoCodeSearch=[[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


- (IBAction)genSuiAction:(id)sender {
    self.luoPanButton.hidden=NO;
    self.genSuiButton.hidden=YES;
    
    self.mapView.showsUserLocation=NO;
    self.mapView.userTrackingMode=BMKUserTrackingModeFollow;
    self.mapView.showsUserLocation=YES;
}

- (IBAction)luoPanAction:(id)sender {
    self.luoPanButton.hidden=YES;
    self.genSuiButton.hidden=NO;
    
    self.mapView.showsUserLocation=NO;
    self.mapView.userTrackingMode=BMKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation=YES;
}

- (IBAction)zoomInAction:(id)sender {
    [self.mapView zoomIn];
}

- (IBAction)zoomOutAction:(id)sender {
    [self.mapView zoomOut];
}

- (IBAction)luKuangAction:(id)sender {
    if (self.luKuangButton.tag==0) {
        [_mapView setMapType:BMKMapTypeTrafficOn];
        self.luKuangButton.tag=1;
        [self.luKuangButton setTitle:@"关闭路况图" forState:UIControlStateNormal];
    }
    else
    {
        [_mapView setMapType:BMKMapTypeStandard];
        self.luKuangButton.tag=0;
        [self.luKuangButton setTitle:@"打开路况图" forState:UIControlStateNormal];
    }
    
}

- (IBAction)searchAction:(id)sender
{
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = _locService.userLocation.location.coordinate;
    
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}

#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"地址：%@",result.address);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"地址：%@",result.address);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


#pragma mark BMKLocationServiceDelegate

- (void)willStartLocatingUser
{
    NSLog(@"willStartLocatingUser");
}

- (void)didStopLocatingUser
{
    NSLog(@"didStopLocatingUser");
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    
    
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    [_mapView updateLocationData:userLocation];
    
}


@end
