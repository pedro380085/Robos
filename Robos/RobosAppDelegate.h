//
//  RobosAppDelegate.h
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RobosViewController;

@interface RobosAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navController;
}

@property (nonatomic) IBOutlet UIWindow *window;
@property (nonatomic) IBOutlet UINavigationController *navController;
@property (nonatomic) IBOutlet RobosViewController *viewController;

@end
