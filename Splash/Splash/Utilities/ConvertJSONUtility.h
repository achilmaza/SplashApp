//
//  ConvertUtility.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertJSONUtility : NSObject

+(NSData*) convertDictToJSON:(NSDictionary*)dict;
+(NSDictionary*) convertJSONToDict:(NSData*)data;
+(NSArray*) convertJSONToArray:(NSData*)data;


@end
