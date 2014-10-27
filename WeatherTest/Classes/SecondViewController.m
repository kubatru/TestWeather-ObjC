//
//  SecondViewController.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 09.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "SecondViewController.h"
#import "Macros.h"
#import "WeatherDictionaryPackageParser.h"
#import "WeatherDictionaryParser.h"
#import "ForecastCell.h"
#import "Constants.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
- (void)viewDidAppear:(BOOL)animated {
    
    // Title in the NavigationBar (Not the same as in tabbar, in TabBar is still "Forecast")
    self.navigationItem.title = [FirstViewController globalCityNameString];
    
    // Reload data (eg. user changed the settings)
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    
    // Set NSUserDefaults
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Change graphics
    [self applyAppearance];
    
    // Swipe gesture
    [self swipeGesture];
    
    // Notify me if the JSON is ready
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:AFNetworkingTaskDidCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBar) name:kCoordinatesWereDecodedToCityNameNotification object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)reloadBar
{
    self.navigationItem.title = [FirstViewController globalCityNameString];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)applyAppearance
{
    // programmatically added image for selected state and set the font
    // [UITabBarItem alloc].selectedImage = [UIImage imageNamed:@"ForecastSelected"];
    [self.tabBarController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:10], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // Set navigationBar's title font, color and size
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:18],NSFontAttributeName, UIColorWithRGB(333333),NSForegroundColorAttributeName, nil]];
    
    // NavigationBar
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Line"];
    // setBackgroundImage must be defined to use to the image shadowImage method
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    // Set already in storyboard, but better let it here and not forget again
    // [self.navigationController.navigationBar setTranslucent:false];
    
    // Footer Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 0, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    self.tableView.tableFooterView = separator;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [FirstViewController forecastDaysArray].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We need a dynamic height determined by tableView height and the number of cells (To follow my paradigm and store the iP5 storyboard size with defined tableView height, i counted the base height like statusBar + navigatinBar + tabBar)
    return ([UIScreen mainScreen].bounds.size.height - (20 + self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height))/[FirstViewController forecastDaysArray].count;
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

    // CONFIGURE A CELL
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-mid"]];
    separator.frame = CGRectMake(86, 0, 320, 1);
    [cell.contentView addSubview:separator];
    
    // Pass data to the cell
    // Weekday
    cell.forecastDayLabel.text = [FirstViewController forecastDaysArray][indexPath.row];
    // Description
    cell.forecastDescriptionLabel.text = [FirstViewController forecastDescriptionsArray][indexPath.row];
    // Temperature
    if ([[defaults objectForKey:@"TemperatureValue"] isEqualToString:@"Celsius"]) {
        
        cell.forecastTemperatureLabel.text = [NSString stringWithFormat:@"%@°",[FirstViewController forecastAverageCArray][indexPath.row]];
    }
    
    else {
        
        cell.forecastTemperatureLabel.text = [NSString stringWithFormat:@"%@°",[FirstViewController forecastAverageFArray][indexPath.row]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gestures

- (void)swipeGesture {
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
}

- (void)swipeRight {
    [self.tabBarController setSelectedIndex:([self.tabBarController selectedIndex] - 1)];
}

- (void)swipeLeft {
    [self.tabBarController setSelectedIndex:([self.tabBarController selectedIndex] + 1)];
}

@end
