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
    return cell;
}


@end
