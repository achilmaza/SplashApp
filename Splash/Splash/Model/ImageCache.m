//
//  ImageCache.m
//  Splash
//
//  Created by Angie Chilmaza on 12/3/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// ImageCache class represents the memory cache used
// for managing images. Once data for image is ansynchrously
// loaded, it is placed on cache for subsequent use.
//
//------------------------------------------------------------


#import "ImageCache.h"
#import "Image.h"

@interface ImageCache()

@property (nonatomic, strong) NSMutableDictionary * queryDict;


@end

@implementation ImageCache

-(instancetype) init{
    
    self = [super init];
    if(self){
        _queryDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


-(void)addImagesToCache:(NSString*)query images:(NSArray*)images{
    
    if(query != nil && ![query isEqualToString:@""] && images != nil){
        
        NSMutableArray * imageArray = [[NSMutableArray alloc] initWithCapacity:[images count]];
        NSMutableDictionary * imageIndexDict = [[NSMutableDictionary alloc] initWithCapacity:[images count]];
        
        if(self.queryDict[query]){
            imageArray = self.queryDict[query][@"imageArray"];
            imageIndexDict = self.queryDict[query][@"imageIndexDict"];
        }
        
        int totalImageCount = (int)[images count];

        for(int i = 0; i< totalImageCount; i++){
            Image * image = images[i];
            NSString * imageId = [image imageId];
            if([imageId isEqualToString:@""]){
                continue;
            }
            //Use image id as a key
            [imageArray addObject:image];
            imageIndexDict[imageId] = [[NSNumber alloc] initWithInteger:[imageArray count]-1];
        }
        
        self.queryDict[query] = @{@"imageArray":imageArray, @"imageIndexDict": imageIndexDict};
    }

}

-(NSArray*)getImagesFromCache:(NSString*)query{

    NSArray * images = [[NSArray alloc]init];
    
    if(![query isEqualToString:@""]){
        images = self.queryDict[query][@"imageArray"];
    }
    
    return images;
}

-(NSArray*)getImagesFromCache:(NSString*)query withFilter:(ImageFilterType)imageFilterType{

    NSMutableArray * images = [[NSMutableArray alloc]init];
  
    if(![query isEqualToString:@""]){
        
        //If no filter, return all images
        if(imageFilterType == none){
            return self.queryDict[query][@"imageArray"];
        }
        
        //go through images and filter based on filter type
        NSArray * unfilteredImages = self.queryDict[query][@"imageArray"];
        
        for(Image * image in unfilteredImages){
            NSInteger likesCount = [image getLikes];
            
            if((likesCount > 200 && imageFilterType == likesGreaterThan200) ||
               (likesCount >= 51 && likesCount <= 200 && imageFilterType == likesLessThan200) ||
               (likesCount >=0 && likesCount <=50 && imageFilterType == likesLessThan50)){
                [images addObject:image];
            }
        }
    }
    
    return images;
}


-(void)saveImageData:(NSString*)query forImage:(Image*)image data:(NSData*)data imageType:(ImageType) imageType{
    
    if(![query isEqualToString:@""] && data!=nil && image!=nil){
     
        if(self.queryDict[query]){
            NSMutableArray * imageArray = imageArray = self.queryDict[query][@"imageArray"];
            NSMutableDictionary * imageIndexDict = imageIndexDict = self.queryDict[query][@"imageIndexDict"];
            
            NSString * imageId = [image getId];
            NSNumber * index = imageIndexDict[imageId];
            
            Image * savedImage = [imageArray objectAtIndex:[index intValue]];
            if(savedImage){
                [savedImage saveData:data imageType:imageType];
            }
            
        }
        
    }
    
}

-(NSData*)getImageData:(NSString*)query forImage:(Image*)image imageType:(ImageType)imageType{
    
    NSData * data = nil;
    
    if(![query isEqualToString:@""] && image!=nil){
        
        if(self.queryDict[query]){
            NSMutableArray * imageArray = imageArray = self.queryDict[query][@"imageArray"];
            NSMutableDictionary * imageIndexDict = imageIndexDict = self.queryDict[query][@"imageIndexDict"];
            
            NSString * imageId = [image getId];
            NSNumber * index = imageIndexDict[imageId];
            
            Image * savedImage = [imageArray objectAtIndex:[index intValue]];
            if(savedImage){
                data = [savedImage getData:imageType];
            }
        }
    }
    
    return data;
    
}




@end
