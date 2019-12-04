//
//  StringUtilities.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtility: NSObject
+ (NSString *)percentEscapeString:(NSString *)string;
+ (NSString*)trimSpacesString:(NSString*)string;
@end
