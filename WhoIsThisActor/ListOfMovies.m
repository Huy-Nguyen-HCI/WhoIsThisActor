//
//  ListOfMovies.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/28/15.
//  Copyright © 2015 Nguyen Huy. All rights reserved.
//

#import "ListOfMovies.h"
#import "MovieCell.h"
@interface ListOfMovies ()

@end

@implementation ListOfMovies

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (IBAction)goBack:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfMovieTitles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:@"Movie" forIndexPath:indexPath];
    cell.titleText = [self.listOfMovieTitles objectAtIndex:indexPath.row];
    cell.descriptionText = [self.listOfMovieDescriptions objectAtIndex:indexPath.row];
    
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w180_and_h180_bestv2%@",[self.listOfMoviePosters objectAtIndex:indexPath.row]]]];
    cell.posterImage = [UIImage imageWithData: imageData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Here are the movies!";
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


@end
