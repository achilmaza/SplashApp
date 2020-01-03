//
//  DAO.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------------
// DAO (Data Access Object) class represents the model (MVC).
// It uses the singleton pattern to allow for a centralized point of
// access. Handles Unsplash API calls. It caches recent searches in
// memory and uses ImageCache object to cache data from api calls.
//------------------------------------------------------------------

#import "DAO.h"
#import "ConvertJSONUtility.h"
#import "StringUtility.h"
#import "Utilities.h"
#import "SearchItem.h"
#import "Image.h"
#import "ImageCache.h"

static NSString * const accessKey = @"eb2c4d30ab31ccbebb33e632c2114e6aadc966b0f107971afc0956b93d67ac59";
static NSString * const secretKey = @"dd31b8c66f4bc6ffffe43d0ec88336ff5742a9cd5039661c18e836427cd027ed";

@interface DAO () <NSURLSessionDelegate>
@property (nonatomic, strong) NSMutableArray * recentSearches;
@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSMutableDictionary * searchIndexDict;
@property (nonatomic, strong) ImageCache * imageCache;
@property (nonatomic, strong) NSString * lastSearch;
@property (nonatomic, assign) ImageFilterType imageFilterType;

@end


@implementation DAO


- (instancetype)init{

    self = [super init];
    if(self){
        _recentSearches = [[NSMutableArray alloc] init];
        _searchIndexDict = [[NSMutableDictionary alloc] init];
        _imageCache = [[ImageCache alloc] init];
        _lastSearch = @"";
        _imageFilterType = none;
    }
    
    return self;
}

//Singleton pattern
+(instancetype)sharedInstance{
    
    static id _sharedInstance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


-(void)getImageList:(NSString*)query delegate:(id<DAODelegate>)delegate{
    
    NSInteger currentPage = 1;
    NSInteger totalImagesLoaded = 0;
    NSInteger totalImages = 0;
    
    if([query isEqualToString:@""] || delegate == nil) return;
    
    //Get query details from cache
    if(self.searchIndexDict[query]){
       NSInteger index = [self.searchIndexDict[query] integerValue];
       SearchItem * searchItem = [self.recentSearches objectAtIndex:index];
       currentPage = searchItem.currentPage + 1;
       totalImagesLoaded = searchItem.totalImagesLoaded;
       totalImages = searchItem.totalImages;
    
       //Do not make further api calls if total number of images has been loaded.
       if(totalImages == totalImagesLoaded && totalImagesLoaded != 0){
          if([delegate respondsToSelector:@selector(reloadData)]){
             [delegate reloadData];
          }
         return;
       }
    }


    //Create session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json"}];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSString * baseURL = [NSString stringWithFormat:@"https://api.unsplash.com/search/photos?client_id=%@&query=%@&page=%ld&per_page=20", accessKey, [StringUtility percentEscapeString:query],currentPage];
    
    NSURL* url = [NSURL URLWithString:baseURL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request
                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        __strong typeof(self) strongself = weakself;
        
        if(error || strongself == nil){
            NSLog(@"getImageList: error = %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate requestError:@"Images failed to load. Please try again"];
            });
            return;
        }
        
        if(data){
            NSDictionary * result = [ConvertJSONUtility convertJSONToDict:data];
            
            if(ObjOrNil(result)){
                
                NSArray * photos = result[@"results"];
                NSInteger totalImages = 0;
                
                if(ObjOrNil(photos)){

                    NSMutableArray * images = [[NSMutableArray alloc] initWithCapacity:[photos count]];
                    for(NSDictionary * dict in photos){
                        Image * image = [[Image alloc] initWithDictionary:dict];
                        [images addObject:image];
                    }
                                               
                    [strongself.imageCache addImagesToCache:query images:images];
                    
                    //Get total image count
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if(ObjOrNil(httpResponse)){
                        NSDictionary * httpHeaderFields = [httpResponse allHeaderFields];
                        if(ObjOrNil(httpHeaderFields[@"x-total"])){
                            totalImages = [httpHeaderFields[@"x-total"] intValue];
                        }
                    }
                    
                    //Check if current search is equal to last search.
                    //If equal, do not add to query string cache but do update current page number.
                    //This logic handles paging.
                    if([self.lastSearch isEqualToString:query]){
                        if(strongself.searchIndexDict[query]){
                           NSInteger index = [strongself.searchIndexDict[query] integerValue];
                           SearchItem * searchItem = [strongself.recentSearches objectAtIndex:index];
                           searchItem.currentPage = currentPage;
                           searchItem.totalImages = totalImages;
                           searchItem.totalImagesLoaded = totalImagesLoaded + (int)[photos count];
                       }
                                           
                    }
                    else{
                        //Check if query has been previously done.
                        //If so, mark query as deleted and re-add at end of recentSearches array
                        if(strongself.searchIndexDict[query]){
                            NSInteger index = [strongself.searchIndexDict[query] integerValue];
                            SearchItem * searchItem = [strongself.recentSearches objectAtIndex:index];
                            searchItem.deleted = true;
                        }
                        
                        SearchItem * searchItem = [[SearchItem alloc]init];
                        searchItem.query = query;
                        searchItem.date = [NSDate date];
                        searchItem.currentPage = currentPage;
                        searchItem.totalImagesLoaded = totalImagesLoaded + (int)[photos count];
                        searchItem.totalImages = totalImages;
                        [strongself.recentSearches addObject:searchItem];
                
                        NSNumber * index = [[NSNumber alloc] initWithInteger:((int)[strongself.recentSearches count]-1)];
                        strongself.searchIndexDict[query] = index;
                    }
                
                    self.lastSearch = query;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([delegate respondsToSelector:@selector(reloadData)]){
                           [delegate reloadData];
                        }
                    });
                }
            }
           
        }
        
    }];
    
    
    [task resume];

}


-(void)getThumbnail:(NSString*)query forImage:(Image*)image completionHandler:(void (^)(NSString * query, Image* image, NSData*data, NSError*error))completionHandler{

        //Create session
       NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
       [sessionConfiguration setAllowsCellularAccess:YES];
       self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
       
       NSString * stringUrl = [image getSmallImageUrl];
       NSURL* url = [NSURL URLWithString:stringUrl];
       
       NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
       request.HTTPMethod = @"GET";
    
        __weak typeof(self) weakself = self;
       NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
            __strong typeof(self) strongself = weakself;
           
           if(error || strongself == nil){
              NSLog(@"getThumbnail: error loading thumbnail = %@", error);
           }
           else{
               if(data != nil){
                   [strongself.imageCache saveImageData:query forImage:image data:data imageType:small];
               }
           }
           
           dispatch_async(dispatch_get_main_queue(), ^{
               completionHandler(query, image, data, error);
           });
                          
      }];
                          
                          
      [task resume];

}

-(void)getRegular:(NSString*)query forImage:(Image*)image completionHandler:(void (^)(NSString * query, Image* image, NSData*data, NSError*error))completionHandler{

        //Create session
       NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
       [sessionConfiguration setAllowsCellularAccess:YES];
       self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
       
       NSString * stringUrl = [image getRegularImageUrl];
       NSURL* url = [NSURL URLWithString:stringUrl];
       
       NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
       request.HTTPMethod = @"GET";
    
       __weak typeof(self) weakself = self;
       NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(self) strongself = weakself;
           
           if(error || strongself == nil){
                NSLog(@"getRegular: error loading regular image = %@", error);
           }
           else{
               if(data!=nil){
                    [strongself.imageCache saveImageData:query forImage:image data:data imageType:regular];
               }
           }
           
           dispatch_async(dispatch_get_main_queue(), ^{
               completionHandler(query, image, data, error);
           });
                          
      }];
                          
                          
      [task resume];

}


-(NSArray*)getRecentSearches{
    
   NSMutableArray * searches = [[NSMutableArray alloc] initWithCapacity:[self.recentSearches count]];
    
   if([self.recentSearches count] > 0){
        for(int i = (int)[self.recentSearches count] - 1; i>=0; i--){
            SearchItem * searchItem = [self.recentSearches objectAtIndex:i];
            if(!searchItem.deleted){
                [searches addObject:[searchItem copy]];
            }
        }
    }
    
    return searches;
}

-(NSArray*)getFoundImages:(NSString*)query{
    
    if([query isEqualToString:@""]) return nil;
    
    NSArray * foundImages = [self.imageCache getImagesFromCache:query withFilter:self.imageFilterType];
    
    return foundImages;
}

-(NSData*)getImageDataFromCache:(NSString*)query image:(Image*)image imageType:(ImageType)imageType{

    NSData * data = [self.imageCache getImageData:query forImage:image imageType:imageType];
    return data;
}

-(NSInteger)getTotalNumberOfImages:(NSString*)query{
    
    NSInteger total = 0;
    
    if(self.searchIndexDict[query]){
        NSInteger index = [self.searchIndexDict[query] integerValue];
        SearchItem * searchItem = [self.recentSearches objectAtIndex:index];
        total = searchItem.totalImages;
    }
    
    return total;
}

-(NSInteger)getLoadedNumberOfImages:(NSString*)query{
    
    NSInteger total = 0;
    
    if(self.searchIndexDict[query]){
        NSInteger index = [self.searchIndexDict[query] integerValue];
        SearchItem * searchItem = [self.recentSearches objectAtIndex:index];
        total = searchItem.totalImagesLoaded;
    }
    
    return total;
}

-(void) setImageFilter:(ImageFilterType)imageFilterType{
    
    self.imageFilterType = imageFilterType;
}


-(ImageFilterType) getImageFilter{
    
    return self.imageFilterType;
}

-(void) resetImageFilters{
    
    self.imageFilterType = none;
}

    
@end
