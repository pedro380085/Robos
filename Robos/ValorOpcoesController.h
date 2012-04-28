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
    RobosViewController * __unsafe_unretained controller;
    NSMutableDictionary * __unsafe_unretained info;
    NSIndexPath * ultimoIndex;
}

@property (unsafe_unretained) RobosViewController * controller;
@property (unsafe_unretained) NSMutableDictionary * info;
@property (nonatomic) NSIndexPath * ultimoIndex;


@end
