//
//  ResultViewController.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/6/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


@implementation ResultViewController


- (void)setResultLink:(NSString *)resultLink
{
    self.resultLabel.text = resultLink;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultLink = @"http://www.google.com";
    [self.activityIndicator stopAnimating];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)];
    [self.resultLabel setUserInteractionEnabled:YES];
    [self.resultLabel addGestureRecognizer:gesture];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



-(void)openURL
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.resultLink]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.resultLabel.text]];
}
@end
