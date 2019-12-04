//
//  ImageUrl.h
//  Splash
//
//  Created by Angie Chilmaza on 12/3/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageUrl : NSObject

@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSData * imageData;

-(instancetype) initWithUrl:(NSString*)url;
-(void)saveData:(NSData*)data;
-(NSData*)getData;

@end

NS_ASSUME_NONNULL_END
