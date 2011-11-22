//
//  CaixaSensoresViewController.h
//  Robos
//
//  Created by Pedro Góes on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RobosViewController.h"

@class RobosViewController;

@interface CaixaSensoresViewController : UIViewController <CaixaViewDataSource> {
    IBOutlet UIButton * botaoSe;
    IBOutlet UIButton * botaoSenao;
    IBOutlet UIButton * botaoEntao;
    
    id <CaixaViewDelegate> delegate;
}

@property (assign) id <CaixaViewDelegate> delegate;


@end
