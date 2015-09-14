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
#import "ResultViewController.h"


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) NSString *information;
@property (nonatomic) BOOL isImageAvailable;
@end

@implementation ViewController

- (BOOL)isIsImageAvailable
{
    if (!_isImageAvailable) _isImageAvailable = NO;
    return _isImageAvailable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _takePhotoButton.layer.cornerRadius = 5.0;
    _takePhotoButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5.0;
    _submitButton.layer.masksToBounds = YES;
    _selectButton.layer.cornerRadius = 5.0;
    _selectButton.layer.masksToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);


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

- (UIImage *)standardizeImage
{
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
    
    return img;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    self.imageView.image = image;
    self.isImageAvailable = YES;
    [self dismissImagePicker];
    
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
        if (!self.isImageAvailable){
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Image not found" message:@"You need to take or select a photo" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
        
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show result"]){
        ResultViewController *resultView = (ResultViewController *)segue.destinationViewController;
        resultView.title = @"Here is your result!";
        resultView.actor.image = [self standardizeImage];
    }
}








@end