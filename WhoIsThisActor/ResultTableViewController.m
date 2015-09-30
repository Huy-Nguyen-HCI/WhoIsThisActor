//
//  ResultTableViewController.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/18/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import "ResultTableViewController.h"
#import "ResultCell.h"
#import "BiographyViewController.h"
#import "NoInformationCell.h"
#import "ListOfMovies.h"


@interface ResultTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL isInformationAvailable;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) UIImage *realImage;
@property (nonatomic) BOOL isInformationEnough;
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

- (BOOL)isInformationEnough
{
    if (!_isInformationEnough)
        _isInformationEnough = NO;
    return _isInformationEnough;
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - View Controller Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    [self setNeedsStatusBarAppearanceUpdate];
    self.backButton.hidden = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.actor getImageInformation];
        [self.actor extractInformation];
        [self.actor getActorInformation];
        self.isInformationAvailable = YES;
        dispatch_async(dispatch_get_main_queue(), ^(){
            //Run UI Updates
            [self.activityIndicator stopAnimating];
            self.isInformationEnough = ([self.actor.name length]) ? YES : NO;
            [self.tableView reloadData];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            self.backButton.hidden = NO;
        });
    });
}

#pragma mark - UITableView delegate methods
- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        if (self.isInformationAvailable){
            if (self.isInformationEnough){
                ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:@"First Cell"];
                cell.nameLabel.text = self.actor.name;
                cell.imageView.image = self.actor.image;
                cell.imageView.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.actor.imageurl]];
                cell.realImage.image = [UIImage imageWithData: imageData];
                self.realImage = cell.realImage.image;
                
                UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                blurEffectView.frame = cell.imageView.bounds;
                blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [cell.imageView addSubview:blurEffectView];
                
                cell.age.text = [NSString stringWithFormat:@"%@", self.actor.age];
                cell.gender.text = [NSString stringWithFormat:@"%@", self.actor.gender];
                
                return cell;
            }
            else {
                NoInformationCell *cell = (NoInformationCell *)[tableView dequeueReusableCellWithIdentifier:@"No information"];
                // when information is loaded
                cell.ageLabel.text =  ([self.actor.age length]) ? [NSString stringWithFormat:@"Age: %@",self.actor.age] : @"";
                cell.genderLabel.text = ([self.actor.gender length]) ? [NSString stringWithFormat:@"Gender: %@",self.actor.gender] : @"";
                if (![self.actor.age length] && ![self.actor.gender length]){
                    cell.titleLabel.text = @"Sorry we cannot tell anything about the image :((";
                }
                return cell;
            }
        }
        else return nil;
    }
    
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Other Information"];
        switch(indexPath.row){
            case 1:
                cell.textLabel.text = @"Biography";
                cell.detailTextLabel.text = self.actor.biography;
                if (self.isInformationAvailable && ![self.actor.biography isEqualToString:@"Not Found"])
                    cell.accessoryType = UITableViewCellAccessoryDetailButton;
                break;
            
            case 2:
                cell.textLabel.text = @"Birthday";
                cell.detailTextLabel.text = self.actor.birthday;
                break;
            
            case 3:
                cell.textLabel.text = @"Place of Birth";
                cell.detailTextLabel.text = self.actor.place_of_birth;
                break;
            case 4:
                cell.textLabel.text = @"Suggested Movies";
                if ([self.actor.listOfMovieTitles count]){
                    cell.detailTextLabel.text = @"Click for more details ☞";
                    cell.accessoryType = UITableViewCellAccessoryDetailButton;
                }
                else {
                    cell.detailTextLabel.text = @"No information";
                }
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
    if (self.isInformationAvailable){
        if (self.isInformationEnough) return 5;
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 320 : 50;
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 1){
        BiographyViewController *bio = (BiographyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Biography"];
        bio.image = self.realImage;
        bio.biography = self.actor.biography;
        bio.name = self.actor.name;
        [self presentViewController:bio animated:YES completion:nil];
    }
    else if (indexPath.row == 4){
        ListOfMovies *list = (ListOfMovies *)[storyboard instantiateViewControllerWithIdentifier:@"List of movies"];
        list.listOfMovieTitles = self.actor.listOfMovieTitles;
        list.listOfMoviePosters = self.actor.listOfMoviePosters;
        list.listOfMovieDescriptions = self.actor.listOfMovieDescriptions;
        [self presentViewController:list animated:YES completion:nil];
    }
}

- (IBAction)goBack:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
