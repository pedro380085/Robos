//
//  CompiladorViewController.h
//  Robos
//
//  Created by Pedro Góes on 16/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RobosViewController;

@interface CompiladorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tabela;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *botaoErros;
    IBOutlet UIBarButtonItem *botaoAvancar;
    RobosViewController *__strong controller;
    NSMutableArray *__strong erros;
}

@property (strong, nonatomic) RobosViewController * controller;
@property (strong, nonatomic) NSMutableArray *erros;

- (void)checarErros;
- (IBAction)corrigirErros:(id)sender;
- (IBAction)avancar:(id)sender;

@end
