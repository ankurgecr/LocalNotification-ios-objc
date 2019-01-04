 //
//  ViewController.m
//  TestTimer
//
//  Created by INT MAC 2015 on 25/10/18.
//  Copyright © 2018 INT. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import "TblCellData.h"
#import "AddNewViewController.h"
#import "NotificationHelper.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UILabel        *lblMsg;
    
    IBOutlet UIButton       *btnAdd;
    IBOutlet UITableView    *tblView;
    
    __strong AppDelegate    *appDelegate;
    
    bool                    isgotoEdit;
    
    int                     index;
}

@end

@implementation ViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callisNotificaitonScheduled:)
                                                 name:@"ArrayReceivedNotification"
                                               object:nil];
    //_notificationHelper = [[NotificationHelper alloc] init];
    lblMsg.hidden = true;
    btnAdd.layer.cornerRadius = btnAdd.frame.size.height/2;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (appDelegate.notificationHelper.arrNotificationData.count == 0) {
        lblMsg.hidden = false;
    } else {
        lblMsg.hidden = true;
    }
    [tblView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editIdentifier"]) {
        AddNewViewController *newVc = segue.destinationViewController;
        newVc.isFrmEdit = isgotoEdit;
        if (sender != nil) {
            newVc.itemIndex = index;
            newVc.dictData = sender;
        }
                      /*ed   0 2 2c2 33
                       
                       
                       itVC.isFrmEdit = isgotoEdit
        if sender != nil {
            editVC.itemIndex    = index
            editVC.dictData = sender as? [String : AnyObject]
        }*/
    }
}

#pragma mark - button clicks
-(IBAction)btnAdd_Click:(UIButton *)sender {
    isgotoEdit = false;
    [self performSegueWithIdentifier:@"editIdentifier" sender:nil];
}

-(IBAction)btnChange_Click:(UIButton *)sender {
    isgotoEdit = true;
    index = (int)sender.tag;
    [self performSegueWithIdentifier:@"editIdentifier" sender:appDelegate.notificationHelper.arrNotificationData[sender.tag]];
}

-(IBAction)btnCancel_Click:(UIButton *)sender {
    NotificationHelper *notificationHelper = [[NotificationHelper alloc] init];
    int senderID = (int)sender.tag;

    [appDelegate.notificationHelper cancelNotification:senderID];

    [tblView reloadData];
    if (appDelegate.notificationHelper.arrNotificationData.count == 0) {
        lblMsg.hidden = false;
    } else {
        lblMsg.hidden = true;
    }
    //[appDelegate.notificationHelper cancelALLLocalNotification]; //Added For testing only
    [appDelegate.notificationHelper getPendinngRequestArray];// This is require to check notification is scheduled. To get its response observer is added.

  
}

#pragma
#pragma Notification method
- (void) callisNotificaitonScheduled:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"ArrayReceivedNotification"]){
            BOOL temp = [appDelegate.notificationHelper isNotificaitonScheduled:notification.object nID:@"340"];// number Added For testing
        NSString *str = [NSString stringWithFormat:@"%d",temp];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:str preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appDelegate.notificationHelper.arrNotificationData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TblCellData *cell = [tblView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[TblCellData alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSMutableDictionary *dictData = [appDelegate.notificationHelper.arrNotificationData[indexPath.row] mutableCopy];
    cell.lblTime.text       = [NSString stringWithFormat:@"%@ hr:%@ min",dictData[@"hr"], dictData[@"min"]];
    cell.lblTitle.text      = [NSString stringWithFormat:@"%@ %@",dictData[@"id"], dictData[@"title"]];
    cell.lblNotification.text = dictData[@"notificationText"];
    
    if ([dictData[@"isRepeat"] boolValue]) {
        [cell.imgRepeat setHidden:false];
    } else {
        [cell.imgRepeat setHidden:true];
    }
    
    cell.vwMain.layer.shadowRadius   = 6.0;
    cell.vwMain.layer.shadowColor    = [UIColor lightGrayColor].CGColor;
    cell.vwMain.layer.shadowOpacity  = 1.0;
    cell.vwMain.layer.shadowOffset   = CGSizeZero;
    
    cell.btnCancel.tag = indexPath.row;
    [cell.btnCancel addTarget:self action:@selector(btnCancel_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnChange.tag = indexPath.row;
    [cell.btnChange addTarget:self action:@selector(btnChange_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    return  cell;
}

@end
