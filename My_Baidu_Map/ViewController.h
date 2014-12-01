//
//  ViewController.h
//  My Baidu Map
//
//  Created by work on 14/11/29.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

#define searchFlag 1
#define getCurrentLocationFlag 2

@interface ViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UITextFieldDelegate>
{
    //定位
    BMKLocationService* _locService;
    
    //地理编码
    BMKGeoCodeSearch* _geoCodeSearch;
    NSString *_currentCity;
    int geoCodeFlag;
    
    //poi检索
    int _curPage;
    BMKPoiSearch* _poiSearch;
    NSArray *_poiArray;
    NSInteger _currentPoiIndex;
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *genSuiButton;
@property (weak, nonatomic) IBOutlet UIButton *luoPanButton;
@property (weak, nonatomic) IBOutlet UIButton *luKuangButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *poiAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *poiDetailView;

- (IBAction)genSuiAction:(id)sender;
- (IBAction)luoPanAction:(id)sender;
- (IBAction)zoomInAction:(id)sender;
- (IBAction)zoomOutAction:(id)sender;
- (IBAction)luKuangAction:(id)sender;
- (IBAction)goToPoiAction:(id)sender;
- (IBAction)nextPoiAction:(id)sender;

@end

