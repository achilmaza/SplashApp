//
//  RecentSearchViewController.h
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RecentSearchDelegate <NSObject>

-(void)processSearchQuery:(NSString*)query;

@end

@interface RecentSearchViewController : UIViewController

@property (nonatomic, weak) id<RecentSearchDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
