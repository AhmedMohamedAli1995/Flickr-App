//
//  Photo.h
//  PhotoPreviewer
//
//  Created by Ahmed Ali on 7/31/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface Photo : RLMObject
    
@property NSString * Id;
@property NSString * server;
@property NSString * farm;
@property NSString * secret;
@property NSString * title;
@property NSString * desc;
@property NSString * photoUrl;
    
@end
