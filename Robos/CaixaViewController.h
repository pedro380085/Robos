//
//  CaixaViewController.h
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RobosViewController.h"

@class RobosViewController;

@interface CaixaViewController : UIViewController <CaixaViewDataSource> {
    IBOutlet UIButton * botaoSe;
    IBOutlet UIButton * botaoSenao;
    IBOutlet UIButton * botaoEntao;
    
    NSInteger comandoCondicional;
    UINavigationItem *__strong navigationItem;
    id <CaixaViewDelegate> __strong delegate;
}

@property (assign) NSInteger comandoCondicional;
@property (strong) UINavigationItem *navigationItem;
@property (strong) id <CaixaViewDelegate> delegate;


- (void)resetarInterface;

@end
