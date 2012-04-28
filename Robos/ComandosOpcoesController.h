//
//  ComandosOpcoesController.h
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constantes.h"
#import "ValorOpcoesController.h"
#import "UnidadeOpcoesController.h"
#import "RobosViewController.h"

@class RobosViewController;

@interface ComandosOpcoesController : UITableViewController {
    RobosViewController * __strong controller;
    NSMutableDictionary * __strong info;
}

@property (strong) RobosViewController * controller;
@property (strong) NSMutableDictionary * info;

@end
