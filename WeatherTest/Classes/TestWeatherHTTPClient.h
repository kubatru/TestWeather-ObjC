//
//  TestWeatherHTTPClient.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 11.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CoreLocation/CoreLocation.h"

@protocol WeatherHTTPClientDelegate;

@interface WeatherHTTPClient : AFHTTPSessionManager <CLLocationManagerDelegate>

@property (nonatomic, weak) id<WeatherHTTPClientDelegate>delegate;

+ (WeatherHTTPClient *)sharedWeatherHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number;

@end

@protocol WeatherHTTPClientDelegate <NSObject>

@optional
-(void)weatherHTTPClient:(WeatherHTTPClient *)client didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(WeatherHTTPClient *)client didFailWithError:(NSError *)error;

@end