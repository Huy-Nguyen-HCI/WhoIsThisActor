//
//  ViewController.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/6/15.
//  Copyright (c) 2015 Nguyen Huy. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>



@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.borderWidth = 1;
}
- (IBAction)selectPicture:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePicture:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length]) % [letters length]]];
    }
    
    return randomString;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    self.imageView.image = image;
    [self dismissImagePicker];
    
    
    
    float actualHeight = self.imageView.image.size.height;
    float actualWidth = self.imageView.image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [self.imageView.image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // COnvert Image to NSData
    NSData *dataImage = UIImageJPEGRepresentation(img, 1.0f);
    
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
    NSLog(@"Response  %@",responseString);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:responseString
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissImagePicker];
}

- (void)dismissImagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show result"]){
        if (!self.imageView.image){
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Image not found" message:@"You need to take or select a photo" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
        
    }
    return YES;
}








@end