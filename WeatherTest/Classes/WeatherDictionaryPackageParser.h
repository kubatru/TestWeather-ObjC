//
//  WeatherDictionaryPackageParser.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 11.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (weatherPackage)

// Make some cool methods for NSDictionary (getting parts of JASONs file)
-(NSDictionary *)currentCondition;
-(NSDictionary *)request;
-(NSArray *)upcomingWeather; // Must be an array of Dictionaries (5 days)

@end
