//
//  SearchViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
//  SearchViewController is a view controller that alternates
//  between displaying recent searches and suggested searches.
//  RecentSearchViewController and SuggestedSearchViewController
//  are embedded view controllers which are displayed based
//  on interaction with searchBar text field.
//------------------------------------------------------------



#import "SearchViewController.h"
#import "SearchItem.h"
#import "ImageGalleryViewController.h"
#import "RecentSearchViewController.h"
#import "SuggestedSearchViewController.h"

#define HEIGHT_FOR_HEADER 40.0

@interface SearchViewController () <UISearchBarDelegate, RecentSearchDelegate, SuggestedSearchDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) RecentSearchViewController * recentSearchViewController;
@property (strong, nonatomic) SuggestedSearchViewController * suggestedSearchViewController;
@property (assign, nonatomic) Boolean showSuggestedSearch;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup search bar delegate
    self.searchBar.delegate = self;
    self.showSuggestedSearch = false;
    
    [self.searchBar becomeFirstResponder];
    
    //display recent search view controller
    //if user starts typing into search bar display suggested view controller
    [self setupViewControllers];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self toggleViewControllers];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
     self.searchBar.text = @"";
}

#pragma mark Embedded View Controllers
-(void)setupViewControllers{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.recentSearchViewController = (RecentSearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RecentSearchViewController"];
    self.suggestedSearchViewController = (SuggestedSearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SuggestedSearchViewController"];
    self.recentSearchViewController.delegate = self;
    self.suggestedSearchViewController.delegate = self;
    
    if(self.showSuggestedSearch){
        [self addViewController:(UIViewController *)self.suggestedSearchViewController];
    }
    else{
         [self addViewController:(UIViewController *)self.recentSearchViewController];
    }
    
}

-(void)toggleViewControllers{
    
    if(self.showSuggestedSearch){
          [self removeViewController:(UIViewController *)self.recentSearchViewController];
          [self addViewController:(UIViewController *)self.suggestedSearchViewController];
      }
      else{
          [self removeViewController:(UIViewController *)self.suggestedSearchViewController];
          [self addViewController:(UIViewController *)self.recentSearchViewController];
      }
}


-(void)addViewController:(UIViewController*)childViewController{
    
    [self addChildViewController:childViewController];
    
    // Add Child View as Subview
    [self.containerView addSubview:[childViewController view]];
    
    // Configure Child View
    [[childViewController view] setFrame:self.containerView.bounds];
    
    // Notify Child View Controller
    [childViewController didMoveToParentViewController:self];
}


-(void)removeViewController:(UIViewController*)childViewController{

    //If the view has been loaded, remove from superview
    if([childViewController isViewLoaded]){
        [childViewController willMoveToParentViewController:nil];
        // Remove child view from containerView
        [[childViewController view] removeFromSuperview];
        
        // Notify Child View Controller
        [childViewController removeFromParentViewController];
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if(searchBar.text != nil){
       searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       if(![searchBar.text isEqualToString:@""]){
            self.showSuggestedSearch = false;
           [self displaySearchViewController:searchBar.text];
       }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    if([searchBar.text isEqualToString:@""]){
        self.showSuggestedSearch = false;
        [self toggleViewControllers];
    }
    else{
        self.showSuggestedSearch = true;
        [self toggleViewControllers];
        [self.suggestedSearchViewController searchQuery:searchBar.text];
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    self.showSuggestedSearch = false;
    [self toggleViewControllers];
    
}

-(void)displaySearchViewController:(NSString*)query{

   UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   ImageGalleryViewController * svc = (ImageGalleryViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ImageGalleryViewController"];
    svc.query = query;
   [self.navigationController pushViewController:svc animated:self];
   
   //customize back indicator image and label
   self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"icons8-back"];
   self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"icons8-back"];
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
}

-(void)processSearchQuery:(NSString*)query{
    
    self.searchBar.text = query;
    
    if(self.searchBar.text != nil){
       self.searchBar.text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       if(![self.searchBar.text isEqualToString:@""]){
           self.showSuggestedSearch = false;
           [self displaySearchViewController:self.searchBar.text];
       }
    }
}




@end
