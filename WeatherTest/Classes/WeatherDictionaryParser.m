//
//  WeatherDictionaryParser.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 11.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "WeatherDictionaryParser.h"

@implementation NSDictionary (weather)

- (NSNumber *)cloudCover
{
    NSString *cc = self[@"cloudcover"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)humidity
{
    NSString *cc = self[@"humidity"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSDate *)observationTime
{
    //    NSString *cc = [self currentWeather][@"observation_time"];
    NSDate *n = [NSDate date]; // parse instead "09:07 PM";
    return n;
}

- (NSNumber *)precipMM
{
    NSString *cc = self[@"precipMM"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)pressure
{
    NSString *cc = self[@"pressure"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempC
{
    NSString *cc = self[@"temp_C"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempF
{
    NSString *cc = self[@"temp_F"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)visibility
{
    NSString *cc = self[@"visibility"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)weatherCode
{
    NSString *cc = self[@"weatherCode"];
    NSNumber *n = @([cc intValue]);
    return n;
}

-(NSString *)windDir16Point
{
    return self[@"winddir16Point"];
}

- (NSNumber *)windDirDegree
{
    NSString *cc = self[@"winddirDegree"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)windSpeedKmph
{
    NSString *cc = self[@"windspeedKmph"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)windSpeedMiles
{
    NSString *cc = self[@"windspeedMiles"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)weatherDescription
{
    NSArray *ar = self[@"weatherDesc"];
    NSDictionary *dict = ar[0];
    return dict[@"value"];
}

- (NSString *)weatherIconURL
{
    NSArray *ar = self[@"weatherIconUrl"];
    NSDictionary *dict = ar[0];
    return dict[@"value"];
}

- (NSString *)date
{
    NSString *dateStr = self[@"date"];
    return dateStr;
}

- (NSNumber *)tempMaxC
{
    NSString *cc = self[@"tempMaxC"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempMaxF
{
    NSString *cc = self[@"tempMaxF"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempMinC
{
    NSString *cc = self[@"tempMinC"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempMinF
{
    NSString *cc = self[@"tempMinF"];
    NSNumber *n = @([cc intValue]);
    return n;
}

@end
