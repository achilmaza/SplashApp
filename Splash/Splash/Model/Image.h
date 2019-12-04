//
//  Image.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    thumbnail = 0,
    small,
    regular,
    raw
}ImageType;

typedef enum{
    none = 0,
    likesLessThan50,
    likesLessThan200,
    likesGreaterThan200
}ImageFilterType;

@interface Image : NSObject

@property (nonatomic, strong) NSString * altDescription;
@property (nonatomic, strong) NSString * imageId;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSNumber * width;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSNumber * likes;
@property (nonatomic, strong) NSString * downloadLocation;
@property (nonatomic, strong) User * user;
@property (nonatomic, strong) NSMutableDictionary * urls;

-(instancetype) initWithDictionary:(NSDictionary*)dict;
-(NSString*)getSmallImageUrl;
-(NSString*)getRegularImageUrl;
-(NSString*)getId;
-(NSString*)getUsername;
-(NSInteger)getLikes;
-(void)saveData:(NSData*)data imageType:(ImageType)imageType;
-(NSData*)getData:(ImageType)imageType;

@end

NS_ASSUME_NONNULL_END
