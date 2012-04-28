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
    RobosViewController * __strong controller;
    CaixaViewController *caixaComandos;
    NSMutableDictionary * __strong info;
    
    UIBarButtonItem *voltarOriginal;
}

@property (strong, nonatomic) RobosViewController * controller;
@property (strong, nonatomic) NSMutableDictionary * info;

@end
