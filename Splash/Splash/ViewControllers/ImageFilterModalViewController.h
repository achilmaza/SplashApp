//
//  ImageFilterModalViewController.h
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImageFilterModalDelegate <NSObject>

-(void)processMenuSelection:(ImageFilterType)imageFilterType;

@end

@interface ImageFilterModalViewController : UIViewController

@property (nonatomic, weak) id<ImageFilterModalDelegate> delegate;
@property (nonatomic, assign) ImageFilterType imageFilterType;

@end

NS_ASSUME_NONNULL_END
