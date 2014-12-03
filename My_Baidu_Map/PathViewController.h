//
//  PathViewController.h
//  My Baidu Map
//
//  Created by Han's MacBook Pro on 14/12/2.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface PathViewController : UIViewController <BMKRouteSearchDelegate>
{
    BMKRouteSearch* _routeSearch;
}
@property BMKPoiInfo *desPoi;
@property BMKUserLocation *currentLocation;
@property NSString *city;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

- (IBAction)cancelAction:(id)sender;
- (IBAction)busAction:(id)sender;
- (IBAction)driveAction:(id)sender;
- (IBAction)walkAction:(id)sender;

@end
