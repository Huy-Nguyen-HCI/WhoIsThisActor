//
//  ResultViewController.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/6/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"

@interface ResultViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) Actor *actor;

@end
