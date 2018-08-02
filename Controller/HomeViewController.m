//
//  ViewController.m
//  FlickrApp
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//


#import "DetailsViewController.h"
#import "HomeViewController.h"
#import "Network.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Realm.h>
#import "Reachability.h"

@interface HomeViewController ()
{
    Reachability* reachability;
    NetworkStatus remoteHostStatus;
    NSMutableArray<Photo *> *photos;
    NSMutableArray<Photo *> *filterdPhotos;

    BOOL isFiltered;
    BOOL fetchingMore;
    BOOL isFirstRequest;
}
@end

@implementation HomeViewController

#pragma mark - Table view data source

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{ NSLog(@"user enter search bar");
    if(searchText.length == 0){
        isFiltered = false ;
    }
    else{
        isFiltered = true;
        filterdPhotos= [[NSMutableArray alloc]init];
        for(Photo *photo in photos ){
            NSRange nameRange = [photo.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [filterdPhotos addObject:photo];
                
            }
            
        }
    }
    [_photoTableView reloadData];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"numberOfSectionsInTableViewcalled");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {        
    if(isFiltered){
        return filterdPhotos.count;
    }
    return photos.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"cellForRowAtIndexPathcalled");
     
     PhotoCustomCell *cell = (PhotoCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
     NSString * url = [[photos[indexPath.row].photoUrl stringByAppendingString:small] stringByAppendingString:extension];
     NSLog(@"url is %@",url);
     if(isFiltered){
         cell.cellTitle.text = filterdPhotos[indexPath.row].title;
         [cell.cellPhoto sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"22"]];
     }
     else{
        cell.cellTitle.text = photos[indexPath.row].title;
         [cell.cellPhoto sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"22"]];
         
     }
         
     
     return cell;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Photo *photoObjectFromTable =photos[indexPath.row];
    if([self checkForNetwork]){
        if(photoObjectFromTable.desc == nil){
            [Network requestForPhotoInfo:photoObjectFromTable.Id secret:photoObjectFromTable.secret success:^(NSString * response) {
                DetailsViewController * DetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
                photoObjectFromTable.desc = response;
                DetailsView.photoObj = photoObjectFromTable;
                [self.navigationController pushViewController:DetailsView animated:false];
            } failure:^(NSError * error) {
                NSLog(@"%@",error);
            }];
        }else{
            DetailsViewController * DetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
            DetailsView.photoObj = photoObjectFromTable;
            [self.navigationController pushViewController:DetailsView animated:false];
        }
    }else{
        //add alert
        [self showAler:@"Attention !!" :@"Internet not available, Please check your internet connectivity and try again"];
    }
}

    
    
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        long lastItem = photos.count - 1 ;
        if(indexPath.row == lastItem){
            //request more information
            if([self checkForNetwork]){
                 [self loadMoreDate];
            }else{
                [self showAler:@"Atenntion" :@"Nointernte to load More !"];
            }
           
        }
}//to load more data
    
-(void)loadMoreDate{
    [self getPhotoPages];
    [_photoTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoSearchBar.delegate = self;
    [_photoTableView setDelegate:self];
    [_photoTableView setDataSource:self];
    photos = [[NSMutableArray alloc] init];
    isFiltered = false;
    isFirstRequest = true;
    
    //here check for internet
    
    
    if([self checkForNetwork]) {
        NSLog(@"yes");
        [self getPhotoPages];
    }else{
        //here to get from realm
        RLMResults<Photo *> *temp = [Photo allObjects];
        if(temp.count == 0)
        {
           
            [self showAler:@"Attention" :@"please connect to network to complete registration"];
            //show alert
        }
            self->photos = temp;
            [self->_photoTableView reloadData];
        
    }
    
}
    
-(void)getPhotoPages{
    [Network requestForNextFlickrPhotosPage:^(NSMutableArray* response) {
        [self->photos addObjectsFromArray:response];
        [self->_photoTableView reloadData];
        if(self->isFirstRequest){
            [self savingValues];
            self->isFirstRequest = false;
        }
    } failure:^(NSError * error) {
    }];
}//request pages
    
-(void) savingValues{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSLog(@"%lu gfggggff", (unsigned long)photos.count);
    for (int i=0; i<photos.count; i++) {
        Photo *temp = [Photo new];
        temp.Id = photos[i].Id;
        temp.desc = photos[i].desc;
        temp.title = photos[i].title;
        temp.photoUrl = photos[i].photoUrl;
        [realm addObject:temp];
    }
    [realm commitWriteTransaction];
}
    -(void)showAler :(NSString*) title :(NSString*) message{
        
        
        
        UIAlertController * alert = [UIAlertController
                                     
                                     alertControllerWithTitle:title
                                     
                                     message:message
                                     
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton =[UIAlertAction actionWithTitle:@"Ok" style:UIAlertViewStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[NSThread mainThread] cl];
            NSLog(@"close");
        }];
        
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    //[[NSThread mainThread] exit]
-(Boolean) checkForNetwork{
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus != NotReachable){
        NSLog(@"connected To Network");
       return true ;
    }
    return false;
}


    
@end
