//
//  SimuladorViewController.m
//  Robos
//
//  Created by Pedro Góes on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimuladorViewController.h"
#import "Constantes.h"
#import "RobosViewController.h"

@interface SimuladorViewController () {
    NSInteger indexComandoAtual, indexComandoSucessor;
    CGFloat progressoAtual;
    BOOL dentroBloco;
}

@end

@implementation SimuladorViewController

@synthesize controller, registro;

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
    
    indexComandoAtual = 0, indexComandoSucessor = 0, progressoAtual = 0.0;
    dentroBloco = NO;
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

#pragma mark - User Methods

- (BOOL)geradorRandomico {
    int a = arc4random() % 3;
    
    if (a < 2) { // 66% chance
        return YES;
    }
    
    return NO;
}

- (void)construindoRegistro {
    
    NSMutableDictionary *objetoComando = [controller.comandos objectAtIndex:indexComandoAtual];
    NSInteger comando = [[objetoComando objectForKey:COMANDO] integerValue];
    if (comando == COMANDO_DIRECAO_BAIXO || comando == COMANDO_DIRECAO_DIREITA || comando == COMANDO_DIRECAO_CIMA || comando == COMANDO_DIRECAO_ESQUERDA) {
        if ([[objetoComando objectForKey:VALOR] floatValue] < progressoAtual) {
            if ([[objetoComando objectForKey:UNIDADE] isEqualToString:UNIDADE_METRO]) {
                progressoAtual += VELOCIDADE;
            } else if ([[objetoComando objectForKey:UNIDADE] isEqualToString:UNIDADE_SEGUNDO]) {
                progressoAtual += 1.0;
            }
        } else {
            if (dentroBloco) {
                indexComandoAtual = indexComandoSucessor;
            } else {
                indexComandoAtual++;
            }
        }
        
        // Sempre que encontramos o comando SE, analisaremos todas as cláusulas até encontrar uma positiva (ou não),
        // dessa forma o código nunca encontra comandos SENAO ou ENTAO (pq eles já terão sido analisados).
    } else if (comando == COMANDO_SE) {
        
    }
    
    // Sempre modificando o registro com intervalos de 1 segundo
    [self performSelector:@selector(construindoRegistro) withObject:nil afterDelay:1.0];
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return indexComandoAtual + 2;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
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
        
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[controller.dicionarioComandos objectForKey: [info objectForKey:CONDICIONAL_CONDICAO_OBJETO]]]];
            [image setFrame:CGRectMake(200.0, 0.0, 48.0, 48.0)];
            [cell.contentView addSubview:image];
            
            cell.textLabel.text = NSLocalizedString(@"Objeto", nil);
        } else {
            UISwitch *interruptor = [[UISwitch alloc] initWithFrame:CGRectZero];
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
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray * v = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Condição", nil), NSLocalizedString(@"Comandos internos", nil), nil];
    NSString * key;
    
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
        } else {
            
        }
    } else {
        ComandosOpcoesController * coc = [[ComandosOpcoesController alloc] initWithStyle:UITableViewStyleGrouped];
        coc.info = [[info objectForKey:CONDICIONAL_ARRAY] objectAtIndex:indexPath.row];
        coc.controller = controller;
        coc.title = NSLocalizedString(@"Comandos", nil);
        [self.navigationController pushViewController:coc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}*/

@end
