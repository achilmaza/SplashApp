//
//  User.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// User class represents the user associated with an image.
//------------------------------------------------------------



#import "User.h"
#import "Utilities.h"

@implementation User

-(instancetype) init{
    
    self = [super init];
    if(self){
        _username = @"";
        _name = @"";
    }
    return self;
}

-(instancetype) initWithDictionary:(NSDictionary*)dict{
    
    self = [super init];
    
    if(self){
        
        if(dict == nil) return nil;
        
        if(ObjOrNil(dict[@"name"])){
            _name = dict[@"name"];
        }
        else{
           _name = @"";
        }
        
        if(ObjOrNil(dict[@"username"])){
            _username = dict[@"username"];
        }
        else{
            _username = @"";
        }
 
    }
    
    return self;
    
}


@end
