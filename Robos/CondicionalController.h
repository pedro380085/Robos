//
//  CondicionalController.h
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constantes.h"
#import "ComandosOpcoesController.h"
#import "RobosViewController.h"
#import "CaixaSensoresViewController.h"

@class RobosViewController;
@class CaixaViewController;

@interface CondicionalController : UITableViewController <CaixaViewDelegate> {
    RobosViewController * controller;
    CaixaViewController *caixaComandos;
    NSMutableDictionary * info;
}

@property (assign) RobosViewController * controller;
@property (assign) NSMutableDictionary * info;

@end
