//
//  ResultViewController.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/6/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString *resultLink;


@end
