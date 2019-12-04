//
//  ImageUrl.m
//  Splash
//
//  Created by Angie Chilmaza on 12/3/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// ImageUrl class associates image raw data with url.
//------------------------------------------------------------


#import "ImageUrl.h"

@implementation ImageUrl


-(instancetype) init{
    
    self = [super init];
    if(self){
        _url = @"";
        _imageData = nil;
    }
    
    return self;
}

-(instancetype) initWithUrl:(NSString*)url{
    
    self = [super init];
    if(self){
        _url = url;
        _imageData = nil;
    }
    
    return self;
}

-(void)saveData:(NSData*)data{
    self.imageData = data;
}

-(NSData*)getData{
    
    return self.imageData;
}


@end
