//
//  AppDelegate.m
//  BodyToDress
//
//  Created by Michal Cisarik on 5/18/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "Macros.h"
#import "AppDelegate.h"
#import "AutolayoutMacros.h"
#import "AgileDebugViewController.h"
#import "AgileSideMenuViewController.h"

#import "AgileNavigationBar.h"

#import "SceneViewController.h"

#import <TWTSideMenuViewController.h>
#import "Logging.h"

@interface AppDelegate ()

@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) AgileSideMenuViewController *menuViewController;
@property (nonatomic, strong) AgileDebugViewController *debugViewController;
@property (nonatomic, strong) AgileSideMenuViewController *loginMenuViewController;
@end

@implementation AppDelegate

- (void)setLogging{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDFileLogger *file=[[DDFileLogger alloc]init];
    [file setRollingFrequency:60*60*24];
    [file setMaximumFileSize:1024*1024*2];
    [file.logFileManager setMaximumNumberOfLogFiles:7];
    
    [DDLog addLogger:file];
    DDLogVerbose(@"Lumberjack configured");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //[[NSNotificationCenter defaultCenter] postNotificationName:kAppWillTerminate object:nil];
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setLogging];
    
    [AgileNavigationBar initialize];
  
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.menuViewController = [[AgileSideMenuViewController alloc] init];
    
    self.debugViewController = [[AgileDebugViewController alloc] init];

    
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.debugViewController]];//self.debugViewController [[SceneViewController alloc]init]
        
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    self.window.rootViewController = self.sideMenuViewController;
    
    self.window.backgroundColor = BACKGROUND_COLOR;
    [self.window makeKeyAndVisible];
    return YES;
    
}


#pragma mark - TWTSideMenuViewControllerDelegate

- (UIStatusBarStyle)sideMenuViewController:(TWTSideMenuViewController *)sideMenuViewController statusBarStyleForViewController:(UIViewController *)viewController
{
    if (viewController == self.menuViewController) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)sideMenuViewControllerWillOpenMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"willOpenMenu");
}

- (void)sideMenuViewControllerDidOpenMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"didOpenMenu");
}

- (void)sideMenuViewControllerWillCloseMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"willCloseMenu");
}

- (void)sideMenuViewControllerDidCloseMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"didCloseMenu");
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


@end
