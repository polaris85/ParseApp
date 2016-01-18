//
//  FrontMainVC.m
//  MCM
//
//  Created by Adam on 2/13/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "FrontMainVC.h"
#import "AppDelegate.h"
#import "PhotoVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>

static NSString* kApiKey = @"<YOUR API KEY>";

// Enter either your API secret or a callback URL (as described in documentation):
static NSString* kApiSecret = nil; // @"<YOUR SECRET KEY>";
static NSString* kGetSessionProxy = nil; // @"<YOUR SESSION CALLBACK)>";

@interface FrontMainVC ()<CLLocationManagerDelegate>

@property (assign, nonatomic) ASIHTTPRequest       *request;
@property (nonatomic, retain) IBOutlet MKMapView   *mapKit;
@property (nonatomic, retain) NSMutableArray       *arrData;
@property (nonatomic, retain) NSString             *latitude;
@property (nonatomic, retain) NSString             *longitude;
@property (nonatomic, retain) CLLocationManager    *locationManager;

@end

@implementation FrontMainVC
@synthesize mapKit, arrData;
@synthesize  latitude, longitude, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    mapKit.delegate = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;

    
    //In ViewDidLoad
//    if(IS_OS_8_OR_LATER) {
//        [locationManager requestAlwaysAuthorization];
//    }
    
    [self.locationManager startUpdatingLocation];
    [locationManager startUpdatingLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkIn) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation * currentLocation = [locations lastObject];
    
    latitude = [[NSString alloc]initWithFormat:@"%@",[[NSNumber numberWithFloat:currentLocation.coordinate.latitude] stringValue]];
    
    longitude = [[NSString alloc]initWithFormat:@"%@",[[NSNumber numberWithFloat:currentLocation.coordinate.longitude] stringValue]];
    
}

- (void) checkIn{
    
    NSString* strUrl = [[GlobalVariable sharedInstance].APIHOST stringByAppendingString:@"CheckIn"] ;
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]] ;
    
    [_request setRequestMethod:@"POST"] ;
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];

    NSMutableDictionary* dic_post = [NSMutableDictionary dictionary] ;
    [dic_post setObject:[GlobalVariable sharedInstance].userId forKey:@"guid"] ;
    
    latitude = @"41.25";
    longitude = @"121.25";
    
    NSLog(@"this is lat:%@", latitude);
    NSLog(@"this is long:%@", longitude);
    
    [dic_post setObject:latitude forKey:@"latitude"] ;
    [dic_post setObject:longitude forKey:@"longitude"] ;
    NSMutableData*  postData    = [NSJSONSerialization dataWithJSONObject:dic_post
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
    
    [_request setPostBody:postData] ;
    [_request setCompletionBlock:^{
    
        [DejalBezelActivityView removeView];
        NSString* responseString = [_request responseString] ;
        if ( responseString != nil ) NSLog(@"check in success");
        [self onGetAllPhotos];
        
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
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Check In..."];
    [_request startAsynchronous] ;
}

- (void)onShowAllUser
{
    
    NSMutableArray *annotationArray = [NSMutableArray array];
    
    for (int i = 0; i < [arrData count]; i ++) {
        
        NSMutableDictionary * productDic = [[NSMutableDictionary alloc] init];
        productDic = [arrData objectAtIndex:i];
        
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.productName = [productDic objectForKey:@"Gid"];
        annotation.tag = i;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude  = [[productDic objectForKey:@"Latitude"] doubleValue];
        coordinate.longitude = [[productDic objectForKey:@"Longitude"] doubleValue];
        annotation.coordinate = coordinate;
        
        [annotationArray addObject:annotation];
    }
    
    if ([annotationArray count] != 0) {
        [mapKit addAnnotations:annotationArray];
        
        MKCoordinateRegion region;
        region.center.latitude = [[[arrData objectAtIndex:[arrData count]-1] objectForKey:@"Latitude"] doubleValue];
        region.center.longitude = [[[arrData objectAtIndex:[arrData count]-1] objectForKey:@"Longitude"] doubleValue];
        region.span.latitudeDelta = 0.5;
        region.span.longitudeDelta = 0.5;
        [mapKit setRegion:region animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapKit.userLocation)
    {
        return nil;
    }
    MapAnnotation *mapAnnotation = (MapAnnotation*)annotation;
    MKAnnotationView *annotationView  = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"EventList"];
    
    annotationView.image = [UIImage imageNamed:@"map_pin.png"];
    annotationView.annotation = mapAnnotation;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MapAnnotation *mapAnnotation = (MapAnnotation*)view.annotation;
    NSLog(@"this is click Value: %d", mapAnnotation.tag);
    
    NSString* strUrl = [[GlobalVariable sharedInstance].APIHOST stringByAppendingString:@"SendRequest"] ;
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]] ;
    
    [_request setRequestMethod:@"POST"] ;
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSMutableDictionary* dic_post = [NSMutableDictionary dictionary] ;
    [dic_post setObject:[GlobalVariable sharedInstance].userId forKey:@"senderUserID"] ;
    [dic_post setObject:[GlobalVariable sharedInstance].userId forKey:@"receiverUserID"] ;
    NSMutableData*  postData    = [NSJSONSerialization dataWithJSONObject:dic_post
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
    [_request setPostBody:postData] ;
    [_request setCompletionBlock:^{
        
        [DejalBezelActivityView removeView];
        NSString* responseString = [_request responseString] ;
        if ( responseString != nil ){
            
            NSCharacterSet *checkString = [NSCharacterSet characterSetWithCharactersInString:@"SendRequestResult"];
            NSCharacterSet *invalidChars = [checkString invertedSet];
            NSRange searchRange = NSMakeRange(0, responseString.length); // search the whole string
            NSRange foundRange = [responseString rangeOfCharacterFromSet:invalidChars
                                                         options:0 // look in docs for other possible values
                                                           range:searchRange];
            if (foundRange.location != NSNotFound) {
                
                NSArray *tempArrary = [responseString componentsSeparatedByString:@":"];
                NSString *tempString = [tempArrary objectAtIndex:1];
                [GlobalVariable sharedInstance].SendRequestResultString = [tempString stringByReplacingOccurrencesOfString:@"}" withString:@""];
                NSLog(@"this is test: %@",  [GlobalVariable sharedInstance].SendRequestResultString);
            }
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
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending Request..."];
    [_request startAsynchronous] ;
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (void)onGetAllPhotos
{
    NSString* strUrl = [[GlobalVariable sharedInstance].APIHOST stringByAppendingString:@"GetListOfUsersByLatLong"] ;
    
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]] ;
    [_request setRequestMethod:@"POST"] ;
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSMutableDictionary* dic_post = [NSMutableDictionary dictionary] ;
    [dic_post setObject:[NSNumber numberWithDouble:-90] forKey:@"LeftTopLatitude"] ;
    [dic_post setObject:[NSNumber numberWithDouble:-180] forKey:@"LeftTopLongitude"] ;
    [dic_post setObject:[NSNumber numberWithDouble:90] forKey:@"RightButtomLatitude"] ;
    [dic_post setObject:[NSNumber numberWithDouble:180] forKey:@"RightButtomLongitude"] ;
    NSMutableData*  postData    = [NSJSONSerialization dataWithJSONObject:dic_post
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
    
    [_request setPostBody:postData];
    [_request setCompletionBlock:^{
        
        [DejalBezelActivityView removeView];
        NSString* responseString = [_request responseString] ;
        if ( responseString != nil ) {
            
            NSMutableDictionary* json_response = [NSJSONSerialization JSONObjectWithData: [responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options: NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                                                   error: nil] ;
            arrData = [NSMutableArray array];
            arrData = [json_response objectForKey:@"GetListOfUsersByLatLongResult"];
            [self onShowAllUser];
            [GlobalVariable sharedInstance].f_Success_SignUp = YES ;
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

- (IBAction)popMenuShow:(id)sender{

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.viewController revealToggle:self.navigationController.parentViewController];
}

- (void) showPhotoUpload
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    PhotoVC*dashBoardVC = (PhotoVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"photoVC"];
    [self.navigationController pushViewController:dashBoardVC animated:NO];
}

- (void) showHome
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    FrontMainVC*dashBoardVC = (FrontMainVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"frontMainVC"];
    [self.navigationController pushViewController:dashBoardVC animated:NO];
}

@end
