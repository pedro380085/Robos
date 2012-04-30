//
//  SimuladorViewController.h
//  Robos
//
//  Created by Pedro Góes on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RobosViewController;

@interface SimuladorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    RobosViewController *__strong controller;
    NSMutableArray *__strong pontos;
    
    IBOutlet UITableView *tabela;
    IBOutlet UILabel *labelClock;
    IBOutlet UILabel *labelTraffic;
    IBOutlet UILabel *labelChip;
}

@property (strong, nonatomic) RobosViewController * controller;
@property (strong, nonatomic) NSMutableArray *pontos;

- (NSArray *)geradorRandomico:(NSInteger)quantidade;
- (void)construindoRegistro;

@end
