//
//  SearchViewController.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLocationHTTPClient.h"

@interface SearchViewController : UIViewController <SearchLocationHTTPClientDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeBtn;
@property(strong) NSDictionary *cities;
@property(strong, nonatomic) NSString *searchBarText;

@end
