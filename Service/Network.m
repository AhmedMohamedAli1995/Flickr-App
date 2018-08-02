//
//  Network.m
//  FlickrApp
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import "Network.h"

@implementation Network
    
    //typedef enum PhotoSize
    //{
    //    SMALL,
    //    MEDUIM,
    //    LARGE
    //} PhotoSize;
    
    static int numOfPages = 1;
static NSMutableArray * photoArray;
    
+(NSMutableString *) buildPhotoUrl:(Photo *)flickrPhoto{
    //https://farm{farm}.staticflickr.com/{server}/{id}_{secret}_{size}{extension}
    NSMutableString * url = [[NSMutableString alloc] initWithString:photoFarm];
    [url appendString:flickrPhoto.farm];
    [url appendString:photoBaseUrl];
    [url appendString:flickrPhoto.server];
    [url appendString:@"/"];
    [url appendString:flickrPhoto.Id];
    [url appendString:@"_"];
    [url appendString:flickrPhoto.secret];
    return url;
}
    
+(NSMutableString *) buildRecentPhotosUrl{
    //https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=8013632754e388f1c44febeea33afa2d&per_page=25&page=2&format=json&nojsoncallback=1
    NSMutableString * url = [[NSMutableString alloc] initWithString:baseUrl];
    [url appendString:recentMethode];
    [url appendString:apiKey];
    [url appendString:perPage];
    [url appendString:page];
    [url appendString:[NSString stringWithFormat:@"%i", numOfPages]];
    [url appendString:format];
    [url appendString:noJsonCallBack];
    return url;
}
    
+(NSMutableString *) buildPhotoInfoUrl:(NSString*)Id secret:(NSString*)secret{
    //https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=2a84f1619720ca7d89fbb6883e17c844&photo_id=28821885897&secret=c35be5c8c7&format=json&nojsoncallback=1
    NSMutableString * url = [[NSMutableString alloc] initWithString:baseUrl];
    [url appendString:infoMethode];
    [url appendString:apiKey];
    [url appendString:photoId];
    [url appendString:Id];
    [url appendString:photoSecret];
    [url appendString:secret];
    [url appendString:format];
    [url appendString:noJsonCallBack];
    return url;
}
    
+(void) requestForNextFlickrPhotosPage:(void (^)(NSMutableArray*))successBlock failure:(void (^)(NSError *))failureBlock{
    photoArray = [NSMutableArray new];
    [Network getData:[Network buildRecentPhotosUrl] success:^(id response) {
        NSLog(@"%@",response);
        NSDictionary * json = (NSDictionary *)response;
        id photos = json[@"photos"];
        NSArray * photosArray = photos[@"photo"];
        for (id photoObj in photosArray) {
            Photo * flickrPhoto = [Photo new];
            flickrPhoto.Id = [photoObj valueForKey:@"id"];
            flickrPhoto.secret = [photoObj valueForKey:@"secret"];
            flickrPhoto.server = [photoObj valueForKey:@"server"];
            flickrPhoto.farm =   [NSString stringWithFormat:@"%@", photoObj[@"farm"]];
            NSLog(@"%@",flickrPhoto.farm);
            flickrPhoto.title = [photoObj valueForKey:@"title"];
            if([flickrPhoto.title  isEqual: @""] || [flickrPhoto.title isEqualToString:@""]){
                
                flickrPhoto.title = @"*No Title*";
            }
            flickrPhoto.photoUrl = [Network buildPhotoUrl:flickrPhoto];
            [photoArray addObject:flickrPhoto];
        }
        NSLog(@"array size :%lu",(unsigned long)[photoArray count]);
        successBlock(photoArray);
    } failure:^(NSError * error) {
        failureBlock(error);
    }];
    numOfPages++;
}
    
+(void) requestForPhotoInfo:(NSString*)photoID secret:(NSString*)secret success:(void (^)(NSString*))successBlock failure:(void (^)(NSError *))failureBlock{
    [Network getData:[Network buildPhotoInfoUrl:photoID secret:secret] success:^(id response) {
        NSDictionary * json = (NSDictionary *)response;
        id photo = [json  valueForKey:@"photo"];
        id photoDesc = [photo  valueForKey:@"description"];
        NSString * desc = [photoDesc valueForKey:@"_content"];
        if([desc  isEqual: @""]){
            desc = @"*No Description For This Image*";
        }
        successBlock(desc);
    } failure:^(NSError * error) {
        failureBlock(error);
    }];
}
    
    //+(void) requestForFlickrPhoto:(FlickrPhoto*)flickrPhoto size:(PhotoSize)photoSize success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock{
    //    NSString * size;
    //    switch (photoSize) {
    //        case SMALL:
    //            size = small;
    //            break;
    //        case MEDUIM:
    //            size = meduim;
    //            break;
    //        case LARGE:
    //            size = large;
    //            break;
    //        default:
    //            break;
    //    }
    //    NSMutableString * url = [Network buildPhotoUrl:flickrPhoto];
    //    [url appendString:size];
    //    [url appendString:extension];
    //    [Network getData:url success:^(id response) {
    //        successBlock(response);
    //    } failure:^(NSError * error) {
    //        failureBlock(error);
    //    }];
    //}
    
+(void) getData:(NSString*)request success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:request];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:nsrequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            failureBlock(error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            successBlock(responseObject);
        }
    }];
    [dataTask resume];
}
    
    @end
