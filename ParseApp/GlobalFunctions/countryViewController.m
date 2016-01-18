//
//  countryViewController.m
//  mapslap
//
//  Created by pwc on 10/31/14.
//  Copyright (c) 2014 zhang. All rights reserved.
//

#import "countryViewController.h"

@interface countryViewController ()

@end

@implementation countryViewController

@synthesize tblCountryView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    aryCountryName = [[NSMutableArray alloc] init];
    aryCountryCode = [[NSMutableArray alloc] init];
    aryCountryImage = [[NSMutableArray alloc] init];
    
    NSMutableArray * contentArray = [[NSMutableArray alloc] init];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"CountryList-english" ofType:@"plist"];
    contentArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    int cnt = [contentArray count];
    
    for (int i = cnt-1 ; i >= 0 ; i --){
        NSMutableDictionary * myDic = [contentArray objectAtIndex:i];
        NSString * strCountryName = [myDic objectForKey:@"CountryName"];
        NSString * strPreCode = [myDic objectForKey:@"CountryCode"];
        NSString * strImage = [myDic objectForKey:@"CountryFlag"];
        
        [aryCountryName addObject:strCountryName];
        [aryCountryCode addObject:strPreCode];
        [aryCountryImage addObject:strImage];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(IBAction)back_func:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryCountryName count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView.layer.borderWidth = 2.0;
    //tableView.layer.borderColor = [UIColor redColor].CGColor;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell ;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //cell.contentView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView * cellCountryImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 40, 30)];
    [cellCountryImage setTag:100];
    [cellCountryImage setImage:[UIImage imageNamed:[aryCountryImage objectAtIndex:indexPath.row]]];
    [cell.contentView addSubview:cellCountryImage];
    
    UILabel * cellCountryName = [[UILabel alloc] initWithFrame:CGRectMake(57, 10, 192, 30)];
    [cellCountryName setBackgroundColor:[UIColor clearColor]];
    [cellCountryName setTextColor:[UIColor blackColor]];
    [cellCountryName setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    cellCountryName.adjustsFontSizeToFitWidth = NO ;
    cellCountryName.numberOfLines = 0;
    [cellCountryName setText:[aryCountryName objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:cellCountryName];
    
    UILabel * cellCountryCode = [[UILabel alloc] initWithFrame:CGRectMake(257, 10, 58, 30)];
    [cellCountryCode setBackgroundColor:[UIColor clearColor]];
    [cellCountryCode setTextColor:[UIColor blackColor]];
    [cellCountryCode setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    cellCountryCode.adjustsFontSizeToFitWidth = NO ;
    cellCountryCode.numberOfLines = 0;
    [cellCountryCode setText:[aryCountryCode objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:cellCountryCode];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef synchronize];
    
    [userDef setObject:aryCountryName[indexPath.row] forKey:@"reg_country_name"];
    [userDef setObject:aryCountryCode[indexPath.row] forKey:@"reg_country_code"];
    [userDef setObject:aryCountryImage[indexPath.row] forKey:@"reg_country_image"];
    
    [userDef setObject:@"flag" forKey:@"reg_flag"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma status bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
