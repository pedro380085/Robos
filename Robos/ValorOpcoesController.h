//
//  ValorOpcoesController.h
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobosViewController.h"

@class RobosViewController;

@interface ValorOpcoesController : UITableViewController {
    RobosViewController * controller;
    NSMutableDictionary * info;
    NSIndexPath * ultimoIndex;
}

@property (assign) RobosViewController * controller;
@property (assign) NSMutableDictionary * info;
@property (nonatomic, retain) NSIndexPath * ultimoIndex;


@end
