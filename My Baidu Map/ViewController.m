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
    
    
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
}


@end
