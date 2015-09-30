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
    cell.titleLabel.text = [self.listOfMovieTitles objectAtIndex:indexPath.row];
    cell.descriptionView.text = [self.listOfMovieDescriptions objectAtIndex:indexPath.row];
    
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w180_and_h180_bestv2%@",[self.listOfMoviePosters objectAtIndex:indexPath.row]]]];
    cell.posterView.image = [UIImage imageWithData: imageData];
    return cell;
}


@end
