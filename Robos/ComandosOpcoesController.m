//
//  ComandosOpcoesController.m
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComandosOpcoesController.h"


@implementation ComandosOpcoesController

@synthesize controller, info;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - User Methods

- (void) valorSliderTrocou:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [slider setValue:slider.value animated:YES];
    [info setValue:[NSNumber numberWithInt:slider.value] forKey:VALOR];
    ((UITableViewCell *)slider.superview).detailTextLabel.text = [[NSNumber numberWithInt:slider.value] stringValue];
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0.0, 0.0, 165.0, 23.0)];
        [slider addTarget:self action:@selector(valorSliderTrocou:) forControlEvents:UIControlEventValueChanged];
        [slider setMinimumValue:0.0];
        [slider setMaximumValue:60.0];
        [slider setValue:[[info objectForKey:VALOR] floatValue]];
        cell.accessoryView = slider;
        cell.textLabel.text = NSLocalizedString(@"Valor", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[info objectForKey:VALOR] stringValue]];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = NSLocalizedString(@"Unidade", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:UNIDADE]];
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        /*
        ValorOpcoesController * voc = [[ValorOpcoesController alloc] initWithStyle:UITableViewStyleGrouped];
        voc.info = self.info;
        voc.controller = self.controller;
        voc.title = NSLocalizedString(@"Valor", nil);
        [self.navigationController pushViewController:voc animated:YES];
         */
    } else if (indexPath.section == 1) {
        UnidadeOpcoesController * uoc = [[UnidadeOpcoesController alloc] initWithStyle:UITableViewStyleGrouped];
        uoc.info = self.info;
        uoc.controller = self.controller;
        uoc.title = NSLocalizedString(@"Unidade", nil);
        [self.navigationController pushViewController:uoc animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
