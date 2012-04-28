//
//  SimuladorViewController.h
//  Robos
//
//  Created by Pedro Góes on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RobosViewController;

@interface SimuladorViewController : UITableViewController {
    RobosViewController *__strong controller;
    NSMutableArray *__strong registro;
}

@property (strong, nonatomic) RobosViewController * controller;
@property (strong, nonatomic) NSMutableArray *registro;

@end
