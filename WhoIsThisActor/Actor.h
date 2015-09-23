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
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *dbpedia;
@property (nonatomic, strong) NSString *freebase;
@property (nonatomic, strong) NSString *opencyc;
@property (nonatomic, strong) NSString *yago;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSMutableArray *availableInformation;

- (void)getImageInformation;
- (void)extractInformation;
@end
