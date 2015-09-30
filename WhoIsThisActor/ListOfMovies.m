//
//  ListOfMovies.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/28/15.
//  Copyright © 2015 Nguyen Huy. All rights reserved.
//

#import "ListOfMovies.h"

@interface ListOfMovies ()

@end

@implementation ListOfMovies

- (IBAction)goBack:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.listOfMovieTitles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Movie" forIndexPath:indexPath];
    cell.textLabel.text = [self.listOfMovieTitles objectAtIndex:indexPath.row];
    return cell;
}


@end
