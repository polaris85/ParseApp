//
//  FrontMainVC.h
//  MCM
//
//  Created by Adam on 2/13/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RearMainVC.h"
#import "MapAnnotation.h"
#import "ASIFormDataRequest.h"
#import "DejalActivityView.h"
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface FrontMainVC : UIViewController<RearMainVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,MKMapViewDelegate>

- (IBAction)popMenuShow:(id)sender;

@end
