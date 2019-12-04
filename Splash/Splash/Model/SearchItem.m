//
//  SearchItem.m
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// SearchItem class represents a search query object. It stores
// pertinent information about a search query such as
// total number of images, last page loaded, total images
// loaded. This facilitates paging logic. 
//------------------------------------------------------------

#import "SearchItem.h"

@implementation SearchItem


-(instancetype) init{
    
    self = [super init];
    if(self){
        _query = @"";
        _date = nil;
        _deleted = false;
        _totalImages = 1;
        _totalImagesLoaded = 0;
        _currentPage = 1;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
 
    SearchItem * searchItem = [[SearchItem alloc]init];
    searchItem.query = [_query copyWithZone:zone];
    searchItem.date = [_date copyWithZone:zone];
    searchItem.deleted = _deleted;
    searchItem.totalImages = _totalImages;
    searchItem.currentPage = _currentPage;
    searchItem.totalImagesLoaded = _totalImagesLoaded;
 
    return searchItem;
}
    
@end
