//
//  CompiladorViewController.h
//  Robos
//
//  Created by Pedro Góes on 16/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobosViewController.h"

@class RobosViewController;

@interface CompiladorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tabela;
    RobosViewController * controller;
    NSMutableArray *erros;
}

@property (assign) RobosViewController * controller;
@property (nonatomic, retain) NSMutableArray *erros;

- (void)checarErros;
- (IBAction)corrigirErros;

@end
