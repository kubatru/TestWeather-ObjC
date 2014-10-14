//
//  ThirdViewController.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 09.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *cellsTitle;

@end
