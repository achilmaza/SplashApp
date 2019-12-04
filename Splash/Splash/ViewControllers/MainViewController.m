//
//  MainViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//


//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
//  Main View Controller for Splash App.
//  Clicking on button takes you to search view controller.
//------------------------------------------------------------

#import "MainViewController.h"
#import "SearchViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(IBAction)search{

    //Clicking on the search button brings up search view controller
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * svc = (SearchViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    
    //Push Search View Controller onto Navigation Controller stack
    [self.navigationController pushViewController:svc animated:YES];
   
}

@end
