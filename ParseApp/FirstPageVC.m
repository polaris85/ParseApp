//
//  FirstPageVC.m
//  ParseApp
//
//  Created by Adam on 11/11/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "FirstPageVC.h"
#import "RegisterVC.h"

@interface FirstPageVC ()
@end

@implementation FirstPageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAccept:(id)sender
{
    [self onRegister];
}

- (IBAction)onDecline:(id)sender
{
}

- (void)onRegister
{
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef synchronize];
    
    NSString* strUrl = [[GlobalVariable sharedInstance].APIHOST stringByAppendingString:@"RegisterUser"] ;
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]] ;
    
    [_request setRequestMethod:@"POST"] ;
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    NSString *sendString = [NSString stringWithFormat:@"%@",[GlobalVariable sharedInstance].Auth_Token];
    
    NSMutableDictionary* dic_post = [NSMutableDictionary dictionary] ;
    [dic_post setObject:sendString forKey:@"guid"] ;
    NSMutableData*  postData    = [NSJSONSerialization dataWithJSONObject:dic_post
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
    [_request setPostBody:postData] ;
    [_request setCompletionBlock:^{
        
        NSString* res_message = @"";
        [DejalBezelActivityView removeView];
        NSString* responseString = [_request responseString] ;
        if ( responseString != nil ) {
            
            [GlobalVariable sharedInstance].f_Success_SignUp = YES ;
            [GlobalVariable sharedInstance].userId = [NSString stringWithFormat:@"%d",[self getNumber:responseString]];
            
            res_message = @"Registration successful!" ;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"uSnap"
                                                            message:res_message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show] ;
        }
    }] ;
    
    [_request setFailedBlock:^{
        
        [DejalBezelActivityView removeView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"uSnap"
                                                        message:@"There are some problems in internet connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show] ;
    }] ;
    
    [DejalBezelActivityView activityViewForView:self.view].showNetworkActivityIndicator = YES;
    [_request startAsynchronous] ;
}

- (int) getNumber: (NSString*)mainString
{
    // Intermediate
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:mainString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    return [numberString intValue];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app onGoHome];
}

@end
