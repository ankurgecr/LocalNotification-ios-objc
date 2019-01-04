
#import <UserNotifications/UserNotifications.h>
@interface NotificationHelper :NSObject

  @property UNUserNotificationCenter *center;
  @property int isfromEdit;
  @property int itemIndex;
  @property (nonatomic) NSMutableArray *arrNotificationData;

-(id)init;
-(NSMutableArray*) getAllNotifiations;
-(void)getPendinngRequestArray;
- (void) cancelALLLocalNotification;
-(void) cancelNotification:(int ) id;
-(bool) isNotificaitonScheduled:(NSMutableArray*)array nID:(NSString*)nID;
-(void) scheduleNotification: (NSString *)id  title:(NSString *)title body:(NSString *)body hour:(int)hour min:(int)min  isRepeat:(BOOL)isRepeat;
@end


