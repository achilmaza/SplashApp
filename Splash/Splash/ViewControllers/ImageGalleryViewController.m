//
//  ImageGalleryViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//


//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
//  ImageGalleryViewController initiates the search query by
//  communicating with the Data Access Object (DAO) to get
//  the image list and displays thumbnails in collection view.
//  Thumbails are loaded asynchronously. There is also an option
//  to filter images by number of likes.
//------------------------------------------------------------


#import "ImageGalleryViewController.h"
#import "ImageCollectionViewCell.h"
#import "ImageDetailsViewController.h"
#import "ImageFilterModalViewController.h"
#import "ImageFilterPresentationController.h"
#import "DAO.h"
#import "Image.h"
#import "ImageUrl.h"
#import "AlertUtility.h"

#define ITEMS_PER_ROW 2

@interface ImageGalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, DAODelegate, UIViewControllerTransitioningDelegate, ImageFilterModalDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView * imageGallery;
@property (strong, nonatomic) NSArray * foundImages;
@property (strong, nonatomic) UIRefreshControl * refreshControl;
@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;

@end

@implementation ImageGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup collection view's delegate and data source
    [self setupCollectionView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 25.0, self.view.bounds.size.height/2 - 25.0, 50.0, 50.0)];
    
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    [[DAO sharedInstance] resetImageFilters];
    self.foundImages = [[DAO sharedInstance] getFoundImages:self.query];
    
    if(self.foundImages != nil && [self.foundImages count] > 0 ){
       [self reloadData];
    }
    else{
        [self loadImages];
    }
    
    self.navigationItem.title = self.query;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)setupRefreshControl{
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(loadImages) forControlEvents:UIControlEventValueChanged];
}

-(void)setupCollectionView{
    
    [self.imageGallery setDelegate:self];
    [self.imageGallery setDataSource:self];
    [self setupRefreshControl];
    
    if (@available(iOS 10.0, *)) {
        self.imageGallery.refreshControl = self.refreshControl;
    }
    else{
        [self.imageGallery addSubview:self.refreshControl];
    }
}

-(void)loadImages{
 
   [[DAO sharedInstance] getImageList:self.query delegate:self];
    
}
    

#pragma mark UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.foundImages count];
}

- (ImageCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    Image * image = self.foundImages[row];
    
    NSData * imageData = [[DAO sharedInstance] getImageDataFromCache:self.query image:image imageType:small];
    
    if(imageData){
        cell.imageView.image = [UIImage imageWithData:imageData];
        cell.username.text = image.user.username;
    }
    else{
        [[DAO sharedInstance] getThumbnail:self.query forImage:image completionHandler:^(NSString*query, Image* image, NSData *data, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error){
                    NSLog(@"Error loading thumbnail");
                }
                else{
                    cell.imageView.image = [UIImage imageWithData:data];
                    cell.username.text = image.user.username;
                }
            });
            
        }];
    }
    
    //If last cell in collection view is being displayed, load more images.
    //Stop once total number of images has been loaded.
    NSInteger loadedImageCount = [[DAO sharedInstance] getLoadedNumberOfImages:self.query];
    NSInteger totalImageCount = [[DAO sharedInstance] getTotalNumberOfImages:self.query];
    if ((row == (int)[self.foundImages count] - 1) &&
        loadedImageCount < totalImageCount){
        [self loadImages];
    }
        
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger row = [indexPath row];
    Image * selectedImage = self.foundImages[row];
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageDetailsViewController * ivc = (ImageDetailsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ImageDetailsViewController"];
    ivc.image = selectedImage;
    ivc.query = self.query;
    ivc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ivc animated:YES completion:nil];

}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float paddingSpace = 10 * (ITEMS_PER_ROW + 1);
    float availableWidth = self.view.frame.size.width - paddingSpace;
    float widthPerItem = availableWidth / ITEMS_PER_ROW;

    return CGSizeMake(widthPerItem, widthPerItem);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 15.0;
}


#pragma mark DAODelegate
-(void)reloadData{

    [self.activityIndicator stopAnimating];
    [self.refreshControl endRefreshing];
    self.foundImages = [[DAO sharedInstance] getFoundImages:self.query];
    [self.imageGallery reloadData];
}

#pragma mark Filtering
-(IBAction)filter:(id)sender{

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageFilterModalViewController* fvc = (ImageFilterModalViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ImageFilterModalViewController"];
    fvc.modalPresentationStyle = UIModalPresentationCustom;
    fvc.transitioningDelegate = self;
    fvc.delegate = self;
    fvc.imageFilterType = [[DAO sharedInstance] getImageFilter];
    [self presentViewController:fvc animated:YES completion:nil];
    
}

#pragma mark ImageFilterModalDelegate
-(void)processMenuSelection:(ImageFilterType)imageFilterType{
    
    [[DAO sharedInstance] setImageFilter:imageFilterType];
    [self reloadData];
}

#pragma mark ImageFilterPresentationController
-(UIPresentationController*) presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    UIPresentationController * presentationController = [[ImageFilterPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}

-(void)requestError:(NSString *)errorMsg {
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
        
        if(errorMsg){
            [AlertUtility displayAlert:@"Request Unsuccessful"
                                   msg:errorMsg
                        viewController:self];
        }
        else{
            [AlertUtility displayAlert:@"Request Unsuccessful"
                                   msg:@"Unknown error. Please try again."
                        viewController:self];
        }
    });
}


@end
