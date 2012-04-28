//
//  ValorOpcoesController.m
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ValorOpcoesController.h"


@implementation ValorOpcoesController

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

- (void) pronto {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    ultimoIndex = [NSIndexPath indexPathForRow:[[info objectForKey:VALOR] integerValue] inSection:0];
    
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

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
    if (indexPath.row == ultimoIndex.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell.accessoryView setFrame:CGRectMake(10.0, cell.accessoryView.frame.origin.y, cell.accessoryView.frame.size.width, cell.accessoryView.frame.size.height)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * ultimaCelula = [tableView cellForRowAtIndexPath:ultimoIndex];
    [ultimaCelula setAccessoryType: UITableViewCellAccessoryNone];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType: UITableViewCellAccessoryCheckmark];
    [ultimaCelula.accessoryView setBounds:CGRectMake(10.0, ultimaCelula.accessoryView.frame.origin.y, ultimaCelula.accessoryView.frame.size.width, ultimaCelula.accessoryView.frame.size.height)];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [info setObject:[NSNumber numberWithInt:indexPath.row] forKey:VALOR];
    
    ultimoIndex = indexPath;
     
}

@end
