//
//  GraphViewController.m
//  Robos
//
//  Created by Pedro Góes on 25/04/12.
//  Copyright (c) 2012 pedrogoes.info. All rights reserved.
//

#import "GraphViewController.h"
#import "RobosViewController.h"

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define X_OFFSET (iPad ? 0.1 : 0.15)
#define Y_OFFSET (iPad ? 0.1 : 0.12)

#define X   1
#define Y   2

@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize pontos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    
    // GRAPH code
    graphScale = 1.0f;
    graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
    
    graphHostingView.hostedGraph = graph;
    graph.paddingLeft = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingBottom = 20.0;
    
    [self reloadView];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    [plotSpace setDelegate:self];
    [plotSpace setAllowsUserInteraction:YES];
    
    CPTMutableLineStyle *lineStyle = [CPTLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    axisSet.xAxis.minorTicksPerInterval = 4;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.labelOffset = 3.0f;
    
    axisSet.yAxis.minorTicksPerInterval = 4;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    
    plotGraph = [[CPTScatterPlot alloc] initWithFrame:graph.defaultPlotSpace.graph.bounds];
    plotGraph.identifier = @"Graph";
    ((CPTMutableLineStyle *)plotGraph.dataLineStyle).lineWidth = 2.0f;
    ((CPTMutableLineStyle *)plotGraph.dataLineStyle).lineColor = [CPTColor blueColor];
    plotGraph.dataSource = self;
    [graph addPlot:plotGraph];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    } else {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [graphHostingView setFrame:CGRectMake(graphHostingView.frame.origin.x, 0.0, graphHostingView.frame.size.width, 1004.0)];
        } else {
            [graphHostingView setFrame:CGRectMake(graphHostingView.frame.origin.x, 44.0, graphHostingView.frame.size.width, 704.0)];
        }
    }
}

#pragma mark - User Methods

- (void)reloadView {
    
    lengthX = [self lengthFromArray:pontos forAxis:X];
    lengthY = [self lengthFromArray:pontos forAxis:Y];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([self minValueInArray:pontos forAxis:X] - X_OFFSET * lengthX) length:CPTDecimalFromFloat(lengthX * 1.2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([self minValueInArray:pontos forAxis:Y] - Y_OFFSET * lengthY) length:CPTDecimalFromFloat(lengthY * 1.2)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = [[NSNumber numberWithFloat:lengthX / 5.0f] decimalValue];
    axisSet.yAxis.majorIntervalLength = [[NSNumber numberWithFloat:lengthY / 5.0f] decimalValue];
    
    [graph reloadData];
}

- (void)reloadTicksInterval {
    /*
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = [[NSNumber numberWithFloat:lengthX / 5.0f * graphScale] decimalValue];
    axisSet.yAxis.majorIntervalLength = [[NSNumber numberWithFloat:lengthY / 5.0f * graphScale] decimalValue];
     */
}


- (float)maxValueInArray:(NSMutableArray *)arr forAxis:(NSInteger)axis {
    
    float max = 0.0;
    
    for (int i=0; i<[arr count]; i++) {
        if (axis == X) {
            max = MAX(max, [[arr objectAtIndex:i] CGPointValue].x);
        } else if (axis == Y) {
            max = MAX(max, [[arr objectAtIndex:i] CGPointValue].y);
        }
    }
    
    return max;
}

- (float)minValueInArray:(NSMutableArray *)arr forAxis:(NSInteger)axis {
    
    float min = 0.0;
    
    for (int i=0; i<[arr count]; i++) {
        if (axis == X) {
            min = MIN(min, [[arr objectAtIndex:i] CGPointValue].x);
        } else if (axis == Y) {
            min = MIN(min, [[arr objectAtIndex:i] CGPointValue].y);
        }
    }
    
    return min;
}

- (float)lengthFromArray:(NSMutableArray *)arr forAxis:(NSInteger)axis {
    float length = 0.0;
    
    if (axis == X) {
        length = (MAX(0, [self maxValueInArray:arr forAxis:X]) - [self minValueInArray:arr forAxis:X]);
    }  else if (axis == Y) {
        length = (MAX(0, [self maxValueInArray:arr forAxis:Y]) - [self minValueInArray:arr forAxis:Y]);
    }
    
    // Para que o gráfico não fique vazio quando um dos eixos é 0
    if (length == 0.0) {
        length = 10.0;
    }
    
    return length;
}

- (IBAction)showActionSheet:(id)sender {
    // Mostra popover para o botão
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Ações", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Trocar cor da linha", nil), nil];
    [action showFromBarButtonItem:actionButton animated:YES];
}

#pragma mark - Graph Data Source

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [pontos count];
}


- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithFloat:([[pontos objectAtIndex:index] CGPointValue].x)];
    } else {
        return [NSNumber numberWithFloat:([[pontos objectAtIndex:index] CGPointValue].y)];
    }
}

#pragma mark - Graph Delegate

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint {
    return YES;
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        ((CPTMutableLineStyle *)plotGraph.dataLineStyle).lineColor = [CPTColor redColor];
        [graphHostingView setNeedsDisplay];
    }
}

@end
