//
//  Constants.h
//  PhotoPreviewer
//
//  Created by Ahmed Ali on 7/31/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Base
#define baseUrl @"https://api.flickr.com/services/rest/?"
#define apiKey @"&api_key=0549863663b7ba92e0d3de2b625aae1f"
#define format @"&format=json"
#define noJsonCallBack @"&nojsoncallback=1"

#pragma mark - RecentPhotos
#define perPage @"&per_page=25"
#define page @"&page="
#define recentMethode @"method=flickr.photos.getRecent"

#pragma mark - PhotoUrl
#define photoFarm @"https://farm"
#define photoBaseUrl @".staticflickr.com/"
#define meduim @"_n"
#define small @"_t"
#define large @"_z"
#define extension @".jpg"

#pragma mark - PhotoInfo
#define photoId @"&photo_id="
#define photoSecret @"&secret="
#define infoMethode @"method=flickr.photos.getInfo"

//https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=2a84f1619720ca7d89fbb6883e17c844&photo_id=28821885897&secret=c35be5c8c7&format=json&nojsoncallback=1
//https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=8013632754e388f1c44febeea33afa2d&per_page=25&page=2&format=json&nojsoncallback=1
//https://farm2.staticflickr.com/1772/28821863987_cef7d3dc9d_c.jpg

 
