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
    
    caixaComandos = [[CaixaViewController alloc] initWithNibName:@"CaixaViewController" bundle:nil];
    caixaComandos.delegate = self;
    caixaComandos.navigationItem = self.navigationItem;
    caixaComandos.comandoCondicional = COMANDO_NULO;
    
    voltarOriginal = self.navigationItem.leftBarButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [tabela reloadData];
    
    // Temos que manter essas linhas aqui para que os botões sejam atualizados sempre que a view aparece
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarNovoComando)];
    self.navigationItem.leftBarButtonItem = voltarOriginal;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(entrarModoEdicao)];
    self.navigationItem.title = NSLocalizedString(@"Comandos", nil);
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
    [tabela setEditing:NO];
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
        [dic setValue:[NSNumber numberWithBool:YES] forKey:CONDICIONAL_CONDICAO_ESTADO];
        [dic setValue:[NSMutableArray array] forKey:CONDICIONAL_ARRAY];
    } else {
        [dic setValue:[NSNumber numberWithInteger:VALOR_PADRAO] forKey:VALOR];
        [dic setValue:UNIDADE_PADRAO forKey:UNIDADE];
        [dic setValue:[NSNumber numberWithBool:NO] forKey:CONDICIONAL];
    }
    
    [[info objectForKey:CONDICIONAL_ARRAY] addObject:dic];
    
    
    [tabela reloadData];
    
    [self retornarNovoComando];
}

- (IBAction) novoSensorAdicionado:(id)sender {
    [info setValue:[NSNumber numberWithInteger:[sender tag]] forKey:CONDICIONAL_CONDICAO_OBJETO];
    [tabela reloadData];
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
    [tabela setEditing: ![tabela isEditing] animated:YES];
    
}

- (void) valorInterruptorTrocou:(id)sender {
    UISwitch *interruptor = (UISwitch *)sender;
    [info setValue:[NSNumber numberWithBool:interruptor.on] forKey:CONDICIONAL_CONDICAO_ESTADO];
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
    // A sentença dentro do if abaixo NÃO representa a última seção da tabela
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    // A sentença dentro do if abaixo NÃO representa a última seção da tabela
    if (indexPath.section+1 != [tableView numberOfSections]) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            //int a = [[cell.contentView subviews] count];
            for (int i=0; i<[[cell.contentView subviews] count]; i++) {
                if ([[[cell.contentView subviews] objectAtIndex:i] isMemberOfClass:[UIImageView class]]) {
                    [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
                }
            }
        
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[controller.dicionarioComandos objectForKey: [info objectForKey:CONDICIONAL_CONDICAO_OBJETO]]]];
            [image setFrame:CGRectMake(200.0, 0.0, 48.0, 48.0)];
            [cell.contentView addSubview:image];
            
            cell.textLabel.text = NSLocalizedString(@"Objeto", nil);
        } else {
            UISwitch *interruptor = [[UISwitch alloc] initWithFrame:CGRectZero];
            [interruptor addTarget:self action:@selector(valorInterruptorTrocou:) forControlEvents:UIControlEventValueChanged];
            if ([[info objectForKey:CONDICIONAL_CONDICAO_ESTADO] boolValue] == YES) {
                [interruptor setOn:YES];
            }
            cell.accessoryView = interruptor;
            cell.textLabel.text = NSLocalizedString(@"Estado", nil);
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
    
    // A sentença dentro do if abaixo NÃO representa a última seção da tabela
    if (section+1 != [tableView numberOfSections]) {
       key = [v objectAtIndex:section];
    } else {
        key = [v objectAtIndex:1];
    }
    
	return key;
}

- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // A sentença dentro do if abaixo NÃO representa a última seção da tabela
    if (indexPath.section+1 != [tableView numberOfSections]) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // A sentença dentro do if abaixo NÃO representa a última seção da tabela
    if (indexPath.section+1 != [tableView numberOfSections]) {
        if (indexPath.row == 0) {
            CaixaSensoresViewController *csvc = [[CaixaSensoresViewController alloc] initWithNibName:@"CaixaSensoresViewController" bundle:nil];
            csvc.delegate = self;
            [self.navigationController pushViewController:csvc animated:YES]; 
        }
    } else {
        ComandosOpcoesController * coc = [[ComandosOpcoesController alloc] initWithStyle:UITableViewStyleGrouped];
        coc.info = [[info objectForKey:CONDICIONAL_ARRAY] objectAtIndex:indexPath.row];
        coc.controller = controller;
        coc.title = NSLocalizedString(@"Comandos", nil);
        [self.navigationController pushViewController:coc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
