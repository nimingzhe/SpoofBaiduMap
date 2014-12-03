//
//  AppDelegate.h
//  My Baidu Map
//
//  Created by work on 14/11/29.
//  Copyright (c) 2014年 韩鹏博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
        
}

@property (strong, nonatomic) UIWindow *window;
@property BMKMapManager* mapManager;
@property BOOL isAuthorizationSuccess;;

@end

