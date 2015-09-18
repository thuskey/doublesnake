//
//  DoubleSnakeAppDelegate.m
//  DoubleSnake
//
//  Created by Charles on 7/20/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "DoubleSnakeAppDelegate.h"

@implementation DoubleSnakeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	//UIView *colorStatBar = [[UIView alloc] initWithFrame:CGRectMake(0,0,320 , 20)];
    //colorStatBar.backgroundColor = [UIColor cyanColor];
    //colorStatBar.bounds = CGRectMake(0,0, 320, 20);
    //[_window addSubview:colorStatBar];
    
    //self.loading = [[DoubleSnakeLoadingWindow alloc] init];
	//[self.loading makeKeyAndVisible];
	
	//[[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
	//UIWindow *statusWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //statusWindow.windowLevel = UIWindowLevelStatusBar+1;
    //statusWindow.hidden = NO;
    //statusWindow.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
	//UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,20)];
	//view.frame = [[UIScreen mainScreen] bounds];//[[UIApplication sharedApplication] statusBarFrame];
    //view.bounds = CGRectMake(0,0, 320, 20);
	//view.backgroundColor = [UIColor whiteColor];
	//view.hidden = NO;
    //[_window addSubview:view];
    
    //[statusWindow addSubview:view];
    //[statusWindow makeKeyAndVisible];
    
    //[self.window makeKeyAndVisible];
    /*
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20)];
    splashView.image = [UIScreen mainScreen].bounds.size.height > 500 ? [UIImage imageNamed:@"Default-568h.png"] : [UIImage imageNamed:@"Default.png"];
    [_window addSubview:splashView];
    [_window bringSubviewToFront:splashView];
    //Set your animation below
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector (startupAnimationDone:finished:context:)];
    //splashView.frame = CGRectMake(-60, -60, 440, 600);
    splashView.alpha = 0.0;
    [UIView commitAnimations];
    */
    return YES;

}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
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
