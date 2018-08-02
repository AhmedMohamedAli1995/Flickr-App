//
//  DetailsViewController.m
//  FlickrApp
//
//  Created by Ahmed Ali on 7/30/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import "DetailsViewController.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailsTitle.text = _photoObj.title;
    _detailsDesc.text = [self html2String:_photoObj.desc];
    NSString * url = [[_photoObj.photoUrl stringByAppendingString:large] stringByAppendingString:extension];
    [_detailsImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"22"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)html2String:(NSString *)htmlDesc{
    NSString *htmlString=[[NSString alloc]initWithFormat:@"%@", htmlDesc];
    //Converting HTML string with UTF-8 encoding to NSAttributedString
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil ];
    return attributedString.string;
}
@end
