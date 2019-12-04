//
//  ImageDetailsViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// ImageDetailsViewController displays regular size image data
// and other image details. It also provides option to share
// image url.
//
//------------------------------------------------------------


#import "ImageDetailsViewController.h"
#import "DAO.h"
#import "Image.h"
#import "AlertUtility.h"

@interface ImageDetailsViewController ()  <UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *likes;


@end

@implementation ImageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayDetails];
}

-(void)displayDetails{
    
    NSData * imageData = [[DAO sharedInstance] getImageDataFromCache:self.query image:self.image imageType:regular];
    
    if(imageData){
        self.imageView.image = [UIImage imageWithData:imageData];
    }
    else{
        [[DAO sharedInstance] getRegular:self.query forImage:self.image completionHandler:^(NSString*query, Image* image, NSData *data, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error){
                   [AlertUtility displayAlert:@"Request Unsuccessful"
                               msg:@"Error loading image. Please try again."
                    viewController:self];
                }
                else{
                    self.imageView.image = [UIImage imageWithData:data];
                }
            });
        }];
    }
    
    self.desc.text = self.image.desc;
    self.username.text = [self.image getUsername];
    self.likes.text = [NSString stringWithFormat:@"%ld", [self.image getLikes]];
    
}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)share:(id)sender{
    
    NSArray *activityItems = [NSArray arrayWithObjects:[self.image getRegularImageUrl], nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else {
        UIPopoverPresentationController *popup = activityVC.popoverPresentationController;
        popup.delegate = self;
        popup.sourceView = self.view;
        popup.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0);
        [self presentViewController:activityVC animated:YES completion:nil];
    }

}

@end
