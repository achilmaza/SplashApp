//
//  ImageFilterMenuTableViewController.h
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImageFilterMenuDelegate <NSObject>

-(void)processMenuSelection:(ImageFilterType)imageFilterType;

@end

@interface ImageFilterMenuTableViewController : UITableViewController

@property (nonatomic, weak) id<ImageFilterMenuDelegate> delegate;
@property (nonatomic, assign) ImageFilterType imageFilterType;
@end

NS_ASSUME_NONNULL_END
