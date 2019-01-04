//
//  AddNewViewController.m
//  TestTimer
//
//  Created by INT MAC 2015 on 25/10/18.
//  Copyright © 2018 INT. All rights reserved.
//

#import "AddNewViewController.h"
#import "NotificationHelper.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AddNewViewController () {
    
    IBOutlet UIView                 *vwMain;
    
    IBOutlet UIButton               *btnNone;
    IBOutlet UIButton               *btnDelay;
    IBOutlet UIButton               *btnSchedule;
    
    IBOutlet UITextField            *txtID;
    IBOutlet UITextField            *txtTitle;
    IBOutlet UITextField            *txtNotification;
    
    IBOutlet UISwitch               *switchRepet;
    
    UIDatePicker                    *datePicker;
    
    int                             strHours;
    int                             strMin;
    int                             randomInt;
    
    AppDelegate                     *appDelegate;
    
    UIToolbar                       *toolBar;
    
    bool                           isRepeat;
    
}

@end

@implementation AddNewViewController

#pragma mark : viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    isRepeat = false;
    
    vwMain.layer.shadowRadius   = 6.0;
    vwMain.layer.shadowColor    = [UIColor lightGrayColor].CGColor;
    vwMain.layer.shadowOpacity  = 1.0;
    vwMain.layer.shadowOffset   = CGSizeZero;
    vwMain.layer.cornerRadius   = 3.0;
    
    if (_isFrmEdit) {
        txtID.text      = _dictData[@"id"];
        txtTitle.text   = _dictData[@"title"];
        txtNotification.text  = _dictData[@"notificationText"];
        strHours        = [_dictData[@"hr"] intValue];
        strMin          = [_dictData[@"min"] intValue];
        isRepeat        = [_dictData[@"isRepeat"] boolValue];
        [btnNone setTitle:[NSString stringWithFormat:@"%@ : %@",_dictData[@"hr"], _dictData[@"min"]] forState:UIControlStateNormal];
    } else {
        randomInt   = arc4random_uniform(500);
        txtID.text  =  [NSString stringWithFormat:@"%d",randomInt];
    }
    datePicker  = [[UIDatePicker alloc] init];
    toolBar     = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 40)];
    [self btnSelected:false];
    [self addDatePicker];
}

-(void)addDatePicker {
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setTranslucent:true];
    toolBar.tintColor = [UIColor blackColor];
    [toolBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[[NSMutableArray alloc] initWithObjects:spaceButton, doneButton, nil]];
    [toolBar setUserInteractionEnabled:true];
    [self.view addSubview:toolBar];
    
    datePicker.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
    [datePicker setTimeZone:NSTimeZone.localTimeZone];
    [datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [datePicker setBackgroundColor:UIColor.whiteColor];
    [datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    datePicker.hidden   = true;
    toolBar.hidden      = true;
}
-(void)doneClick{
    [self getTimeFromDatpicker];
    datePicker.hidden   = true;
    datePicker.hidden   = true;
    toolBar.hidden      = true;
    [self.view endEditing:true];
}
-(void)getTimeFromDatpicker {
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"HH:mm"];
    NSString *strDateFinal = [dtFormatter stringFromDate:datePicker.date];
    NSMutableArray *arrSepatrtoe = [[NSMutableArray alloc] init];
    arrSepatrtoe = [[strDateFinal componentsSeparatedByString:@":"] mutableCopy];
    strHours    = [arrSepatrtoe[0] intValue];
    strMin      = [arrSepatrtoe[1] intValue];
    
    [btnNone setTitle:[NSString stringWithFormat:@"%d hours : %d min",strHours , strMin] forState:UIControlStateNormal];
}

- (void)dateIsChanged:(UIDatePicker *)sender{
    NSLog(@"Date changed");
    [self getTimeFromDatpicker];
}
-(void)btnSelected:(bool)isNoneSelected {
    [btnDelay setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnNone setTintColor:[UIColor clearColor]];
    datePicker.hidden    = false;
    toolBar.hidden       = false;
}
-(IBAction)btnDelayClick:(UIButton *)sender {
    
}
-(IBAction)btnNoneClick:(UIButton *)sender {
    [txtTitle resignFirstResponder];
    [txtNotification resignFirstResponder];
    [self btnSelected:true];
}
-(IBAction)btnScheduleClick:(UIButton *)sender {
    if ([self isValid]){
        
        if (_isFrmEdit) {
            appDelegate.notificationHelper.isfromEdit = 1;
            appDelegate.notificationHelper.itemIndex= _itemIndex;
        }
   
        [appDelegate.notificationHelper scheduleNotification:txtID.text title:txtTitle.text body:txtNotification.text hour:strHours min:strMin  isRepeat:[NSNumber numberWithBool:isRepeat]];
        [self.navigationController popViewControllerAnimated:true];
    }
}
-(bool)isValid{
    if ([txtTitle.text isEqualToString:@""]) {
        [self showalert:@"Please enter title"];
        return false;
    } else if ([txtNotification.text isEqualToString:@""]) {
        [self showalert:@"Please enter notification text"];
        return false;
    } else if ([btnNone.titleLabel.text isEqualToString:@"NONE"]) {
        [self showalert:@"Please select time"];
        return false;
    } else {
        return true;
    }
}
-(IBAction)checkState:(UISwitch *)sender {
    if (sender.isOn) {
        [sender setOn:false];
    } else {
        [sender setOn:true];
    }
    isRepeat = sender.isOn;
}
-(void)showalert:(NSString *)strMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
