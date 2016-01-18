//
//  PhotoVC.m
//  ParseApp
//
//  Created by Adam on 12/8/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "PhotoVC.h"
#import "GlobalVariable.h"

@interface PhotoVC ()
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@end

@implementation PhotoVC
@synthesize imageView;

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

- (IBAction)onPhoto:(id)sender {
    
    UIActionSheet* popupQuery = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take New Picture", @"Choose From Library", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.allowsEditing=TRUE;
        [self presentViewController:picker animated:YES completion:nil] ;
        
    } else if (buttonIndex == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=TRUE;
            [self presentViewController:picker animated:YES completion:nil] ;
        }
        else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can not find Camera Device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
            [alertView show];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil] ;
    imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

- (IBAction)onPhotoUpload:(id)sender
{
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[GlobalVariable sharedInstance].APIHOST stringByAppendingString:@"UploadPhoto/aaa.png"]]] ;
    [request setRequestMethod:@"POST"] ;
    [request addRequestHeader:@"Content-Type" value:@"raw"];
    
    NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.1) ;
    [request appendPostData:imageData];
    [request setCompletionBlock:^{
        
        [DejalBezelActivityView removeView];
        NSString* responseString = [request responseString] ;
        NSCharacterSet *checkString = [NSCharacterSet characterSetWithCharactersInString:@"Images"];
        NSCharacterSet *invalidChars = [checkString invertedSet];
        NSRange searchRange = NSMakeRange(0, responseString.length); // search the whole string
        NSRange foundRange = [responseString rangeOfCharacterFromSet:invalidChars
                                                             options:0 // look in docs for other possible values
                                                               range:searchRange];
        if (foundRange.location != NSNotFound) {
        
            responseString = [responseString substringFromIndex:1];
            responseString = [responseString substringToIndex:responseString.length-1];
            
            [GlobalVariable sharedInstance].photoUrl = responseString;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Photo uploaded successfully!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] ;
            [alert show] ;
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:responseString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] ;
            [alert show] ;
        }
    }] ;
    
    [request setFailedBlock:^{
        [DejalBezelActivityView removeView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"There are some problems in internet connection."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show] ;
    }] ;
    
    [DejalBezelActivityView activityViewForView:self.view].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Uploading New Photo..."];
    [request startAsynchronous] ;
}

- (IBAction)onSendPhoto:(id)sender
{
    if ([[GlobalVariable sharedInstance].photoUrl isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"uSnap"
                                                        message:@"You need to upload photo now."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show] ;
        return;
    }
    
    NSString* strUrl = [[GlobalVariable sharedInstance].APIHOST stringByAppendingString:@"SendResponse"] ;
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]] ;
    
    [_request setRequestMethod:@"POST"] ;
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSLog(@"this is test: %@",  [GlobalVariable sharedInstance].userId);
    NSLog(@"this is test: %@",  [GlobalVariable sharedInstance].photoUrl);
    
    NSMutableDictionary* dic_post = [NSMutableDictionary dictionary] ;
    [dic_post setObject:[GlobalVariable sharedInstance].userId forKey:@"userID"] ;
    [dic_post setObject:[GlobalVariable sharedInstance].SendRequestResultString forKey:@"requestID"] ;
    [dic_post setObject:[GlobalVariable sharedInstance].photoUrl forKey:@"photoUrl"];
    NSMutableData*  postData    = [NSJSONSerialization dataWithJSONObject:dic_post
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
    [_request setPostBody:postData] ;
    [_request setCompletionBlock:^{
        
        [DejalBezelActivityView removeView];
        NSString* responseString = [_request responseString] ;
        if ( responseString != nil ) NSLog(@"check in success");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"uSnap"
                                                        message:@"Photo sent successfully."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show] ;
        
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
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending Request..."];
    [_request startAsynchronous] ;
}

- (IBAction)onOpenRear:(id)sender
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.viewController revealToggle:self.navigationController.parentViewController];
}

@end
