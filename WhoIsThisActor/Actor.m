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



- (void)getActorInformation
{
    // First call to search for actor
    NSString *nameEncoded = [self.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/person?api_key=54980fde8616b9217bd8c4401c70a975&query=%@",nameEncoded];
    
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    NSError *errorjson = nil;
    NSDictionary *jsonDict      = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves
                                                                    error:&errorjson];
    NSArray      *data          =  [jsonDict    valueForKey:@"results"];
    NSArray     *actorid           = [data valueForKey:@"id"];
    self.listOfMovieTitles  = [[[data valueForKey:@"known_for"] objectAtIndex:0] valueForKey:@"original_title"];
    
    
    urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/person/%@?api_key=54980fde8616b9217bd8c4401c70a975",[actorid     objectAtIndex:0]];
    request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //  responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    jsonDict      = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves
                                                      error:&errorjson];
    self.biography          =  [jsonDict    valueForKey:@"biography"];
    if (self.biography == [NSNull null]) self.biography = @"Not Found";
    self.imdb          =  [jsonDict    valueForKey:@"imdb_id"];
    self.birthday=[jsonDict    valueForKey:@"birthday"];
    self.place_of_birth=[jsonDict    valueForKey:@"place_of_birth"];
    NSArray *image_url =[jsonDict    valueForKey:@"profile_path"];
    self.imageurl          =  [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w180_and_h180_bestv2%@",image_url];
    
    //NSLog(responseString);
    
    // self.moviedb_information = responseString;
    
    /****************
     LOAD ALL MOVES INTO self.listOfMovies
     */
    
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
    
    // extract age
    self.age = [self extractInformationWithTitle:@"ageRange"];
    
    // extract gender
    self.gender = [self.information containsString:@"FEMALE"] ? @"FEMALE" : [self.information containsString:@"MALE"] ? @"MALE" : @"";
    
    // extract dbpedia
    self.dbpedia = [self extractInformationWithTitle:@"dbpedia"];
    
    // extract freebase
    self.freebase = [self extractInformationWithTitle:@"freebase"];
    
    // extract opencyc
    self.opencyc = [self extractInformationWithTitle:@"opencyc"];
    
    // extract yago
    self.yago = [self extractInformationWithTitle:@"yago"];
    
}




@end
