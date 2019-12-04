//
//  AppDelegate.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    UINavigationBar * navigationBarAppearance = [UINavigationBar appearance];
    UIFont * fontNavbar = [UIFont fontWithName:@"Avenir-Heavy" size:19.0f];
    UIColor * foregroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0]; //sea green
    UIColor * backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    navigationBarAppearance.tintColor = foregroundColor;
    navigationBarAppearance.barTintColor = backgroundColor;
    navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:foregroundColor,
                                                    NSFontAttributeName:fontNavbar};
    navigationBarAppearance.shadowImage = [[UIImage alloc] init];
    
    return YES;
}


@end
