//
//  ImageCache.h
//  Splash
//
//  Created by Angie Chilmaza on 12/3/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN


@interface ImageCache : NSObject

-(void)addImagesToCache:(NSString*)query images:(NSArray*)images;
-(NSArray*)getImagesFromCache:(NSString*)query;
-(NSArray*)getImagesFromCache:(NSString*)query withFilter:(ImageFilterType)imageFilterType;
-(void)saveImageData:(NSString*)query forImage:(Image*)image data:(NSData*)data imageType:(ImageType)imageType;
-(NSData*)getImageData:(NSString*)query forImage:(Image*)image imageType:(ImageType)imageType;

@end

NS_ASSUME_NONNULL_END
