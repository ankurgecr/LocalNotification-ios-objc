//
//  AppDelegate.h
//  TestTimer
//
//  Created by INT MAC 2015 on 25/10/18.
//  Copyright © 2018 INT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property NotificationHelper *notificationHelper;
@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic) NSMutableArray *arrNotificationData;

@end

