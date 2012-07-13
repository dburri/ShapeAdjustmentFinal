//
//  AppDelegate.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <Accelerate/Accelerate.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // initialize control
    ControlMain *mainController = [[ControlMain alloc] init];
    
    // initialize model and pass it to controller
    PDMShapeModel *shapeModel = [[PDMShapeModel alloc] init];
    [shapeModel loadModel:@"model_xm" :@"model_v" :@"model_d" :@"model_tri"];
    mainController.shapeModel = shapeModel;

    // retrieve root view controller and pass main controller to it
    ViewController *rootViewController = (ViewController*)_window.rootViewController;
    rootViewController.mainController = mainController;

    
    
    // Access ViewController and set the main controller to it
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    //ViewController *controller = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ViewControllerMain"];
    //[controller setMainControl:mainController];
    //mainController = nil;
    
    NSLog(@"Application launched....");
    
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
