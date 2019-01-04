//
//  l.h
//  TestTimer
//
//  Created by INT MAC 2015 on 25/10/18.
//  Copyright © 2018 INT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TblCellData : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel   *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel   *lblNotification;
@property (nonatomic, retain) IBOutlet UILabel   *lblTime;

@property (nonatomic, retain) IBOutlet UIButton   *btnChange;
@property (nonatomic, retain) IBOutlet UIButton   *btnCancel;

@property (nonatomic, retain) IBOutlet UIView   *vwMain;

@property (nonatomic, retain) IBOutlet UIImageView   *imgRepeat;

@end

NS_ASSUME_NONNULL_END
