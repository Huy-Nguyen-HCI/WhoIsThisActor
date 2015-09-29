//
//  Actor.h
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/10/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Actor : NSObject
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSString *moviedb_information;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *dbpedia;
@property (nonatomic, strong) NSString *freebase;
@property (nonatomic, strong) NSString *opencyc;
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *place_of_birth;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, strong) NSString *imdb;
@property (nonatomic, strong) NSArray *knownfor;
@property (nonatomic, strong) NSString *yago;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *listOfMovies;

- (void)getImageInformation;
- (void)getActorInformation;
- (void)extractInformation;
@end
