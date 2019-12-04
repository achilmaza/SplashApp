//
//  ImageFilterMenuTableViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// ImageFilterMenuTableViewController handles the filter menu
// table view controller. Once an option is selected, this
// value is passed back to ImageFilterModalViewController via
// delegation. 
//
//------------------------------------------------------------


#import "ImageFilterMenuTableViewController.h"
#import "Image.h"

@interface ImageFilterMenuTableViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *likesLessThan50CheckMark;
@property (strong, nonatomic) IBOutlet UIImageView *likesLessThan200CheckMark;
@property (strong, nonatomic) IBOutlet UIImageView *likesMoreThan200CheckMark;


@end

@implementation ImageFilterMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    [self setupFilterCheckmark];
}


-(void) setupFilterCheckmark{
    
    //set image filter type
    UIImage * image = [UIImage imageNamed:@"icons8-checkmark"];
    
    switch(self.imageFilterType){
        case likesLessThan50:
            self.likesLessThan50CheckMark.image  = image;
            break;
        case likesLessThan200:
            self.likesLessThan200CheckMark.image = image;
            break;
        case likesGreaterThan200:
            self.likesMoreThan200CheckMark.image = image;
            break;
        case none:
        default:
            self.likesLessThan50CheckMark.image = nil;
            self.likesLessThan200CheckMark.image = nil;
            self.likesMoreThan200CheckMark.image = nil;
            break;
    }
    
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //0-50
    if([indexPath section] == 0 && [indexPath row] == 0){
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate processMenuSelection:likesLessThan50];
        }];
    }
    //50 - 200
    else if([indexPath section] == 0 && [indexPath row] == 1){
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate processMenuSelection:likesLessThan200];
        }];
    }
    //> 200
    else if([indexPath section] == 0 && [indexPath row] == 2){
          
          [self dismissViewControllerAnimated:YES completion:^{
              [self.delegate processMenuSelection:likesGreaterThan200];
          }];
      }
    
}




@end
