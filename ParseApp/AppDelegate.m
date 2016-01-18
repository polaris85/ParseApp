//
//  AppDelegate.m
//  ParseApp
//
//  Created by Adam on 7/8/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "FrontMainVC.h"
#import "RearMainVC.h"
#import "CommonClass.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GlobalVariable sharedInstance].APIHOST = @"http://54.69.210.207/uSnapServices.svc/";
    [Parse setApplicationId:@"vErqCD7OuanXpIaMfxXIydi2wAbYFgQpSHWsRmno" clientKey:@"czCWG1rrTr6mMd5IqaALg9wDpGsasSdcVjFcKgo5"];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound];
    
    return YES;
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My device is: %@", device);
    [GlobalVariable sharedInstance].Auth_Token = device;
    
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) onGoHome {

    UIStoryboard  *mainStoryBoard = [[UIStoryboard alloc] init];
    mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    FrontMainVC *mainMenuVC = [[CommonClass shareInstance] getAudioPlayerVC];
    RearMainVC *controlMenuVC = [[CommonClass shareInstance] getAudioListVC];
    controlMenuVC.delegate = mainMenuVC;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:mainMenuVC];
    navigationController.navigationBarHidden = YES;
    
    ZUUIRevealController *zuuiRevealController = [[ZUUIRevealController alloc]initWithFrontViewController:navigationController rearViewController:controlMenuVC];
    self.viewController = zuuiRevealController;
    self.window.rootViewController = self.viewController;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MCM" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MCM.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)handleBackgroundNotification:(NSDictionary *)notification
{
//    NSDictionary *aps = (NSDictionary *)[notification objectForKey:@"aps"];
//    NSMutableString *alert = [NSMutableString stringWithString:@""];
//    if ([aps objectForKey:@"alert"])
//    {
//        [alert appendString:(NSString *)[aps objectForKey:@"alert"]];
//    }
//    if ([notification objectForKey:@"job_id"])
//    {
//        // do something with job id
//        int jobID = [[notification objectForKey:@"job_id"] intValue];
//    }
}

@end
