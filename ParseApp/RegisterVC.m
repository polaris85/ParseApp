//
//  RegisterVC.m
//  ParseApp
//
//  Created by Adam on 11/11/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "RegisterVC.h"
#import "VerifyVC.h"
#import "AppDelegate.h"
#import "VerifyVC.h"

@interface RegisterVC ()

@property (nonatomic, retain) NSMutableArray *nameArr;
@property (assign, nonatomic) ASIHTTPRequest       *request;
@property (nonatomic, retain) IBOutlet UIImageView *seletedFlag;
@property (nonatomic, retain) IBOutlet UILabel     *lblStateName;
@property (nonatomic, retain) IBOutlet UILabel     *lblCode;
@property (nonatomic, retain) IBOutlet UITextField *txtInputNumber;

@end

@implementation RegisterVC

@synthesize seletedFlag, lblStateName;
@synthesize lblCode, txtInputNumber;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCountryCode];
}

-(void)dismissKeyboard {
    [txtInputNumber resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) setCountryCode
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef synchronize];
    
    [seletedFlag setImage:[UIImage imageNamed:[userDef objectForKey:@"reg_country_image"]]];
    lblStateName.text = [userDef objectForKey:@"reg_country_name"];
    lblCode.text = [userDef objectForKey:@"reg_country_code"];
}

- (IBAction)onSendVerificationCode:(id)sender {
    
    UIStoryboard  *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    VerifyVC *verifyVC = (VerifyVC *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"verifyVC"];
    [self.navigationController pushViewController:verifyVC animated:YES];
    
//    NSDictionary *params = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", self.lblCode.text, self.txtInputNumber.text] forKey:@"number"];
//    [PFCloud callFunctionInBackground:@"inviteWithTwilio" withParameters:params block:^(id object, NSError *error) {
//      
//            NSString *message = @"";
//            NSLog(@"%@", object);
//            if (!error) {
//        
//                message = @"Your SMS Verification has been sent!";
//        
//                NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
//                [def setObject:object forKey:@"verify_code"];
//                [def setObject:self.txtInputNumber.text forKey:@"phone_num"];
//                [def synchronize];
//        
//                NSLog(@"success:!!!");
//                UIStoryboard  *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//                VerifyVC *verifyVC = (VerifyVC *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"verifyVC"];
//                [self.navigationController pushViewController:verifyVC animated:YES];
//            }
//            else
//            {
//                NSLog(@"Uh oh, something went wrong :(");
//                NSLog(@"%@", error);
//            }
//    }];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
