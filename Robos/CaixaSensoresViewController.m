//
//  CaixaSensoresViewController.m
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CaixaSensoresViewController.h"

@interface CaixaSensoresViewController () {
    BOOL modoAjuda;
}

@end

@implementation CaixaSensoresViewController

@synthesize delegate;

#pragma mark - Memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ajuda", nil) style:UIBarButtonItemStylePlain target:self action:@selector(entrarModoAjuda:)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(retornarNovoComando)];
    self.navigationItem.title = NSLocalizedString(@"Sensores", nil);
    labelAjuda.text = @"";
    
    modoAjuda = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - User Methods

- (IBAction)entrarModoAjuda:(id)sender {
    if (modoAjuda) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ajuda", nil) style:UIBarButtonItemStylePlain target:self action:@selector(entrarModoAjuda:)];
        [labelAjuda setText:@""];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ajuda", nil) style:UIBarButtonItemStyleDone target:self action:@selector(entrarModoAjuda:)];
        [labelAjuda setText:NSLocalizedString(@"Toque nos sensores", nil)];
    }
    
    modoAjuda = !modoAjuda;
}

- (IBAction)novoComandoAdicionado:(id)sender {
    
    if (modoAjuda) {
        switch ([sender tag]) {
            case COMANDO_SENSOR_1:
                [labelAjuda setText:NSLocalizedString(@"Tráfego", nil)];
                break;
            case COMANDO_SENSOR_2:
                [labelAjuda setText:NSLocalizedString(@"Chip", nil)];
                break;
            case COMANDO_SENSOR_3:
                [labelAjuda setText:NSLocalizedString(@"Relógio", nil)];
                break;
                
            default:
                break;
        }
    } else {
        [delegate viewWillAppear:YES];
        [delegate novoSensorAdicionado:sender];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
