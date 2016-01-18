//
//  PhotoVC.h
//  ParseApp
//
//  Created by Adam on 12/8/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "DejalActivityView.h"
#include "AppDelegate.h"

@interface PhotoVC : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (assign, nonatomic)     ASIHTTPRequest*             request;
@end
