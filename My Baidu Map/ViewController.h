//
//  ViewController.h
//  My Baidu Map
//
//  Created by work on 14/11/29.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface ViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geoCodeSearch;
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *genSuiButton;
@property (weak, nonatomic) IBOutlet UIButton *luoPanButton;
@property (weak, nonatomic) IBOutlet UIButton *luKuangButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


- (IBAction)genSuiAction:(id)sender;
- (IBAction)luoPanAction:(id)sender;
- (IBAction)zoomInAction:(id)sender;
- (IBAction)zoomOutAction:(id)sender;
- (IBAction)luKuangAction:(id)sender;
- (IBAction)searchAction:(id)sender;

@end

