//
//  GraphViewController.h
//  Robos
//
//  Created by Pedro Góes on 25/04/12.
//  Copyright (c) 2012 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@class SimuladorViewController;

@interface GraphViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate, UIActionSheetDelegate> {
    IBOutlet CPTGraphHostingView *graphHostingView;
    NSMutableArray *__strong pontos;
    CPTXYGraph *graph;
    CPTScatterPlot *plotGraph;
    
    UIBarButtonItem *actionButton;
    IBOutlet UIToolbar *toolbar;
    
    
    float lengthX, lengthY;
    CGFloat graphScale;
}

@property (strong, nonatomic) NSMutableArray *pontos;


- (void)reloadView;

@end
