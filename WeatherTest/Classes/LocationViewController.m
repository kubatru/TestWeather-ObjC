//
//  LocationViewController.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "LocationViewController.h"
#import "Macros.h"
#import "WeatherDictionaryPackageParser.h"
#import "WeatherDictionaryParser.h"
#import "SearchLocationDictionaryPackageParser.h"
#import "SearchLocationDictionaryParser.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Change graphics
    [self applyAppearance];
    
    // Set NSUserDefaults
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Start the locationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    // Also NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription must be in plist (authorization by user request)
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // Pull to refresh
    [self pullToRefresh];
}

- (void)applyAppearance
{
    // programmatically added image for selected state and set the font
    
    // Set navigationBar's title font, color and size
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:18],NSFontAttributeName, UIColorWithRGB(333333),NSForegroundColorAttributeName, nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Line"]];
    
    // Footer Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 0, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    self.tableView.tableFooterView = separator;
    
    // Add the done button
    _doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    [_doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Rugular" size:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:_doneBtn];
}

- (void)close
{
    // Vertical transition backwards
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide tabBar after transition (From Today screen)
    self.tabBarController.tabBar.hidden = true;
    
    // Get the array of saved cities
    _cities = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"Cities"]];
    
    // Get the current location
    [self.locationManager startUpdatingLocation];
    
    // Alloc and initialize arrays
    _descriptionArray = [[NSMutableArray alloc] init];
    _temperatureCArray = [[NSMutableArray alloc] init];
    _temperatureFArray = [[NSMutableArray alloc] init];
    for(int i = 0; i<_cities.count; i++) {[_descriptionArray addObject: @"Loading ..."];}
    for(int i = 0; i<_cities.count; i++) {[_temperatureCArray addObject: @""];}
    for(int i = 0; i<_cities.count; i++) {[_temperatureFArray addObject: @""];}
}

-(void)viewDidAppear:(BOOL)animated
{
    // Looking for the notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAndTableView) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:AFNetworkingTaskDidCompleteNotification object:nil];
    [self reloadDataAndTableView];
    
    // Green arrow for the first cell
    current = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Current"]];
    
    // Final reload after one second
    finalCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
}

- (void)reloadTableView
{
    // Timer from animated custom delete cell action
    if (timer) {
        
        [timer invalidate];
    }
    // Final check timer
    if (finalCheckTimer) {
        
        [finalCheckTimer invalidate];
    }
    
    [self.tableView reloadData];
}

- (void)reloadDataAndTableView
{
    // UpdateWeather
    [self updateWeatherAtLocations];
    
    // After maximalization decide to use the green arrow image or set it to nil
    if ([CLLocationManager authorizationStatus] == 3 || [CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5) {
        // Green arrow for the first cell
        current = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Current"]];
    }
    
    if (!([CLLocationManager authorizationStatus] == 3 || [CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5)) {
        current.image = nil;
    }
    
    // Final reload after one second
    finalCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prepare selected location
    NSDictionary *currentRecord = [[NSDictionary alloc] init];
    selectedLocation = [[NSArray alloc] init];
    
    if ([CLLocationManager authorizationStatus] == 3 || [CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5) {
            
        currentRecord = [_cities objectAtIndex:indexPath.row];
    }
        
    else {
        currentRecord = [_cities objectAtIndex:indexPath.row + 1];
    }
    
    if (indexPath.row == 0 && ([CLLocationManager authorizationStatus] == 3 || [CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5)) {
            
        selectedLocation = @[@"Current"];
    }
    
    else {
            
        selectedLocation = @[currentRecord.latitude, currentRecord.longitude];
    }
    
    // Store it
    [defaults setObject:selectedLocation forKey:@"SelectedLocation"];
    
    // Vertical transition backwards
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Unselect a cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        if ([CLLocationManager authorizationStatus] == 3) {
            
            return [_descriptionArray count];
        }
        
        else {
            return [_descriptionArray count] - 1;
        }
    }
    
    else {
        
        if ([CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5) {
            
            return [_descriptionArray count];
        }
        
        else {
            return [_descriptionArray count] - 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Values
    NSString *CellIdentifier = @"ForecastCell";
    
    // Custom cell
    ForecastCell *cell = (ForecastCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // SWTableView setup
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:UIColorWithRGB(0xFF8847) icon:[UIImage imageNamed:@"DeleteIcon"]];
    cell.delegate = self;
    cell.rightUtilityButtons = rightUtilityButtons;
    
    // CONFIGURE A CELL
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-mid"]];
    separator.frame = CGRectMake(86, 0, 1000, 1); // Make it longer (1000) so swipe on iPhone 6 will be smooth
    [cell.contentView addSubview:separator];
    
    // Pass data to the cell
    NSDictionary *currentRecord = [[NSDictionary alloc] init];
    
    // First check if the location services are enabled (show or not the first cell)
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        if ([CLLocationManager authorizationStatus] == 3) {
            
            currentRecord = [_cities objectAtIndex:indexPath.row];
        }
        
        else {
            currentRecord = [_cities objectAtIndex:indexPath.row + 1];
        }
    }
    
    else {
        
        if ([CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5) {
            
            currentRecord = [_cities objectAtIndex:indexPath.row];
        }
        
        else {
            currentRecord = [_cities objectAtIndex:indexPath.row + 1];
        }
    }
    
    // Check if the first cell should be current location (location services on). First cell uses CLLocation record, other use city, name, lat, lng record.
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        if (indexPath.row == 0 && ([CLLocationManager authorizationStatus] == 3)) {
            
            cell.forecastDayLabel.text = placemark.locality;
            
            // Green arrow for the first cell
            // Get the width and height of a text in label a calculate the position
            if (cell.forecastDayLabel.intrinsicContentSize.width > cell.forecastDayLabel.frame.size.width) {
                current.frame = CGRectMake(cell.forecastDayLabel.frame.size.width + 2, cell.forecastDayLabel.intrinsicContentSize.height/3.3, 11, 11);
            }
            
            else {
                current.frame = CGRectMake(cell.forecastDayLabel.intrinsicContentSize.width + 2, cell.forecastDayLabel.intrinsicContentSize.height/3.3, 11, 11);
            }
        
            [cell.forecastDayLabel addSubview:current];
        }
        
        // City Name (Use the Forecast cell from Forecast tableView so the forecastDayLabel is actually cityNameLabel)
        else {
            cell.forecastDayLabel.text = currentRecord.cityName;
        }
    }
    
    else {
        
        if (indexPath.row == 0 && ([CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5)) {
            
            cell.forecastDayLabel.text = placemark.locality;
            
            // Green arrow for the first cell
            // Get the width and height of a text in label a calculate the position
            if (cell.forecastDayLabel.intrinsicContentSize.width > cell.forecastDayLabel.frame.size.width) {
                current.frame = CGRectMake(cell.forecastDayLabel.frame.size.width + 2, cell.forecastDayLabel.intrinsicContentSize.height/3.3, 11, 11);
            }
            
            else {
                current.frame = CGRectMake(cell.forecastDayLabel.intrinsicContentSize.width + 2, cell.forecastDayLabel.intrinsicContentSize.height/3.3, 11, 11);
            }
            
            [cell.forecastDayLabel addSubview:current];
        }
        
        // City Name (Use the Forecast cell from Forecast tableView so the forecastDayLabel is actually cityNameLabel)
        else {
            cell.forecastDayLabel.text = currentRecord.cityName;
        }
    }
    
    // Description
    cell.forecastDescriptionLabel.text = [NSString stringWithFormat:@"%@", _descriptionArray[indexPath.row]];
    // Temperature
    if ([[defaults objectForKey:@"TemperatureValue"] isEqualToString:@"Celsius"]) {
        
        cell.forecastTemperatureLabel.text = [NSString stringWithFormat:@"%@°C", _temperatureCArray[indexPath.row]];
    }
    
    else {
        
        cell.forecastTemperatureLabel.text = [NSString stringWithFormat:@"%@°F", _temperatureFArray[indexPath.row]];
    }
    
    // Weather Image
    UIImage *image = [UIImage imageNamed:@"Sun_Big"];
    
    if ([cell.forecastDescriptionLabel.text rangeOfString:@"cloudy" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        image = [UIImage imageNamed:@"Cloudy_Big"];
    }
    
    else if ([cell.forecastDescriptionLabel.text rangeOfString:@"overcast" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        image = [UIImage imageNamed:@"Cloudy_Big"];
    }
    
    else if ([cell.forecastDescriptionLabel.text rangeOfString:@"blow" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        image = [UIImage imageNamed:@"WInd_Big"];
    }
    
    else if ([cell.forecastDescriptionLabel.text rangeOfString:@"drizzle" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        image = [UIImage imageNamed:@"Lightning_Big"];
    }
    
    else if ([cell.forecastDescriptionLabel.text rangeOfString:@"shower" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        image = [UIImage imageNamed:@"Lightning_Big"];
    }
    
    else if ([cell.forecastDescriptionLabel.text rangeOfString:@"rain" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        image = [UIImage imageNamed:@"Lightning_Big"];
    }
    
    cell.forecastImageView.image = image;
    cell.forecastImageView.frame = CGRectMake(cell.forecastImageView.frame.origin.x, cell.forecastImageView.frame.origin.y, image.size.width, image.size.height);
    
    cell.forecastImageView.contentMode = UIViewContentModeScaleAspectFit; // This determines position of image
    cell.forecastImageView.clipsToBounds = YES;

    // Return complete cell
    return cell;
}

#pragma mark - Update weather
- (void)updateWeatherAtLocations
{
    // Send the location to weather client
    WeatherHTTPClient *client = [WeatherHTTPClient sharedWeatherHTTPClient];
    client.delegate = self;
    
    // Get the real number of visible rows (depends on location services)
    NSUInteger numberOfVisibleRows;
    if ([CLLocationManager authorizationStatus] == 3 || [CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5) {
        numberOfVisibleRows = _cities.count;
    }
    else {
        numberOfVisibleRows = _cities.count - 1;
    }
    
    // Update weather at locations. First cell from current location and other by lat and lng stored from searchBar
    for (int i = 0; i < numberOfVisibleRows; i++) {
        
        // Pass data to the cell
        NSDictionary *currentRecord = [[NSDictionary alloc] init];
        
        // First check if the location services are enabled (show or not the first cell)
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            if ([CLLocationManager authorizationStatus] == 3) {
                
                currentRecord = [_cities objectAtIndex:i];
            }
            
            else {
                currentRecord = [_cities objectAtIndex:i + 1];
            }
        }
        
        else {
            
            if ([CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5) {
                
                currentRecord = [_cities objectAtIndex:i];
            }
            
            else {
                currentRecord = [_cities objectAtIndex:i + 1];
            }
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            if (i == 0 && ([CLLocationManager authorizationStatus] == 3)) {
                
                [client updateWeatherAtLocation:placemark.location withIndex:i];
            }
            
            else {
                
                CLLocation *cityLocation = [[CLLocation alloc] initWithLatitude:[currentRecord.latitude doubleValue] longitude:[currentRecord.longitude doubleValue]];
                [client updateWeatherAtLocation:cityLocation withIndex:i];
            }
        }
        
        else {
            
            if (i == 0 && ([CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5)) {
                
                [client updateWeatherAtLocation:placemark.location withIndex:i];
            }
            
            else {
                
                CLLocation *cityLocation = [[CLLocation alloc] initWithLatitude:[currentRecord.latitude doubleValue] longitude:[currentRecord.longitude doubleValue]];
                [client updateWeatherAtLocation:cityLocation withIndex:i];
            }
        }
    }
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Last object contains the most recent location (lat and lon extends the base URL)
    CLLocation *newLocation = [locations lastObject];
    
    // If the location is more than 10 minutes old, ignore it
    if([newLocation.timestamp timeIntervalSinceNow] > 600) {
        
        return;
    }
    
    // There could be a better code for getting more accurate data (not stop the manager after the first update, but its more battery friendly)
    [self.locationManager stopUpdatingLocation];
    
    // Coordinations back to the name of my city and country
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: _locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         placemark = [placemarks objectAtIndex:0];
         
         // Reload cell
         // [self.tableView reloadData];
         if (current.image != nil) {
             [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         }
     }];
}

#pragma mark - TestWeatherHTTPClient delegate

- (void)weatherHTTPClient:(WeatherHTTPClient *)client didUpdateWithWeather:(id)weather withIndex:(NSUInteger)index
{
    // Got a weather JSON file? Nice, but we need to acces data elements easily so we call custom methods on NSDictionaries
    NSDictionary *weatherDictionary = weather;
    
    // Could happen that JSON is not complete (uncomplete record in geoNames for some city name = no weather = nil record)
    if (weatherDictionary.currentCondition.weatherDescription == nil) {
        [_descriptionArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Unknown"]];
    }
    else {
        [_descriptionArray replaceObjectAtIndex:index withObject:weatherDictionary.currentCondition.weatherDescription];
    }
    
    if (weatherDictionary.currentCondition.tempC == nil) {
        [_temperatureCArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"-"]];
    }
    else {
        [_temperatureCArray replaceObjectAtIndex:index withObject:weatherDictionary.currentCondition.tempC];
    }
    
    if (weatherDictionary.currentCondition.tempF == nil) {
        [_temperatureFArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"-"]];
    }
    else {
        [_temperatureFArray replaceObjectAtIndex:index withObject:weatherDictionary.currentCondition.tempF];
    }
    
    // Reload a cell
    // [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

#pragma mark - SWTableViewCell delegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Remove data from arrays
    [_descriptionArray removeObjectAtIndex:indexPath.row];
    [_temperatureCArray removeObjectAtIndex:indexPath.row];
    [_temperatureFArray removeObjectAtIndex:indexPath.row];
    [_cities removeObjectAtIndex:indexPath.row];
    [defaults setObject:_cities forKey:@"Cities"];
    
    // Animate
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    // Reload after animation (fixed time)
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell;
{
    return true;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state;
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // Do NOT let user to delete the first cell
    if (indexPath.row == 0 && ([CLLocationManager authorizationStatus] == 3 || [CLLocationManager authorizationStatus] == 4 || [CLLocationManager authorizationStatus] == 5)) {
        return UITableViewCellEditingStyleNone;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - Pull to Refresh control

- (void)pullToRefresh
{
    refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
    refreshControl.tintColor = UIColorWithRGB(0x1FA22F);
    refreshControl.alpha = 0.5f;
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTableView
{
    // UpdateWeather
    [self updateWeatherAtLocations];
    [refreshControl endRefreshing];
}

@end
