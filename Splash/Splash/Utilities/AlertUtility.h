//
//  AlertUtilities.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertUtility: NSObject

+(void)displayAlert:(NSString*)title msg:(NSString*)msg viewController:(UIViewController*)viewController;

@end
