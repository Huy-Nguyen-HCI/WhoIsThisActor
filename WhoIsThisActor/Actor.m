//
//  Actor.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/10/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import "Actor.h"

@implementation Actor

// count the number of info available (to be displayed in ResultTableView)
- (NSMutableArray *)availableInformation
{
    if (!_availableInformation)
        _availableInformation = [[NSMutableArray alloc] init];
    return _availableInformation;
}


- (void)getActorInformation
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

- (NSString *)extractInformationWithTitle:(NSString *)title
{
    NSArray *components = [self.information componentsSeparatedByString:[NSString stringWithFormat:@"\"%@\": \"", title]];
    if ([components count] >= 2){
        NSArray *furtherBreakdown = [components[1] componentsSeparatedByString:@"\""];
        return [furtherBreakdown firstObject];
    }
    return @"";
}

- (void)extractInformation
{
    // extract name
    self.name = [self extractInformationWithTitle:@"name"];
    if ([self.name length]) [self.availableInformation addObject:self.name];
    
    // extract age
    self.age = [self extractInformationWithTitle:@"ageRange"];
    if ([self.age length]) [self.availableInformation addObject:self.age];
    
    // extract gender
    self.gender = [self.information containsString:@"FEMALE"] ? @"FEMALE" : @"MALE";
    if ([self.gender length]) [self.availableInformation addObject:self.age];
    
    // extract dbpedia
    self.dbpedia = [self extractInformationWithTitle:@"dbpedia"];
    if ([self.dbpedia length]) [self.availableInformation addObject:self.age];
    
    // extract freebase
    self.freebase = [self extractInformationWithTitle:@"freebase"];
    if ([self.freebase length]) [self.availableInformation addObject:self.age];
    
    // extract opencyc
    self.opencyc = [self extractInformationWithTitle:@"opencyc"];
    if ([self.opencyc length]) [self.availableInformation addObject:self.age];
    
    // extract yago
    self.yago = [self extractInformationWithTitle:@"yago"];
    if ([self.yago length]) [self.availableInformation addObject:self.age];
    
}




@end
