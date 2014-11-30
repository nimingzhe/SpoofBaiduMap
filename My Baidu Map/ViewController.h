//
//  ViewController.h
//  My Baidu Map
//
//  Created by work on 14/11/29.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface ViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService* _locService;
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *genSuiButton;
@property (weak, nonatomic) IBOutlet UIButton *luoPanButton;

- (IBAction)genSuiAction:(id)sender;
- (IBAction)luoPanAction:(id)sender;
- (IBAction)zoomInAction:(id)sender;
- (IBAction)zoomOutAction:(id)sender;

@end

