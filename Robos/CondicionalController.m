//
//  CondicionalController.m
//  Robos
//
//  Created by Pedro Góes on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CondicionalController.h"


@implementation CondicionalController

@synthesize controller, info;

#pragma mark - Memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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
    
    caixaComandos = [[CaixaViewController alloc] initWithNibName:@"CaixaViewController" bundle:nil];
    caixaComandos.delegate = self;
    caixaComandos.navigationItem = self.navigationItem;
    caixaComandos.comandoCondicional = COMANDO_NULO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarNovoComando)] autorelease];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(entrarModoEdicao)];
    self.navigationItem.title = NSLocalizedString(@"Comandos", nil);
    [self.tableView reloadData];
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

- (IBAction) adicionarNovoComando {
    [self.tableView setEditing:NO];
    [self.view addSubview:caixaComandos.view];
    [caixaComandos viewWillAppear:YES];
	
	// Cria uma animação para a transição entre as views
	CATransition * animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[self.view layer] addAnimation:animation forKey:@"TrocaParaCaixaComandos"];
    
}

- (IBAction) novoComandoAdicionado: (id) sender {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dic setValue:[NSNumber numberWithInteger:[sender tag]] forKey:COMANDO];
    if ([sender tag] == COMANDO_SE || [sender tag] == COMANDO_SENAO || [sender tag] == COMANDO_ENTAO) {
        [dic setValue:[NSNumber numberWithInteger:VALOR_PADRAO] forKey:VALOR];
        [dic setValue:@"" forKey:UNIDADE];
        [dic setValue:[NSNumber numberWithBool:YES] forKey:CONDICIONAL];
        [dic setValue:[NSNumber numberWithInteger:COMANDO_SENSOR_1] forKey:CONDICIONAL_CONDICAO_OBJETO];
        [dic setValue:[NSNumber numberWithBool:YES] forKey:CONDICIONAL_CONDICAO_ATIVADO];
        [dic setValue:[NSMutableArray array] forKey:CONDICIONAL_ARRAY];
    } else {
        [dic setValue:[NSNumber numberWithInteger:VALOR_PADRAO] forKey:VALOR];
        [dic setValue:UNIDADE_PADRAO forKey:UNIDADE];
        [dic setValue:[NSNumber numberWithBool:NO] forKey:CONDICIONAL];
    }
    
    [[info objectForKey:CONDICIONAL_ARRAY] addObject:dic];
    
    [dic release];
    
    [self.tableView reloadData];
    
    [self retornarNovoComando];
}

- (IBAction) novoSensorAdicionado:(id)sender {
    [info setValue:[NSNumber numberWithInteger:[sender tag]] forKey:CONDICIONAL_CONDICAO_OBJETO];
    [self.tableView reloadData];
}

- (IBAction) retornarNovoComando {
    [caixaComandos.view removeFromSuperview];
    
    // Cria uma animação para a transição entre as views
	CATransition * animation = [CATransition animation];
	[animation setDuration:0.4];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromBottom];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[self.view layer] addAnimation:animation forKey:@"TrocaParaSuperView"];
}

- (IBAction) entrarModoEdicao {
    [self.tableView setEditing: ![self.tableView isEditing] animated:YES];
    
}

- (void) valorInterruptorTrocou:(id)sender {
    UISwitch *interruptor = (UISwitch *)sender;
    [info setValue:[NSNumber numberWithBool:interruptor.on] forKey:CONDICIONAL_CONDICAO_ATIVADO];
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger comando = [[info objectForKey:COMANDO] integerValue];
    
    if (comando == COMANDO_SE || comando == COMANDO_SENAO) {
        return 2;
    } else {
       return 1; 
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section+1 != [tableView numberOfSections]) {
        return 2;
    } else {
        return [[info objectForKey:CONDICIONAL_ARRAY] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.section+1 != [tableView numberOfSections]) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            //int a = [[cell.contentView subviews] count];
            for (int i=0; i<[[cell.contentView subviews] count]; i++) {
                if ([[[cell.contentView subviews] objectAtIndex:i] isMemberOfClass:[UIImageView class]]) {
                    [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
                }
            }
        
            UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[controller.dicionarioComandos objectForKey: [info objectForKey:CONDICIONAL_CONDICAO_OBJETO]]]] autorelease];
            [image setFrame:CGRectMake(200.0, 0.0, 48.0, 48.0)];
            [cell.contentView addSubview:image];
            
            cell.textLabel.text = NSLocalizedString(@"Objeto", nil);
        } else {
            UISwitch *interruptor = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
            [interruptor addTarget:self action:@selector(valorInterruptorTrocou:) forControlEvents:UIControlEventValueChanged];
            if ([[info objectForKey:CONDICIONAL_CONDICAO_ATIVADO] boolValue] == YES) {
                [interruptor setOn:YES];
            }
            cell.accessoryView = interruptor;
            cell.textLabel.text = NSLocalizedString(@"Ativado", nil);
        }
    } else {
        NSInteger linha = [indexPath row];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:[controller nomeParaTag:[[[[info objectForKey:CONDICIONAL_ARRAY] objectAtIndex:linha] objectForKey: COMANDO] integerValue]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@", 
                                [[[[info objectForKey:CONDICIONAL_ARRAY] objectAtIndex:linha] objectForKey: VALOR] integerValue],
                               [[[info objectForKey:CONDICIONAL_ARRAY] objectAtIndex:linha] objectForKey: UNIDADE]];
        cell.textLabel.textAlignment = UITextAlignmentRight;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray * v = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Condição", nil), NSLocalizedString(@"Comandos internos", nil), nil];
    NSString * key;
    
    if (section+1 != [tableView numberOfSections]) {
       key = [v objectAtIndex:section];
    } else {
        key = [v objectAtIndex:1];
    }
    
	[v release];
	return key;
}

- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[info objectForKey:CONDICIONAL_ARRAY] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section+1 != [tableView numberOfSections]) {
        return 44;
    } else {
        return 66;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Somente o último
    if (indexPath.section+1 != [tableView numberOfSections]) {
        if (indexPath.row == 0) {
            CaixaSensoresViewController *csvc = [[CaixaSensoresViewController alloc] initWithNibName:@"CaixaSensoresViewController" bundle:nil];
            csvc.delegate = self;
            [self.navigationController pushViewController:csvc animated:YES]; 
            [csvc release];
        } else {
            
        }
    } else {
        ComandosOpcoesController * coc = [[ComandosOpcoesController alloc] initWithStyle:UITableViewStyleGrouped];
        coc.info = [[info objectForKey:CONDICIONAL_ARRAY] objectAtIndex:indexPath.row];
        coc.controller = controller;
        coc.title = NSLocalizedString(@"Comandos", nil);
        [self.navigationController pushViewController:coc animated:YES];
        [coc release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
