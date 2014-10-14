//
//  WeatherDictionaryParser.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 11.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (weather)

// Make some cool methods for NSDictionary (getting parts of a part of a JASONs file)
- (NSNumber *)cloudCover;
- (NSNumber *)humidity; // Vlhkost [%]
- (NSDate *)observationTime;
- (NSNumber *)precipMM; // Srážky [mm]
- (NSNumber *)pressure; // Tlak [hPa]
- (NSNumber *)tempC; // Teplota
- (NSNumber *)tempF; // Teplota
- (NSNumber *)visibility;
- (NSNumber *)weatherCode;
- (NSString *)windDir16Point; // Směr větru
- (NSNumber *)windDirDegree;
- (NSNumber *)windSpeedKmph; // Rychlost větru
- (NSNumber *)windSpeedMiles; // Rychlost větru
- (NSString *)weatherDescription; // Stav počasí
- (NSString *)weatherIconURL;
- (NSString *)date;
- (NSNumber *)tempMaxC;
- (NSNumber *)tempMaxF;
- (NSNumber *)tempMinC;
- (NSNumber *)tempMinF;

@end
