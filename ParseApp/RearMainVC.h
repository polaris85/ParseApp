//
//  RearMainVC.h
//  MCM
//
//  Created by Adam on 2/13/14.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RearMainVCDelegate <NSObject>

@optional
- (void) showHome;
- (void) showPhotoUpload;
@end

@interface RearMainVC : UIViewController
@property (nonatomic, retain)id<RearMainVCDelegate> delegate;
@end
