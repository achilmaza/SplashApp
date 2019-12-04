//
//  SuggestedSearchViewController.h
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SuggestedSearchDelegate <NSObject>

-(void)processSearchQuery:(NSString*)query;

@end

@interface SuggestedSearchViewController : UIViewController

@property (nonatomic, weak) id<SuggestedSearchDelegate> delegate;
-(void)searchQuery:(NSString*)searchString;

@end

NS_ASSUME_NONNULL_END
