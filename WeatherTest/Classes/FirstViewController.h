//
//  FirstViewController.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 09.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestWeatherHTTPClient.h"

@interface FirstViewController : UIViewController <CLLocationManagerDelegate, WeatherHTTPClientDelegate>

{
    NSUserDefaults *defaults;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *greenArrow;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipMMLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;

@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDir16pointLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property(strong) NSDictionary *weather;

+ (NSString*) globalCityNameString;
+ (NSMutableArray*) forecastDaysArray;
+ (NSMutableArray*) forecastDescriptionsArray;
+ (NSMutableArray*) forecastAverageCArray;
+ (NSMutableArray*) forecastAverageFArray;

@end

