//
//  SecondViewController.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 09.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "TestWeatherHTTPClient.h"

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

