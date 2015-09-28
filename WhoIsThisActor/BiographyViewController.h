//
//  BiographyViewController.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/26/15.
//  Copyright © 2015 Nguyen Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiographyViewController : UIViewController
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *biography;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (nonatomic) UIImage *image;
@end
