//
//  ResultTableViewController.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/18/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import "ResultTableViewController.h"
#import "ResultCell.h"


@interface ResultTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL isInformationAvailable;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation ResultTableViewController

#pragma mark - Setters
- (Actor *)actor
{
    if (!_actor) _actor = [[Actor alloc] init];
    return _actor;
}

- (BOOL)isInformationAvailable
{
    if (!_isInformationAvailable)
        _isInformationAvailable = NO;
    return _isInformationAvailable;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator){
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 20, 20);
        _activityIndicator.hidden = YES;
        [self.view addSubview:_activityIndicator];
    }
    return _activityIndicator;
}

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.backButton.hidden = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.actor getImageInformation];
        [self.actor extractInformation];
        self.isInformationAvailable = YES;
        dispatch_async(dispatch_get_main_queue(), ^(){
            //Run UI Updates
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [self.tableView setSeparatorColor:[UIColor blueColor]];
            self.backButton.hidden = NO;
        });
    });
}

#pragma mark - UITableView delegate methods
- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:@"First Cell"];
        cell.nameLabel.text = self.actor.name;
        cell.imageView.image = self.actor.image;
        cell.age.text = [NSString stringWithFormat:@"Age: %@", self.actor.age];
        cell.gender.text = [NSString stringWithFormat:@"Gender: %@", self.actor.gender];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Other Information"];
        switch(indexPath.row){
            case 1:
                cell.textLabel.text = @"dbpedia";
                cell.detailTextLabel.text = self.actor.dbpedia;
                break;
            
            case 2:
                cell.textLabel.text = @"freebase";
                cell.detailTextLabel.text = self.actor.freebase;
                break;
            
            case 3:
                cell.textLabel.text = @"opencyc";
                cell.detailTextLabel.text = self.actor.opencyc;
                break;
            
            case 4:
                cell.textLabel.text = @"yago";
                cell.detailTextLabel.text = self.actor.yago;
                break;
            default:
                break;
        }
        return cell;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isInformationAvailable) ? 5 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 320 : 50;
}

- (IBAction)goBack:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:self.view completion:nil];
}



@end
