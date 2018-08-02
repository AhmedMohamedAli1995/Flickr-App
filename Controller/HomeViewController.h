//
//  ViewController.h
//  FlickrApp
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCustomCell.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource ,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *photoSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *photoTableView;
@property NSMutableArray *photoArray;
@end

