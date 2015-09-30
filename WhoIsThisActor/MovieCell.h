//
//  MovieCell.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/29/15.
//  Copyright © 2015 Nguyen Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;@end
