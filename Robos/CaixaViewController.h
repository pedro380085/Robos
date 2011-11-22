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
    UINavigationItem *navigationItem;
    id <CaixaViewDelegate> delegate;
}

@property (assign) NSInteger comandoCondicional;
@property (assign) UINavigationItem *navigationItem;
@property (assign) id <CaixaViewDelegate> delegate;


- (void)resetarInterface;

@end
