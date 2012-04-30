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
    IBOutlet UILabel *labelAjuda;
    
    id <CaixaViewDelegate> delegate;
}

@property (strong) id <CaixaViewDelegate> delegate;


@end
