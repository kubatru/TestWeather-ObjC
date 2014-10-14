//
//  WeatherDictionaryPackageParser.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 11.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "WeatherDictionaryPackageParser.h"

@implementation NSDictionary (weatherPackage)

- (NSDictionary *)currentCondition
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"current_condition"];
    return ar[0];
}

- (NSDictionary *)request
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"request"];
    return ar[0];
}

- (NSArray *)upcomingWeather
{
    NSDictionary *dict = self[@"data"];
    return dict[@"weather"];
}

@end
