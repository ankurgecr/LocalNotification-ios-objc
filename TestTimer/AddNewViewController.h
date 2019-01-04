//
//  AddNewViewController.h
//  TestTimer
//
//  Created by INT MAC 2015 on 25/10/18.
//  Copyright © 2018 INT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddNewViewController : UIViewController

@property (nonatomic) bool isFrmEdit;
@property (nonatomic) NSMutableDictionary *dictData;
@property (nonatomic) int itemIndex;

@end

NS_ASSUME_NONNULL_END
