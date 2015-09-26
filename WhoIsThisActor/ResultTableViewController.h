//
//  ResultTableViewController.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/18/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"
@interface ResultTableViewController : UITableViewController <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *vrai;

@property (nonatomic, strong) Actor *actor;
@end
