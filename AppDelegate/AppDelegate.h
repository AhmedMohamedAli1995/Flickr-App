//
//  AppDelegate.h
//  PhotoPreviewer
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

