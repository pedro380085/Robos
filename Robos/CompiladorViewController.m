//
//  CompiladorViewController.m
//  Robos
//
//  Created by Pedro Góes on 16/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CompiladorViewController.h"
#import "SimuladorViewController.h"

@interface CompiladorViewController ()
@property BOOL estadoErros;
@end

@implementation CompiladorViewController

@synthesize controller, erros, estadoErros;

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

    erros = [[NSMutableArray alloc] initWithCapacity:1];
    
    self.navigationItem.title = NSLocalizedString(@"Compilador", nil);
    [botaoErros setTitle:NSLocalizedString(@"Corrigir Erros", nil)];
             
    [self checarErros];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - User Methods

- (void)setEstadoErros:(BOOL)novoEstadoErros {
    estadoErros = novoEstadoErros;
    
    if (estadoErros == NO && erros != nil) {
        [botaoAvancar setEnabled:YES];
    } else {
        [botaoAvancar setEnabled:NO];
    }
}

- (BOOL)estadoErros {
    return estadoErros;
}

- (void)checarErros {
    [erros removeAllObjects];
    
    for (int i=0; i<[controller.comandos count]; i++) {
        NSInteger comando = [[[controller.comandos objectAtIndex:i] objectForKey:COMANDO] integerValue];
        
        if (comando == COMANDO_SENAO || comando == COMANDO_ENTAO) {
            if (i == 0) {
                [erros addObject:[NSString stringWithFormat:@"%@ %d)", NSLocalizedString(@"Comando SE não encontrado (linha", nil), i+1]];
            } else {
                comando = [[[controller.comandos objectAtIndex:(i-1)] objectForKey:COMANDO] integerValue];
                if (comando != COMANDO_SE && comando != COMANDO_SENAO) {
                    [erros addObject:[NSString stringWithFormat:@"%@ %d)", NSLocalizedString(@"Comando SE ou SENÃO não encontrado (linha", nil), i+1]];
                }
            }
        }
        
    }
    
    self.estadoErros = ([erros count] != 0) ? YES : NO;
    [tabela reloadData];
}

- (IBAction)corrigirErros:(id)sender {
    for (int i=0; i<[controller.comandos count]; i++) {
        NSInteger comando = [[[controller.comandos objectAtIndex:i] objectForKey:COMANDO] integerValue];
        
        if (comando == COMANDO_SENAO || comando == COMANDO_ENTAO) {
            if (i == 0) {
                [[controller.comandos objectAtIndex:i] setValue:[NSNumber numberWithInteger:COMANDO_SE] forKey:COMANDO];
            } else {
                comando = [[[controller.comandos objectAtIndex:(i-1)] objectForKey:COMANDO] integerValue];
                if (comando != COMANDO_SE && comando != COMANDO_SENAO) {
                    [[controller.comandos objectAtIndex:i] setValue:[NSNumber numberWithInteger:COMANDO_SE] forKey:COMANDO];
                }
            }
        }
        
    }
    
    self.estadoErros = NO;
    [tabela reloadData];
    //[self checarErros];
}

- (IBAction)avancar:(id)sender {
    SimuladorViewController * svc = [[SimuladorViewController alloc] initWithNibName:@"SimuladorViewController" bundle:nil];
    //svc.controller = self;
    [self.navigationController pushViewController:svc animated:YES];
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
    return [erros count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [erros objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = (estadoErros == 1) ? [UIImage imageNamed:@"48-badge-cross"] : [UIImage imageNamed:@"48-badge-check"];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
