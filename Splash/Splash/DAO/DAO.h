//
//  DAO.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DAODelegate <NSObject>

-(void)reloadData;
-(void)requestError:(NSString*)erroMsg;

@end


@interface DAO : NSObject

+(instancetype)sharedInstance;
-(void)getImageList:(NSString*)query delegate:(id<DAODelegate>)delegate;
-(NSArray*)getRecentSearches;
-(NSArray*)getFoundImages:(NSString*)query;
-(void)getThumbnail:(NSString*)query forImage:(Image*)image completionHandler:(void (^)(NSString * query, Image* image, NSData*data, NSError*error))completionHandler;
-(void)getRegular:(NSString*)query forImage:(Image*)image completionHandler:(void (^)(NSString * query, Image* image, NSData*data, NSError*error))completionHandler;
-(NSData*)getImageDataFromCache:(NSString*)query image:(Image*)image imageType:(ImageType)imageType;
-(NSInteger)getTotalNumberOfImages:(NSString*)query;
-(NSInteger)getLoadedNumberOfImages:(NSString*)query;
-(void) setImageFilter:(ImageFilterType)imageFilterType;
-(void) resetImageFilters;
-(ImageFilterType) getImageFilter;

@end

NS_ASSUME_NONNULL_END
