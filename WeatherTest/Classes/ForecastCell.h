//
//  ForecastCell.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 13.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *forecastDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forecastImageView;

@end
