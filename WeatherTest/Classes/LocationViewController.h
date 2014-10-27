//
//  LocationViewController.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "TestWeatherHTTPClient.h"
#import "ForecastCell.h"

@interface LocationViewController : UIViewController <SWTableViewCellDelegate, CLLocationManagerDelegate, WeatherHTTPClientDelegate, UITableViewDataSource, UITableViewDelegate>

{
    NSUserDefaults *defaults;
    CLPlacemark *placemark;
    UIRefreshControl *refreshControl;
    NSTimer *timer;
    NSTimer *finalCheckTimer;
    UIImageView *current;
    NSArray *selectedLocation;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *addLocationBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) NSMutableArray *descriptionArray;
@property (strong, nonatomic) NSMutableArray *temperatureCArray;
@property (strong, nonatomic) NSMutableArray *temperatureFArray;

@end
