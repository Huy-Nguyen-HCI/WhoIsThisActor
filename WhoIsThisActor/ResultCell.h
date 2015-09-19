//
//  ResultCell.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/18/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *gender;

@end
