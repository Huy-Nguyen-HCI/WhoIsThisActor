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

@property (weak, nonatomic) IBOutlet UILabel *dbpediaHeader;
@property (weak, nonatomic) IBOutlet UILabel *freebaseHeader;
@property (weak, nonatomic) IBOutlet UILabel *opencycHeader;
@property (weak, nonatomic) IBOutlet UILabel *yagoHeader;


@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dbpediaLabel;
@property (weak, nonatomic) IBOutlet UILabel *freebaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *opencycLabel;
@property (weak, nonatomic) IBOutlet UILabel *yagoLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (strong, nonatomic) NSArray *labelTitles;
@property (strong, nonatomic) NSArray *labelContents;


@end


@implementation ResultViewController

- (Actor *)actor
{
    if (!_actor) _actor = [[Actor alloc] init];
    return _actor;
}

- (NSArray *)labelTitles
{
    if (!_labelTitles){
        _labelTitles = [NSArray arrayWithObjects:self.dbpediaHeader, self.freebaseHeader, self.opencycHeader, self.yagoHeader, self.nameLabel, self.ageLabel, self.genderLabel, nil];
    }
    return _labelTitles;
}

- (NSArray *)labelContents
{
    if (!_labelContents){
        _labelContents = [NSArray arrayWithObjects: self.dbpediaLabel, self.freebaseLabel, self.opencycLabel, self.yagoLabel, self.nameLabel, self.ageLabel, self.genderLabel, nil];
    }
    return _labelContents;
}

- (void)setVisibilityForAllFields:(BOOL)isVisible
{
    for (UILabel *label in self.labelContents)
        label.hidden = !isVisible;
    
    for (UILabel *label in self.labelTitles)
        label.hidden = !isVisible;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setVisibilityForAllFields:NO];
    [self.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self getImageInformation];
        [self extractInformation];
        dispatch_async(dispatch_get_main_queue(), ^(){
            //Run UI Updates
            [self setVisibilityForAllFields:YES];
            [self displayActorInformation];
            [self makeAllLinksClickable];
            [self.activityIndicator stopAnimating];
        });
    });
    
}

- (NSString *)extractInformationWithTitle:(NSString *)title
{
    NSArray *components = [self.actor.information componentsSeparatedByString:[NSString stringWithFormat:@"\"%@\": \"", title]];
    if ([components count] >= 2){
        NSArray *furtherBreakdown = [components[1] componentsSeparatedByString:@"\""];
        return [furtherBreakdown firstObject];
    }
    return @"";
}

- (void)extractInformation
{
    Actor *actor = self.actor;
    // extract name
    actor.name = [self extractInformationWithTitle:@"name"];
    // extract age
    actor.age = [self extractInformationWithTitle:@"ageRange"];
    // extract gender
    actor.gender = [actor.information containsString:@"FEMALE"] ? @"FEMALE" : @"MALE";
    // extract dbpedia
    actor.dbpedia = [self extractInformationWithTitle:@"dbpedia"];
    // extract freebase
    actor.freebase = [self extractInformationWithTitle:@"freebase"];
    // extract opencyc
    actor.opencyc = [self extractInformationWithTitle:@"opencyc"];
    // extract yago
    actor.yago = [self extractInformationWithTitle:@"yago"];

}

- (void)displayActorInformation
{
    self.nameLabel.text = self.actor.name;
    self.ageLabel.text = [NSString stringWithFormat:@"Age: %@", self.actor.age];
    self.genderLabel.text = [NSString stringWithFormat:@"Gender: %@",self.actor.gender];
    self.dbpediaLabel.text = self.actor.dbpedia;
    self.freebaseLabel.text = self.actor.freebase;
    self.opencycLabel.text = self.actor.opencyc;
    self.yagoLabel.text = self.actor.yago;
    
    // if a field is empty, make it invisible
    for (UILabel *label in self.labelContents){
        if (![label.text length]){
            label.hidden = YES;
            NSUInteger index = [self.labelContents indexOfObject:label];
            ((UILabel *)self.labelTitles[index]).hidden = YES;
            NSLog(@"%@", ((UILabel *)self.labelTitles[index]).text);
        }
    }
    
}

- (void)getImageInformation
{
    // Convert Image to NSData
    NSData *dataImage = UIImageJPEGRepresentation(self.actor.image, 1.0f);
    
    // set your URL Where to Upload Image
    NSString *urlString = @"http://access.alchemyapi.com/calls/image/ImageGetRankedImageFaceTags?apikey=8978166d02d35e1d0c8b2126addda4ba5515202c&outputMode=json&imagePostMode=raw";
    
    // Create 'POST' MutableRequest with Data and Other Image Attachment.
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencode; boundary=%@",boundary];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[NSData dataWithData:dataImage]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    // Get Response of Your Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    self.actor.information = responseString;
    
}

- (void)makeAllLinksClickable
{
    UITapGestureRecognizer* dbpediaGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
    UITapGestureRecognizer* freebaseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
    UITapGestureRecognizer* opencycGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
    UITapGestureRecognizer* yagoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
    
    [self.dbpediaLabel setUserInteractionEnabled:YES];
    [self.dbpediaLabel addGestureRecognizer:dbpediaGesture];
    
    [self.freebaseLabel setUserInteractionEnabled:YES];
    [self.freebaseLabel addGestureRecognizer:freebaseGesture];
    
    [self.opencycLabel setUserInteractionEnabled:YES];
    [self.opencycLabel addGestureRecognizer:opencycGesture];
    
    [self.yagoLabel setUserInteractionEnabled:YES];
    [self.yagoLabel addGestureRecognizer:yagoGesture];
}



- (void)openURL:(UITapGestureRecognizer *)sender
{
    NSString *url = ((UILabel *)sender.view).text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}



/*
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




- (void)showInformation:(NSString *)information
{
    NSlog(@"%@", information);
}
 */
@end
