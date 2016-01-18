//
//  CommonClass.h
//  TempoMusic
//
//  Created by xiao on 2/11/14.
//  Copyright (c) 2014 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FrontMainVC.h"
#import "RearMainVC.h"
#import "ZUUIRevealController.h"

@interface CommonClass : NSObject
{
//    AudioListVC         *rearVC;
//    AudioPlayerVC       *frontVC;
}
//---------------------------------------------------------------------------------
@property (nonatomic, retain) FrontMainVC     *frontVC;
@property (nonatomic, retain) RearMainVC       *rearVC;
//---------------------------------------------------------------------------------
+ (CommonClass  *) shareInstance;

+ (ZUUIRevealController *) getRevealController;
- (FrontMainVC  *) getAudioPlayerVC;
- (RearMainVC  *) getAudioListVC;
@end
