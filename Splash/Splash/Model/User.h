//
//  User.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * username;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
