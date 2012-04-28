//
//  UnidadeOpcoesController.m
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnidadeOpcoesController.h"


@implementation UnidadeOpcoesController

@synthesize controller, info, ultimoIndex;

#pragma mark - Memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    ultimoIndex = [NSIndexPath indexPathForRow:[controller.dicionarioUnidades indexOfObject:[info objectForKey:UNIDADE]] inSection:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pronto)];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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

- (void) pronto {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [controller.dicionarioUnidades count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [controller.dicionarioUnidades objectAtIndex: indexPath.row]];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    if (indexPath.row == ultimoIndex.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:ultimoIndex] setAccessoryType: UITableViewCellAccessoryNone];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType: UITableViewCellAccessoryCheckmark];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [info setObject:[controller.dicionarioUnidades objectAtIndex: indexPath.row] forKey:UNIDADE];
    
    ultimoIndex = indexPath;
}

@end
