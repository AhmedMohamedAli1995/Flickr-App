//
//  Network.h
//  FlickrApp
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Photo.h"
#import "Constants.h"


@interface Network : NSObject
+(void) requestForNextFlickrPhotosPage:(void (^)(NSMutableArray*))successBlock failure:(void (^)(NSError *))failureBlock;
+(void) requestForPhotoInfo:(NSString*)photoID secret:(NSString*)secret success:(void (^)(NSString*))successBlock failure:(void (^)(NSError *))failureBlock;
@end
