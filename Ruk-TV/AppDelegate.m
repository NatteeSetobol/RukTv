//
//  AppDelegate.m
//  Ruk-TV
//
//  Created by code on 3/20/14.
//  Copyright (c) 2014 nomication. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize navigationController, vController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    vController = [[ViewController alloc] init];
    newView = [[UIView alloc] init];
    newView.backgroundColor = [UIColor lightGrayColor];
    [vController.view addSubview:newView];
    [vController.view bringSubviewToFront:newView];

    
    navigationController = [[UINavigationController alloc] initWithRootViewController:vController];
    navigationController.delegate = self;
    
    navigationController.navigationBar.tintColor = [UIColor redColor];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}






- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
    if(self.window.rootViewController){
        UIViewController *presentedViewController =navigationController.topViewController;

        orientations = [presentedViewController supportedInterfaceOrientations];
        
    }
    
    return orientations;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [navigationController release];
    navigationController=nil;
    
    [newView release];
    newView=nil;
    
    [vController release];
    vController=nil;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
