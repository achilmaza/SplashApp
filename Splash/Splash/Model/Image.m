//
//  Image.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// Image class represents an image object. It parses
// JSON data obtained from Unsplash API call and stores pertinent
// image information.
//------------------------------------------------------------


#import "Image.h"
#import "Utilities.h"
#import "User.h"
#import "ImageUrl.h"


@implementation Image

-(instancetype) init{
    
    self = [super init];
    if(self){
        [self initWithDefaults];
    }
    
    return self;
    
}

-(void)initWithDefaults{
    
   _altDescription = @"";
   _imageId = @"";
   _createdAt = nil;
   _updatedAt = nil;
   _desc = @"";
   _width  = [[NSNumber alloc] initWithInt:0];
   _height = [[NSNumber alloc] initWithInt:0];
    _likes = [[NSNumber alloc] initWithInt:0];
   _downloadLocation = @"";
    _user = [[User alloc]init];
   _urls = [[NSMutableDictionary alloc] init];
    
}

-(instancetype) initWithDictionary:(NSDictionary*)dict{
    
    self = [super init];
    
    if(self){
        
        if(dict == nil) return nil;
        
        [self initWithDefaults];
        
        if(ObjOrNil(dict[@"alt_description"])){
            _altDescription = dict[@"alt_description"];
        }

        if(ObjOrNil(dict[@"description"])){
            _desc = dict[@"description"];
        }
        
        if(ObjOrNil(dict[@"id"])){
            _imageId = dict[@"id"];
        }
        
        if(ObjOrNil(dict[@"width"])){
            _width  = [NSNumber numberWithInteger:[dict[@"width"] integerValue]];
        }
                     
        if(ObjOrNil(dict[@"height"])){
            _height = [NSNumber numberWithInteger:[dict[@"height"] integerValue]];
        }
        
        if(ObjOrNil(dict[@"likes"])){
            _likes = [NSNumber numberWithInteger:[dict[@"likes"] integerValue]];
        }
        
                     
        if(ObjOrNil(dict[@"links"]) &&
           ObjOrNil(dict[@"links"][@"download_location"])){
            _downloadLocation = dict[@"links"][@"download_location"];
        }
        
        _urls = [[NSMutableDictionary alloc] init];
        
        if(ObjOrNil(dict[@"urls"])){
            
            if(ObjOrNil(dict[@"urls"][@"raw"])){
                _urls[@"raw"] = [[ImageUrl alloc] initWithUrl:dict[@"urls"][@"raw"]];
            }
            
            if(ObjOrNil(dict[@"urls"][@"small"])){
                _urls[@"small"] = [[ImageUrl alloc] initWithUrl:dict[@"urls"][@"small"]];
            }
            
            if(ObjOrNil(dict[@"urls"][@"regular"])){
                _urls[@"regular"] = [[ImageUrl alloc] initWithUrl:dict[@"urls"][@"regular"]];
            }
            
            if(ObjOrNil(dict[@"urls"][@"thumb"])){
                _urls[@"thumb"] = [[ImageUrl alloc] initWithUrl:dict[@"urls"][@"thumb"]];
            }
        }
            
        if(ObjOrNil(dict[@"user"])){
            _user = [[User alloc] initWithDictionary:dict[@"user"]];
        }
        
    }
    
    return self;
    
}

-(NSString*)getSmallImageUrl{
    
    ImageUrl * imageUrl = self.urls[@"small"];
    return imageUrl.url;
}

-(NSString*)getRegularImageUrl{
    
    ImageUrl * imageUrl = self.urls[@"regular"];
    return imageUrl.url;
}


-(NSString*)getId{
    
    return self.imageId;
}

-(NSString*)getUsername{

   return self.user.username; 
}

-(NSInteger)getLikes{
    
    return[self.likes intValue];
}

-(void)saveData:(NSData*)data imageType:(ImageType)imageType{
    
    ImageUrl * imageUrl = nil;
    
    switch(imageType){
        case thumbnail:
            imageUrl =  self.urls[@"thumb"];
            break;
        case small:
            imageUrl =  self.urls[@"small"];
            break;
        case regular:
            imageUrl =  self.urls[@"regular"];
            break;
        case raw:
            imageUrl =  self.urls[@"raw"];
            break;
        default:
            break;
    }
    
    if(imageUrl){
        [imageUrl saveData:data];
    }
}

-(NSData*)getData:(ImageType)imageType{
    
    NSData * data = nil;
    ImageUrl * imageUrl = nil;
       
   switch(imageType){
       case thumbnail:
           imageUrl =  self.urls[@"thumb"];
           break;
       case small:
           imageUrl =  self.urls[@"small"];
           break;
       case regular:
           imageUrl =  self.urls[@"regular"];
           break;
       case raw:
           imageUrl =  self.urls[@"raw"];
           break;
       default:
           break;
   }
   
   if(imageUrl){
       data = [imageUrl getData];
   }
    
   return data;
    
}

@end
