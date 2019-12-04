//
//  ImageDetailsViewController.h
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetailsViewController : UIViewController

@property (nonatomic, strong) Image * image;
@property (nonatomic, strong) NSString * query;

@end

NS_ASSUME_NONNULL_END
