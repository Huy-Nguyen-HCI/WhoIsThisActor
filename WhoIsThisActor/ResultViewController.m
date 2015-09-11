//
//  ResultViewController.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/6/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import "ResultViewController.h"
#import "Actor.h"
@interface ResultViewController ()

@property (strong, nonatomic) NSString *information;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dbpediaLabel;
@property (weak, nonatomic) IBOutlet UILabel *freebaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *opencycLabel;
@property (weak, nonatomic) IBOutlet UITextView *subTypes;
@property (weak, nonatomic) IBOutlet UILabel *yagoLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelTitles;

@property (strong, nonatomic) Actor *actor;

@end


@implementation ResultViewController

- (Actor *)actor
{
    if (!_actor) _actor = [[Actor alloc] init];
    return _actor;
}

- (void)setVisibilityForAllFields:(BOOL)isVisible
{
    self.nameLabel.hidden = !isVisible;
    self.ageLabel.hidden = !isVisible;
    self.dbpediaLabel.hidden = !isVisible;
    self.freebaseLabel.hidden = !isVisible;
    self.opencycLabel.hidden = !isVisible;
    self.subTypes.hidden = !isVisible;
    self.yagoLabel.hidden = !isVisible;
    for (UILabel *label in self.labelTitles){
        label.hidden = !isVisible;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setVisibilityForAllFields:NO];
    self.subTypes.editable = NO;
    [self.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self getImageInformation];
        [self extractInformation];
        dispatch_async(dispatch_get_main_queue(), ^(){
            //Run UI Updates
            [self displayActorInformation];
            [self setVisibilityForAllFields:YES];
            [self makeAllLinksClickable];
            [self.activityIndicator stopAnimating];
        });
    });
    
}

- (NSString *)extractInformationWithTitle:(NSString *)title
{
    NSArray *components = [self.information componentsSeparatedByString:[NSString stringWithFormat:@"\"%@\": \"", title]];
    NSArray *furtherBreakdown = [components[1] componentsSeparatedByString:@"\""];
    return furtherBreakdown[0];
}

- (void)extractInformation
{
    Actor *actor = self.actor;
    // extract name
    actor.name = [self extractInformationWithTitle:@"name"];
    NSLog(@"hello: %@", actor.name);
    // extract age
    actor.age = [self extractInformationWithTitle:@"ageRange"];
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
    self.ageLabel.text = self.actor.age;
    self.dbpediaLabel.text = self.actor.dbpedia;
    self.freebaseLabel.text = self.actor.freebase;
    self.opencycLabel.text = self.actor.opencyc;
    self.yagoLabel.text = self.actor.yago;
    
}

- (void)getImageInformation
{
    // Convert Image to NSData
    NSData *dataImage = UIImageJPEGRepresentation(self.image, 1.0f);
    
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
    self.information = responseString;
    
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
