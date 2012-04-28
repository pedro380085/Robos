//
//  SimuladorViewController.m
//  Robos
//
//  Created by Pedro Góes on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimuladorViewController.h"
#import "Constantes.h"

@interface SimuladorViewController ()

@end

@implementation SimuladorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Removendo o compilador da pilha
    NSMutableArray *todosControladores = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [todosControladores removeObjectAtIndex:([todosControladores indexOfObject:self] - 1)];
    self.navigationController.viewControllers = todosControladores;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
