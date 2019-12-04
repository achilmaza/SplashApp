//
//  SearchItem.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchItem : NSObject

@property (nonatomic, strong) NSString * query;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, assign) Boolean deleted;
@property (nonatomic, assign) NSInteger totalImages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalImagesLoaded;
@property (nonatomic, strong) NSMutableArray * images;

@end

NS_ASSUME_NONNULL_END
