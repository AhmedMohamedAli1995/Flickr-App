//
//  DetailsViewController.h
//  FlickrApp
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Network.h"


@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailsImage;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailsDesc;
@property Photo *photoObj;
@end
