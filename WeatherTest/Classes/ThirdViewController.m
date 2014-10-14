//
//  ThirdViewController.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 09.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "ThirdViewController.h"
#import "Macros.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    
    // Change graphics
    [self applyAppearance];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)applyAppearance
{
    // programmatically added image for selected state and set the font
    // [UITabBarItem alloc].selectedImage = [UIImage imageNamed:@"SettingsSelected"];
    [self.tabBarController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:10], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // Title in the NavigationBar
    self.title = @"Settings";
    
    // Set navigationBar's title font, color and size
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:18],NSFontAttributeName, UIColorWithRGB(333333),NSForegroundColorAttributeName, nil]];
    
    // NavigationBar
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Line"];
    // setBackgroundImage must be defined to use to the image shadowImage method
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

// Section text
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Text
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 11, 320, 50);
    myLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
    myLabel.textColor = UIColorWithRGB(0x2f91ff); // Hexadecimal starts with 0x
    myLabel.text = @"GENERAL";
    
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 50, 320, 1);
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    [headerView addSubview:separator];
    // Header background so the tableView can be dynamic and it will looks still great
    headerView.backgroundColor = [UIColor whiteColor];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 0, 320, 1);
    
    UIView *footerView = [[UIView alloc] init];
    [footerView addSubview:separator];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Values
    NSString *CellIdentifier = @"Cell";
    _cellsTitle = [NSArray arrayWithObjects:@"Unit of lenght",@"Unit of temperature",nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *distanceValue = [defaults objectForKey:@"DistanceValue"];
    NSString *temperatureValue = [defaults objectForKey:@"TemperatureValue"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Pick up a cell style
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    // CONFIGURE A CELL
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-mid"]];
    separator.frame = CGRectMake(15, 0, 320, 1);
    [cell.contentView addSubview:separator];
    
    // Size, Color, Font
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17];
    cell.textLabel.textColor = UIColorWithRGB(333333); // Hexadecimal starts with 0x
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17];
    cell.detailTextLabel.textColor = UIColorWithRGB(0x2f91ff); // Hexadecimal starts with 0x
    
    // Text
    cell.textLabel.text = [_cellsTitle objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = distanceValue;
    }
    
    else {
        cell.detailTextLabel.text = temperatureValue;
    }
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Unselect a cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Change the settings
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Change the defaults
    if ([cell.detailTextLabel.text isEqual: @"Meters"]) {
        cell.detailTextLabel.text = @"Feet";
        [defaults setObject:cell.detailTextLabel.text forKey:@"DistanceValue"];
    }
    
    else if ([cell.detailTextLabel.text isEqual: @"Feet"]) {
        cell.detailTextLabel.text = @"Meters";
        [defaults setObject:cell.detailTextLabel.text forKey:@"DistanceValue"];
    }
    
    else if ([cell.detailTextLabel.text isEqual: @"Celsius"]){
        cell.detailTextLabel.text = @"Fahrenheit";
        [defaults setObject:cell.detailTextLabel.text forKey:@"TemperatureValue"];
    }
    
    else if ([cell.detailTextLabel.text isEqual: @"Fahrenheit"]){
        cell.detailTextLabel.text = @"Celsius";
        [defaults setObject:cell.detailTextLabel.text forKey:@"TemperatureValue"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
