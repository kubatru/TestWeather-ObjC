//
//  TestWeatherHTTPClient.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 11.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "TestWeatherHTTPClient.h"
#import "Constants.h"

// Set this to your World Weather Online API Key
static NSString *const WorldWeatherOnlineAPIKey = WorldWeatherOnlineApiKey;

static NSString *const WorldWeatherOnlineURLString = @"http://api.worldweatheronline.com/free/v1/";

@implementation WeatherHTTPClient

+ (WeatherHTTPClient *)sharedWeatherHTTPClient
{
    static WeatherHTTPClient *_sharedWeatherHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:WorldWeatherOnlineURLString]];
    });
    
    return _sharedWeatherHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"num_of_days"] = @(number);
    parameters[@"q"] = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    parameters[@"format"] = @"json";
    parameters[@"key"] = WorldWeatherOnlineAPIKey;
    
    [self GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)]) {
            [self.delegate weatherHTTPClient:self didUpdateWithWeather:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)]) {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
    }];
}

@end
