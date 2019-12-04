//
//  Utilities.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

id ObjOrNil(id obj){
    
    if(![obj isEqual:[NSNull null]] && obj!=nil){
        return obj;
    }
    else{
        return nil;
    }
}

@end
