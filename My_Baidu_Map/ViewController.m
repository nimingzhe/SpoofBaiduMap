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
    
    self.searchTextField.delegate=self;
    
    self.mapView.zoomLevel=18;
    
    _locService = [[BMKLocationService alloc] init];
    
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    _geoCodeSearch=[[BMKGeoCodeSearch alloc] init];
    
    _poiSearch=[[BMKPoiSearch alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoCodeSearch.delegate=self;
    _poiSearch.delegate = self;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
   
}

- (void)dealloc
{
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geoCodeSearch.delegate=nil;
    _poiSearch.delegate = nil;
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



- (IBAction)goToPoiAction:(id)sender {
    pathVC=[self.storyboard instantiateViewControllerWithIdentifier:@"path"];
    pathVC.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    pathVC.desPoi=_poiArray[_currentPoiIndex];
    pathVC.currentLocation=_locService.userLocation;
    pathVC.city=_currentCity;
    [self addChildViewController:pathVC];
    [self.view addSubview:pathVC.view];
}

- (IBAction)nextPoiAction:(id)sender {
    _currentPoiIndex++;
    if (_currentPoiIndex<[_poiArray count]) {
        BMKPoiInfo* tempPoi=_poiArray[_currentPoiIndex];
        self.poiAddressLabel.text=tempPoi.name;
        _mapView.centerCoordinate = tempPoi.pt;
//        NSLog(@"tempoi.pt x:%f,y:%f",tempPoi.pt.latitude,tempPoi.pt.longitude);
//        NSLog(@"_mapView.centerCoordinate x:%f,y:%f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
    }
    else
    {
        _currentPoiIndex=0;
        BMKPoiInfo* tempPoi=_poiArray[_currentPoiIndex];
        self.poiAddressLabel.text=tempPoi.name;
        _mapView.centerCoordinate = tempPoi.pt;
        NSLog(@"tempoi.pt x:%f,y:%f",tempPoi.pt.latitude,tempPoi.pt.longitude);
        NSLog(@"_mapView.centerCoordinate x:%f,y:%f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
    }
}

#pragma mark Public Method
- (void)drawPath:(BMKPolyline*)pol
{
    if(pol==nil)
    {
        NSLog(@"pol is nil");
    }
    else
    {
        NSLog(@"点数：%d",pol.pointCount);
    }
    
    [_mapView addOverlay:pol]; // 添加路线overlay
}

#pragma mark BMKMapViewDelegate
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    [self.searchTextField endEditing:YES];
    
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
    geoCodeFlag=searchFlag;
    
    return YES;
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        self.poiDetailView.hidden=NO;
        _poiArray=result.poiInfoList;
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
                self.poiAddressLabel.text=poi.name;
                _currentPoiIndex=0;
            }
            
        }
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
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
        switch (geoCodeFlag) {
            case searchFlag:
            {
                //获得当前城市
                if (result.address==nil) {
                    NSLog(@"无地址");
                    return;
                }
                NSArray *firstArray=[result.address componentsSeparatedByString:@"省"];
                NSArray *cityComp=[(NSString*)firstArray[1] componentsSeparatedByString:@"市"];
                _currentCity=cityComp[0];
                //搜索地点
                BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
                citySearchOption.pageIndex = _curPage;
                citySearchOption.pageCapacity = 10;
                citySearchOption.city= _currentCity;
                citySearchOption.keyword = self.searchTextField.text;
                NSLog(@"城市：%@，关键字：%@,_curpage:%d",citySearchOption.city,citySearchOption.keyword,_curPage);
                BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
                
                if(flag)
                {
                    
                    NSLog(@"城市内检索发送成功");
                }
                else
                {
                    
                    NSLog(@"城市内检索发送失败");
                }
                
            }
                break;
            
            case getCurrentLocationFlag:
            {
                
            }
                break;
                
            default:
                break;
        }
        
        
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
