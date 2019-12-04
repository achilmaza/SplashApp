//
//  ImageFilterModalViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// ImageFilterModalViewController is a container view controller
// for the filter menu. Once filter option is selected, this
// value is passed back to ImageGalleryViewController via
// delegation.
//------------------------------------------------------------

#import "ImageFilterModalViewController.h"
#import "ImageFilterMenuTableViewController.h"

@interface ImageFilterModalViewController () <ImageFilterMenuDelegate>

@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ImageFilterModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.alpha = 0.2;
    
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];
    [self.view sendSubviewToBack:visualEffectView];
}


- (IBAction)cancelButton:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearFilters:(id)sender {
    [self.delegate processMenuSelection:none];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //tableView in container view
    if([[segue identifier] isEqualToString:@"showImageFilterMenuTableView"]){
        ImageFilterMenuTableViewController * vc = (ImageFilterMenuTableViewController*)segue.destinationViewController;
        vc.delegate = self;
        vc.imageFilterType = self.imageFilterType;
    }
}

-(void)processMenuSelection:(ImageFilterType)imageFilterType{
    
    [self.delegate processMenuSelection:imageFilterType];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
