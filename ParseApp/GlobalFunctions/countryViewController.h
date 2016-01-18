//
//  countryViewController.h
//  mapslap
//
//  Created by pwc on 10/31/14.
//  Copyright (c) 2014 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface countryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray * aryCountryName;
    NSMutableArray * aryCountryCode;
    NSMutableArray * aryCountryImage;
}

@property (nonatomic, retain) IBOutlet UITableView * tblCountryView;

-(IBAction)back_func:(id)sender;

@end
