//
//  RobosViewController.m
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RobosViewController.h"

@implementation RobosViewController

@synthesize comandos, dicionarioComandos, dicionarioUnidades;


#pragma mark - Memory management

- (void)dealloc
{
    [comandos release];
    [dicionarioComandos release];
    [dicionarioUnidades release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self carregarDados];
    
    [botaoExecutar setTitle:NSLocalizedString(@"Executar", nil)];
    [botaoModoLeitura setTitle:NSLocalizedString(@"Expandir", nil)];
    
    NSMutableDictionary * e = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               @"48-arrow-up", [NSNumber numberWithInt:COMANDO_DIRECAO_CIMA],
                               @"48-arrow-right", [NSNumber numberWithInt:COMANDO_DIRECAO_DIREITA],
                               @"48-arrow-down", [NSNumber numberWithInt:COMANDO_DIRECAO_BAIXO],
                               @"48-arrow-left", [NSNumber numberWithInt:COMANDO_DIRECAO_ESQUERDA], 
                               @"48-badge-minus", [NSNumber numberWithInt:COMANDO_PARADA], 
                               @"48-help", [NSNumber numberWithInt:COMANDO_SE],
                               @"48-warning", [NSNumber numberWithInt:COMANDO_SENAO],
                               @"48-cancel", [NSNumber numberWithInt:COMANDO_ENTAO],
                               @"128-traffic_lights", [NSNumber numberWithInt:COMANDO_SENSOR_1],
                               @"48-HardwareChip", [NSNumber numberWithInt:COMANDO_SENSOR_2],
                               @"128-sensors-applet", [NSNumber numberWithInt:COMANDO_SENSOR_3],
                               nil];
    self.dicionarioComandos = e;
    [e release];
    
    NSMutableArray * f = [[NSMutableArray alloc] initWithObjects: UNIDADE_SEGUNDO, UNIDADE_METRO, nil];
    self.dicionarioUnidades = f;
    [f release];
    
    caixaComandos = [[CaixaViewController alloc] initWithNibName:@"CaixaViewController" bundle:nil];
    caixaComandos.delegate = self;
    caixaComandos.navigationItem = self.navigationItem;
    caixaComandos.comandoCondicional = [[[comandos lastObject] objectForKey:COMANDO] integerValue];
    
    tabela.allowsSelectionDuringEditing = YES;
    
    modoLeitura = NO;
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarNovoComando)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(entrarModoEdicao)] autorelease];
    self.navigationItem.title = NSLocalizedString(@"Fluxo", nil);
}

#pragma mark - Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - User Methods

- (NSString *) nomeParaTag: (NSInteger) tag {
    return [dicionarioComandos objectForKey:[NSNumber numberWithInt:tag]];
}

#pragma mark - IO Methods

- (void)salvarDados {
    [NSKeyedArchiver archiveRootObject:self.comandos toFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO]];
}

- (void)carregarDados {
    id root = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO]];
    if (root) {
        self.comandos = root;
    } else {
        self.comandos = [NSMutableArray array];
    }
}

#pragma mark - XIB Methods

- (IBAction)executarTocado {
    CompiladorViewController * coc = [[CompiladorViewController alloc] initWithNibName:@"CompiladorViewController" bundle:nil];
    coc.controller = self;
    [self.navigationController pushViewController:coc animated:YES];
    [coc release];
}

- (IBAction)leituraTocado {
    if (modoLeitura) {
        botaoModoLeitura.title = NSLocalizedString(@"Expandir", nil);
    } else {
        botaoModoLeitura.title = NSLocalizedString(@"Recolher", nil);
    }
    
    modoLeitura = !modoLeitura;
    [tabela reloadData];
}

#pragma mark - Delegate Methods

- (IBAction) adicionarNovoComando {
    [tabela setEditing:NO];
    [self.view addSubview:caixaComandos.view];
    caixaComandos.comandoCondicional = ([[NSUserDefaults standardUserDefaults] boolForKey:@"modo_edicao"] ? [[[comandos lastObject] objectForKey:COMANDO] integerValue] : COMANDO_TODOS);
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
        [dic setValue:0 forKey:VALOR];
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
    
    [comandos addObject:dic];
    
    [dic release];
    
    [tabela reloadData];
    
    [self retornarNovoComando];
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
    if (modoLeitura) {
        [self leituraTocado];
    }
    [tabela setEditing: ![tabela isEditing] animated:YES];
    
}

#pragma mark - TableView DataSource and Delegate


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!modoLeitura) {
        return [comandos count];
    } else {
        NSInteger total = 0;
        for (int i=0; i<[comandos count]; i++) {
            total += 1 + [[[comandos objectAtIndex:i] objectForKey:CONDICIONAL_ARRAY] count];
        }
        
        return total;
    }

    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * simpleTableIdentifier = @"SimpleTableIdentifier";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] autorelease];
        cell.showsReorderControl = YES;
	}
    
    // Criamos o dicionário que armazenará os dados
    NSMutableDictionary *dicionario;
    
    // Variáveis de controle
    BOOL celulaSecundaria = NO;
    
    // Procuramos a posição do nosso dicionário
    if (!modoLeitura) {
        dicionario = [comandos objectAtIndex:[indexPath row]];
    } else {
        NSInteger total = 0, i = 0, j = 0;
        for (i=0; i<[comandos count]; i++) {
            for (j=0; j<[[[comandos objectAtIndex:i] objectForKey:CONDICIONAL_ARRAY] count]+1; j++) {
                if (indexPath.row == total) {
                    goto final;
                }
                total++;
            }
        }
        
    final:
        
        if (j==0) {
            dicionario = [comandos objectAtIndex:i];
        } else {
            dicionario = [[[comandos objectAtIndex:i] objectForKey: CONDICIONAL_ARRAY] objectAtIndex:(j-1)];
            celulaSecundaria = YES;
        }
    }
    
    // Configuramos a célula a partir do dicionário recebido
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    cell.imageView.image = [UIImage imageNamed:[self nomeParaTag:[[dicionario objectForKey: COMANDO] integerValue]]];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
    if ([[dicionario objectForKey: CONDICIONAL] boolValue] == YES) {
        if ([[dicionario objectForKey: CONDICIONAL_CONDICAO_ATIVADO] boolValue] == YES) {
            cell.textLabel.text = NSLocalizedString(@"Ativado", nil);
        } else {
            cell.textLabel.text = NSLocalizedString(@"Desativado", nil);
        }
    } else {
        cell.textLabel.text = [[[NSString alloc] initWithFormat:@"%d %@", 
                                [[dicionario objectForKey: VALOR] integerValue],
                                [dicionario objectForKey: UNIDADE]] autorelease];
    }
    
    if (celulaSecundaria) {
        cell.indentationLevel = 3;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.indentationLevel = 1;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (modoLeitura) {
        return NO;
    } else {
       return YES;     
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BOOL modo = [[NSUserDefaults standardUserDefaults] boolForKey:@"modo_edicao"];
        
        if (!modo) {
            [comandos removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
        } else {
            NSInteger comando = [[[self.comandos objectAtIndex:indexPath.row] objectForKey:COMANDO] integerValue];
            
            [comandos removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
            
            // Verifica se existem mais comandos condicionais para excluir
            if (comando == COMANDO_SE) {
                int i=1;
                if (indexPath.row < [comandos count]) {
                    comando = [[[self.comandos objectAtIndex:indexPath.row] objectForKey:COMANDO] integerValue];
                }
                
                while (comando == COMANDO_SENAO || comando == COMANDO_ENTAO) {
                    [comandos removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationRight];
                    
                    i++;
                    
                    if (indexPath.row == [comandos count]) {
                        break;
                    }
                    
                    comando = [[[self.comandos objectAtIndex:indexPath.row] objectForKey:COMANDO] integerValue];
                }
                
            }
        }
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO];
    
    // Criamos o dicionário que armazenará os dados
    NSMutableDictionary *dicionario;
    
    // Variáveis de controle
    BOOL celulaSecundaria = NO;
    
    // Procuramos a posição do nosso dicionário
    if (!modoLeitura) {
        dicionario = [comandos objectAtIndex:[indexPath row]];
    } else {
        NSInteger total = 0, i = 0, j = 0;
        for (i=0; i<[comandos count]; i++) {
            for (j=0; j<[[[comandos objectAtIndex:i] objectForKey:CONDICIONAL_ARRAY] count]+1; j++) {
                if (indexPath.row == total) {
                    goto final;
                }
                total++;
            }
        }
        
    final:
        
        if (j==0) {
            dicionario = [comandos objectAtIndex:i];
        } else {
            dicionario = [[[comandos objectAtIndex:i] objectForKey: CONDICIONAL_ARRAY] objectAtIndex:(j-1)];
            celulaSecundaria = YES;
        }
    }
    
    if (!celulaSecundaria) {
        // Verificamos o valor da chave CONDICIONAL e, caso seja YES, puxamos o CondicionalController, caso seja NO, puxamos o ComandosOpcoesController
        if ([[[self.comandos objectAtIndex:indexPath.row] objectForKey:CONDICIONAL] boolValue]) {
            CondicionalController * cc = [[CondicionalController alloc] initWithStyle:UITableViewStyleGrouped];
            cc.info = dicionario;
            cc.controller = self;
            cc.title = NSLocalizedString(@"Condicional", nil);
            [self.navigationController pushViewController:cc animated:YES];
            [cc release];
        } else {
            ComandosOpcoesController *coc = (ComandosOpcoesController *) [[ComandosOpcoesController alloc] initWithRoot:[ViewControllerDataBuilder rootParaComandosOpcoesController]];
            [self.navigationController pushViewController:coc animated:YES];
            /*
            ComandosOpcoesController * coc = [[ComandosOpcoesController alloc] initWithStyle:UITableViewStyleGrouped];
            coc.info = dicionario;
            coc.controller = self;
            coc.title = NSLocalizedString(@"Comandos", nil);
            [self.navigationController pushViewController:coc animated:YES];
            [coc release];
             */
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL modo = [[NSUserDefaults standardUserDefaults] boolForKey:@"modo_edicao"];
    
    if (!modo) {
        return YES;
    } else {
        NSInteger comando = [[[self.comandos objectAtIndex:indexPath.row] objectForKey:COMANDO] integerValue];
        if (comando == COMANDO_SENAO || comando == COMANDO_ENTAO) {
            return NO;
        } else {
            return YES;   
        }
    }

}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    BOOL modo = [[NSUserDefaults standardUserDefaults] boolForKey:@"modo_edicao"];
    
    if (!modo) {
        id objeto = [[comandos objectAtIndex:(destinationIndexPath.row)] retain];
        [comandos removeObjectAtIndex:(destinationIndexPath.row)];
        [comandos insertObject:objeto atIndex:(sourceIndexPath.row)];
        [objeto release];
    } else {
        // Variáveis de controle
        NSInteger comandoAnterior, comando, comandoSeguinte;
        BOOL operacaoValida = YES;
        
        // Antes de modificar qualquer valor, salvamos o valor do comando selecionado. Ele será necessário para verificar se o comando é do tipo SE.
        comando = [[[self.comandos objectAtIndex:sourceIndexPath.row] objectForKey:COMANDO] integerValue];
        
        /* Move a célula da origem para a origem.. Esse comando ainda será checado para ver se é válido (se não for, será revertido)
         Nós preferimos mover para o destino porque checar se o comando é válido sem mover seria muito mais complicado */
        id objeto = [[comandos objectAtIndex:(sourceIndexPath.row)] retain];
        [comandos removeObjectAtIndex:(sourceIndexPath.row)];
        [comandos insertObject:objeto atIndex:(destinationIndexPath.row)];
        [objeto release];
        
        // Salvando o valor dos comandos imediatamente antes e depois do comando selecionado.
        if ((destinationIndexPath.row+1) == [comandos count]) {
            comandoSeguinte = COMANDO_NULO;
        } else {
            comandoSeguinte = [[[self.comandos objectAtIndex:(destinationIndexPath.row+1)] objectForKey:COMANDO] integerValue];
        }
        
        if (destinationIndexPath.row == 0) {
            comandoAnterior = COMANDO_NULO;
        } else {
            comandoAnterior = [[[self.comandos objectAtIndex:(destinationIndexPath.row-1)] objectForKey:COMANDO] integerValue];
        }
        
        /* Verificamos se o comando é válido.
         Para isso se checamos se o mesmo está entre um bloco de condicionais, ou seja, se o comandoAnterior for if ou ifelse e se o comandoSeguinte for ifelse ou else.
         Se o comando for inválido, revertemos a operação efetuada e atualizamos o valor da bandeira.
         */
        if (comandoAnterior == COMANDO_SE || comandoAnterior == COMANDO_SENAO) {
            if (comandoSeguinte == COMANDO_SENAO || comandoSeguinte == COMANDO_ENTAO) {
                operacaoValida = NO;
                
                objeto = [[comandos objectAtIndex:(destinationIndexPath.row)] retain];
                [comandos removeObjectAtIndex:(destinationIndexPath.row)];
                [comandos insertObject:objeto atIndex:(sourceIndexPath.row)];
                [objeto release];
            }
        }
        
        
        // A operação sendo válida e o comando sendo if (ele é a cabeça do bloco condicional), iremos mover o resto do bloco para a posição adequada
        if (comando == COMANDO_SE && operacaoValida == YES) {
            
            // Reverte a operação para deixar o vetor de comandos em seu estado original
            objeto = [[comandos objectAtIndex:(destinationIndexPath.row)] retain];
            [comandos removeObjectAtIndex:(destinationIndexPath.row)];
            [comandos insertObject:objeto atIndex:(sourceIndexPath.row)];
            [objeto release];
            
            // Cria um vetor para armazenar todos os objetos que serão retirados de comandos
            NSMutableArray *objetos = [[NSMutableArray array] retain];
            // Adiciona o primeiro comando ao vetor (caso especial pois ele é o único if que pode aparecer dentro do bloco a ser substituído)
            [objetos addObject:[self.comandos objectAtIndex:sourceIndexPath.row]];
            
            /* O bloco de código abaixo irá ler comandos até encontrar um comando que não seja nem elseif nem else.
             Para cada comando elseif e else encontrados, ele adiciona ele ao objetos */
            int i=1;
            if (sourceIndexPath.row+i < [comandos count]) {
                comando = [[[comandos objectAtIndex:(sourceIndexPath.row+i)] objectForKey:COMANDO] integerValue];
            }
            
            while (comando == COMANDO_SENAO || comando == COMANDO_ENTAO) {
                [objetos addObject:[comandos objectAtIndex:(sourceIndexPath.row+i)]];
                i++;
                
                if ((sourceIndexPath.row+i) == [comandos count]) {
                    break;
                }
                
                comando = [[[comandos objectAtIndex:(sourceIndexPath.row+i)] objectForKey:COMANDO] integerValue];
            }
            
            // Remove todos os objetos que foram adicionados ao vetor objetos
            [comandos removeObjectsInRange:NSMakeRange(sourceIndexPath.row, i)];
            
            /* Nesse laço final verificamos a direção do movimento
             Sendo de baixo para cima, apenas adicionamos os elementos em comandos, desta vez na nova posição.
             Sendo de cima para baixo, temos que checar duas coisas:
             1. Se o vetor comandos acabou (o método para inserção de objetos fora dos limites do vetor é outro).
             2. Precisamos substrair os comandos que ficaram entre o início do bloco condicional e o próximo comando (essas células ocupam espaços que teoricamente não deveriam)
             Com essas duas condições satisfeitas, apenas adicionamos o resto do vetor
             */
            for (int j=0; j<i; j++) {
                if (destinationIndexPath.row <= sourceIndexPath.row) {
                    [comandos insertObject:[objetos objectAtIndex:j] atIndex:destinationIndexPath.row+j];
                } else {
                    if (destinationIndexPath.row+j-(i-1) >= [comandos count]) {
                        [comandos addObject:[objetos objectAtIndex:j]];
                    } else if (destinationIndexPath.row-sourceIndexPath.row >= i-1) {
                        [comandos insertObject:[objetos objectAtIndex:j] atIndex:destinationIndexPath.row+j-(i-1)];
                    } else {
                        [comandos insertObject:[objetos objectAtIndex:j] atIndex:destinationIndexPath.row+j];
                    }
                }
                
            }
            
            // Liberamos o objeto
            [objetos release];
        }
        
        [tableView reloadData];
    }
}


#pragma mark - Navigation Controller Delegate

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [tabela reloadData];
    }
}


@end
