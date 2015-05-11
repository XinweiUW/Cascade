//
//  AppDelegate.m
//  Cascade-iOS-App
//
//  Created by iGuest on 3/25/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"
#import "DataManager.h"
#import "DSNavigationBar.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0]
@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    //[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x66CC00)];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"leftMenu.jpg"] forBarMetrics:UIBarMetricsDefault];
    //UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar_bg"];
    //[[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor colorWithRed:(32/255.0) green:(32/255.0) blue:(32/255) alpha:0.2f];
    [[DSNavigationBar appearance] setNavigationBarWithColor:color];
    //CGSize imgSizeUp = CGSizeMake(20, 30);
    //UIImage *backImage = [self imageWithImage:[UIImage imageNamed:@"back.png"] scaledToSize:imgSizeUp];
    //[[DSNavigationBar appearance] setBackIndicatorImage:backImage];
    //[[DSNavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
    //UIImage *backButtonImage = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    self.userDefault =[NSUserDefaults standardUserDefaults];
    if (![self.userDefault objectForKey:@"lastDate"]){
        [self.userDefault setObject:[NSDate date] forKey:@"lastDate"];
        [self.userDefault synchronize];
    }else{
        NSDate *lastDate = [self.userDefault objectForKey:@"lastDate"];
        NSDate *now = [NSDate date];
        if ([now timeIntervalSinceDate:lastDate] > 3600000000000){
            [self.userDefault setBool:NO forKey:@"hasBeenLaunchedOnceKey"];
            [self.userDefault setObject:now forKey:@"lastDate"];
            [self.userDefault synchronize];
        }
    }
    return NO;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.datamanager saveContext];
}


-(DataManager *)datamanager{
    if (!_datamanager){
        _datamanager = [DataManager new];
    }
    return _datamanager;
}

@end
