//
//  StringUtilities.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import "StringUtility.h"

@implementation StringUtility

+(NSString *)percentEscapeString:(NSString *)string {
    NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowed];
}

+(NSString*)trimSpacesString:(NSString*)string{
    
    NSString * trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
    
}

@end
