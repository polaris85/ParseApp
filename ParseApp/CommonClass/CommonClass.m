//
//  CommonClass.m
//  TempoMusic
//
//  Created by xiao on 2/11/14.
//  Copyright (c) 2014 xiao. All rights reserved.
//

#import "CommonClass.h"
#import "AppDelegate.h"


@implementation CommonClass

static  CommonClass     *instance = nil;

@synthesize frontVC,rearVC;

+ (CommonClass *)shareInstance
{
    if (instance == nil) {
        instance = [[CommonClass alloc] init];
    }
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        NSLog(@"DataInstance init");
    }
    return self;
}
+ (ZUUIRevealController *)getRevealController
{
    AppDelegate  *appDelegate = [UIApplication sharedApplication].delegate;
    ZUUIRevealController    *revealVC = (ZUUIRevealController  *)appDelegate.viewController.parentViewController;
    
    return revealVC;
}
- (FrontMainVC  *) getAudioPlayerVC
{
    if (frontVC == nil)
    {
        UIStoryboard  *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        frontVC = (FrontMainVC *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"frontMainVC"];
    }
    return frontVC;
}
- (RearMainVC *)getAudioListVC
{
    if (rearVC == nil) {
        UIStoryboard  *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        rearVC = (RearMainVC *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"rearMainVC"];
    }
    return rearVC;
}
@end
