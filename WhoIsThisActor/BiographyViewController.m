//
//  BiographyViewController.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/26/15.
//  Copyright © 2015 Nguyen Huy. All rights reserved.
//

#import "BiographyViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BiographyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *actorName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *detail;

@end

@implementation BiographyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.actorName.text = self.name;
    self.imageView.image = self.image;
    self.detail.text = self.biography;
    [self.detail.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.detail setSelectedRange:NSMakeRange(0, 0)];
}

- (IBAction)goBack:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
