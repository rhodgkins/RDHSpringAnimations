//
//  RDHAppDelegate.m
//  RDHSpringAnimations
//
//  Created by Richard Hodgkins on 16/10/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHAppDelegate.h"

#import "RDHSpringViewController.h"

@implementation RDHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [RDHSpringViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.tintColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
