//
//  GlobalVariable.h
//  TCM
//
//  Created by zao928 on 12/27/13.
//  Copyright (c) 2013 com.appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@interface GlobalVariable : NSObject

- (BOOL)checkFollow:(NSString*)user_id ;
- (void)sendViewToBelow:(UIView*)sourceView target:(UIView*)targetView offset:(CGFloat)offset ;

- (NSInteger)daysUntilToday:(NSDate*)fromDateTime ;
- (float)getCorrectHeightFitText:(UILabel*)label withString:(NSString*)string ;
- (void) setShadow:(UIView*)view ;

- (BOOL) isNotNull:(id)text ;
- (NSString*) getCorrectText:(NSString*)text ;

- (void)setBackgroundImage:(UIView*)view withImage:(NSString*)imgName ;
- (UIColor*) colorWithHexString:(NSString*)hex ;
- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
- (UIImage *)imageWitAdamze:(UIImage *)image witAdamze:(CGSize)_size ;
- (UIImage *)imageWithColor:(UIColor *)color ;
- (UIImage *)imageByApplyingAlpha:(UIImage*) image withAlpha:(CGFloat) alpha ;
- (void) addBottomLineToLabel:(UILabel*)label ;
- (void) setHeight:(UIView*)view height:(float)height ;
- (void) setWidth:(UIView*)view height:(float)width ;
- (void) setYpos:(UIView*)view height:(float)y ;
- (void) setXpos:(UIView*)view height:(float)x ;
- (double) getNumberFromString:(NSString*)originalString ;
- (NSDate*) getCurrentDateWithTimeZone ;
- (NSInteger) getCurrentDateWithTimeZoneInterval ;
- (CGSize) currentSize ;
- (NSInteger)getKeyBoardHeight:(NSNotification *)notification ;
- (NSString *) base64StringFromData: (NSData *)data length: (int)length ;
- (NSData *) base64DataFromString:(NSString *)string;
- (UIImage *)scaleAndRotateImage:(UIImage *)image ;
- (BOOL) isValidTextNumber:(NSString*)string ;

@property (strong, nonatomic) NSUserDefaults* userDefaults ;
@property (strong, nonatomic) NSString* APIHOST ;
@property (strong, nonatomic) NSString* Auth_Token ;
@property (strong, nonatomic) NSString* facebook_AccessToken ;

@property (strong, nonatomic) NSString* firstName ;
@property (strong, nonatomic) NSString* lastName ;
@property (strong, nonatomic) NSString* gender ;
@property (strong, nonatomic) NSString* userId ;

@property (strong, nonatomic) NSString* user_ProfileImageSmallUrl ;
@property (strong, nonatomic) NSString* user_ProfileImageUrl ;
@property (strong, nonatomic) NSString* userName ;
@property (strong, nonatomic) NSString* photoUrl;
@property (strong, nonatomic) NSString* SendRequestResultString;

@property (nonatomic)         int       n_NotificationCount ;
@property (retain, nonatomic) NSMutableDictionary* item_Location ;
@property (strong, nonatomic) NSString* userLocation ;
@property (strong, nonatomic) NSMutableArray* userFollowing ;

@property (retain, nonatomic) UIImage*  img_profilePhoto ;

@property (nonatomic)         BOOL      f_Success_SignUp ;
@property (nonatomic)         BOOL      f_SignOut ;
@property (nonatomic)         BOOL      f_SigninFacebook ;
@property (nonatomic)         BOOL      f_SigninTwitter ;

@property (nonatomic)         BOOL      f_FeedComplete ;
@property (nonatomic)         BOOL      f_GoPeopleProfile ;

@property (strong, nonatomic) NSString* user_name_signup ;
@property (strong, nonatomic) NSString* user_password_signup ;

+ (GlobalVariable*) sharedInstance ;

@end