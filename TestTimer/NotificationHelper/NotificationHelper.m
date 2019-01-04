#import "NotificationHelper.h"
#import "AppDelegate.h"

@implementation NotificationHelper

#pragma
#pragma Init
-(id) init {
    self = [super init];
    if (self) {
        _arrNotificationData = [[NSMutableArray alloc] init];
        _center = [UNUserNotificationCenter currentNotificationCenter];
        [_center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                               completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                   if (!error) {
                                       NSLog(@"request succeeded!");
                                       //[self testAlrt];
                                   }
                               }
        ];
    }
    return self;
}

#pragma
#pragma Get All Notifications
-(NSMutableArray*) getAllNotifiations {
    return _arrNotificationData;
}

#pragma
#pragma Get All pending request
-(void) getPendinngRequestArray {
    __block  NSArray * arr;
    [[UNUserNotificationCenter currentNotificationCenter]getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"count%lu",(unsigned long)requests.count);
        if (requests.count>0) {
            arr = [[NSArray alloc] initWithArray:requests];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ArrayReceivedNotification"
             object:arr];
        }
    }];
}

#pragma
#pragma  Notification Scheduled
-(bool) isNotificaitonScheduled:(NSMutableArray*)array nID:(NSString*)nID {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(int i=0;i<array.count;i++){
        UNNotificationRequest *pendingRequest = [array objectAtIndex:i];
        NSLog(@"Request:%@",pendingRequest.identifier);
        if( [pendingRequest.identifier isEqualToString:nID]){
            [tempArray addObject:@"1"];
        }
        else{
            [tempArray addObject:@"0"];
        }
    }
    if([tempArray containsObject:@"1"])
        return true;
    else
        return false;
}


#pragma
#pragma Cancel notification
- (void) cancelNotification:(int) id {
    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:_arrNotificationData[id][@"id"], nil];
     [_center removePendingNotificationRequestsWithIdentifiers:arr];
     [_arrNotificationData removeObjectAtIndex:id];
}

- (void) cancelALLLocalNotification {
    [_center removeAllPendingNotificationRequests];
    [_arrNotificationData removeAllObjects];
}

#pragma
#pragma Schedule Notification
-(void) scheduleNotification: (NSString *)id  title:(NSString *)title body:(NSString *)body hour:(int)hour min:(int)min isRepeat:(BOOL)isRepeat {
    
    //Cancel if the notificaiton is already schedule, so it can be overrided safely
    // [cancelNotification id:id];
    UNMutableNotificationContent *objNotificationContent    = [[UNMutableNotificationContent alloc] init];
    //UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    if (_isfromEdit == 1) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:_arrNotificationData[_itemIndex][@"id"], nil];
        [_center removePendingNotificationRequestsWithIdentifiers:arr];
        [_arrNotificationData removeObjectAtIndex:_itemIndex];
    }
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate* newDate = [[NSDate date] dateByAddingTimeInterval:(hour*60*60)+(min*60)];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:newDate];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:isRepeat];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:id content:objNotificationContent trigger:trigger];
    [_center addNotificationRequest:request withCompletionHandler:nil];
    
    NSMutableDictionary *dictSaveData =[[NSMutableDictionary alloc] init];
    dictSaveData[@"title"]   = title;
    dictSaveData[@"id"]      = id;
    dictSaveData[@"notificationText"] = body;
    dictSaveData[@"hr"]      = [NSString stringWithFormat:@"%d",hour];
    dictSaveData[@"min"]     = [NSString stringWithFormat:@"%d",min];
    dictSaveData[@"isRepeat"] = [NSNumber numberWithBool:isRepeat];
    [_arrNotificationData addObject:dictSaveData];
}

@end
