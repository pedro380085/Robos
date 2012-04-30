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
#import "GraphViewController.h"

@interface SimuladorViewController () {
    NSArray *numerosAleatorios, *labels;
    
    NSInteger indexComandoExterno, indexComandoSucessor, indexComandoInterno, totalComandosExecutados, totalComandosParaPular;
    CGFloat progressoAtual, progressoAcrescimo, progressoComando;
    BOOL dentroBloco, estadoSimulacao;
    
    CGPoint pontoAtual;
}

@end

@implementation SimuladorViewController

@synthesize controller, pontos;

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
    
    labels = [[NSArray alloc] initWithObjects:labelTraffic, labelChip, labelClock, nil];
    
    self.navigationItem.title = NSLocalizedString(@"Simulador", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    pontos = [[NSMutableArray alloc] initWithCapacity:1];
    pontoAtual = CGPointMake(0.0, 0.0);
    [pontos addObject:[NSValue valueWithCGPoint:pontoAtual]];
    
    numerosAleatorios = [self geradorRandomico:3];
    
    indexComandoExterno = 0, indexComandoSucessor = 0, indexComandoInterno = 0, totalComandosExecutados = 0, totalComandosParaPular = 0;
    progressoAtual = 0.0, progressoAcrescimo = 0.0;
    dentroBloco = NO, estadoSimulacao = NO;;
    
    if (estadoSimulacao) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Gráfico", nil) style:UIBarButtonItemStylePlain target:self action:@selector(mostrarGrafico)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // E que comece a mágica :)
    [self construindoRegistro];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    estadoSimulacao = YES;
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

- (void)mostrarGrafico {
    GraphViewController *mgvc = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
    mgvc.pontos = pontos;
    [self.navigationController pushViewController:mgvc animated:YES];
}

- (NSArray *)geradorRandomico:(NSInteger)quantidade {
    
    NSMutableArray *valores = [[NSMutableArray alloc] initWithCapacity:quantidade];
    
    for (int i=0; i<quantidade; i++) {
        int a = arc4random() % 3;

        if (a < 2) { // 66% chance
            [valores addObject:[NSNumber numberWithBool:YES]];
            [[labels objectAtIndex:i] setText:NSLocalizedString(@"Ativado", nil)];
        } else {
            [valores addObject:[NSNumber numberWithBool:NO]];
            [[labels objectAtIndex:i] setText:NSLocalizedString(@"Desativado", nil)];
        }
    }
    
    // Retorna um NSArray e não um NSMutableArray
    return [NSArray arrayWithArray:valores];
}

- (void)construindoRegistro {
    
    // Sempre atualizando para o final da tabela
    [tabela scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:totalComandosExecutados inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    NSMutableArray *comandos = controller.comandos;

    NSMutableDictionary *objetoComando = [comandos objectAtIndex:indexComandoExterno];
    NSInteger comando = [[objetoComando objectForKey:COMANDO] integerValue];
    
    NSInteger tamanhoBloco = 0, indexParaBusca = 0;
    
    if (dentroBloco) {
        objetoComando = [[[comandos objectAtIndex:indexComandoExterno] objectForKey:CONDICIONAL_ARRAY] objectAtIndex:indexComandoInterno];
        tamanhoBloco = [[[comandos objectAtIndex:indexComandoExterno] objectForKey:CONDICIONAL_ARRAY] count];
        comando = [[objetoComando objectForKey:COMANDO] integerValue];
    }
    
    if (![[objetoComando objectForKey:CONDICIONAL] boolValue]) {
        
        if ([[objetoComando objectForKey:VALOR] floatValue] <= progressoAtual) {
            if (dentroBloco) {
                if (indexComandoInterno < tamanhoBloco - 1) {
                    indexComandoInterno++;
                } else {
                    // Resetando valores, pois o bloco acabou
                    indexComandoExterno += indexComandoSucessor;
                    totalComandosExecutados += totalComandosParaPular;
                    indexComandoInterno = 0;
                    dentroBloco = NO;
                }
            } else {
                indexComandoExterno++;
            }
            totalComandosExecutados++;
            progressoAtual = 0.0;
        }
        
        // Atualizar variáveis
        
        progressoComando = [[objetoComando objectForKey:VALOR] floatValue];
        if (progressoComando > progressoAtual) {
            if ([[objetoComando objectForKey:UNIDADE] isEqualToString:UNIDADE_METRO]) {
                progressoAcrescimo = VELOCIDADE;
                if (progressoAtual + progressoAcrescimo > progressoComando) {
                    progressoAcrescimo = progressoComando - progressoAtual;
                }
            } else if ([[objetoComando objectForKey:UNIDADE] isEqualToString:UNIDADE_SEGUNDO]) {
                progressoAcrescimo = 1.0;
            }
            
            progressoAtual += progressoAcrescimo;
            
            switch (comando) {
                case COMANDO_DIRECAO_CIMA:
                    pontoAtual = CGPointMake(pontoAtual.x, pontoAtual.y + progressoAcrescimo);
                    break;
                case COMANDO_DIRECAO_DIREITA:
                    pontoAtual = CGPointMake(pontoAtual.x + progressoAcrescimo, pontoAtual.y);
                    break;
                case COMANDO_DIRECAO_BAIXO:
                    pontoAtual = CGPointMake(pontoAtual.x, pontoAtual.y - progressoAcrescimo);
                    break;
                case COMANDO_DIRECAO_ESQUERDA:
                    pontoAtual = CGPointMake(pontoAtual.x - progressoAcrescimo, pontoAtual.y);
                    break;
                case COMANDO_PARADA:
                    //pontoAtual = CGPointMake(pontoAtual.x, pontoAtual.y + progressoAcrescimo);
                    break;
                    
                default:
                    break;
            }
            
            [pontos addObject:[NSValue valueWithCGPoint:pontoAtual]];
        }
        
        // Sempre que encontramos o comando SE, analisaremos todas as cláusulas até encontrar uma positiva (ou não),
        // dessa forma o código nunca encontra comandos SENAO ou ENTAO (pq eles já terão sido analisados).
    } else if (comando == COMANDO_SE) {
        
        BOOL vivo = YES;
        indexComandoSucessor = 1;
        indexParaBusca = indexComandoExterno;
        
        // Vamos analisar todos as cláusulas até encontrar uma que não seja condicional
        for (int i=0; (indexParaBusca + i) < [comandos count]; i++) {

            // Recebendo os comandos internos
            NSMutableDictionary *objetoComandoCondicional = [controller.comandos objectAtIndex:indexParaBusca + i];
            NSInteger comandoCondicional = [[objetoComandoCondicional objectForKey:COMANDO] integerValue];
            
            if ((comandoCondicional == COMANDO_SE && i == 0) || comandoCondicional == COMANDO_SENAO || comandoCondicional == COMANDO_ENTAO) {
                
                if (vivo) {
                    BOOL estadoAleatorio = [[numerosAleatorios objectAtIndex:([[objetoComandoCondicional objectForKey:CONDICIONAL_CONDICAO_OBJETO] integerValue] - COMANDO_SENSOR_1)] boolValue];
                    BOOL estadoSensor = [[objetoComandoCondicional objectForKey:CONDICIONAL_CONDICAO_ESTADO] boolValue];
                    
                    //if (NO) {
                    if (estadoAleatorio == estadoSensor) {
                        dentroBloco = YES;
                        //indexComandoExterno += i; 
                        indexComandoInterno = 0;
                        indexComandoSucessor = 1;
                        totalComandosExecutados++;
                        vivo = NO;
                        
                        [objetoComandoCondicional setValue:[NSNumber numberWithBool:YES] forKey:SIMULADOR_CONDICIONAL_ESTADO];
                    } else {
                        indexComandoExterno++;
                        totalComandosExecutados += [[objetoComandoCondicional objectForKey:CONDICIONAL_ARRAY] count] + 1; // 1 para a própria célula condicional
                        [objetoComandoCondicional setValue:[NSNumber numberWithBool:NO] forKey:SIMULADOR_CONDICIONAL_ESTADO];
                    }
                    
                } else {
                    indexComandoSucessor++;
                    totalComandosParaPular += [[objetoComandoCondicional objectForKey:CONDICIONAL_ARRAY] count] + 1; // 1 para a própria célula condicional
                    [objetoComandoCondicional setValue:[NSNumber numberWithBool:NO] forKey:SIMULADOR_CONDICIONAL_ESTADO];
                }
            } else {
                break;
            }
            
        }
    }
    
    // Atualizando somente a célula do momento
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:totalComandosExecutados inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tabela reloadData];
    
    //NSLog(@"%d", [controller totalComandos]);
    // Sempre modificando o registro com intervalos de 1 segundo caso não tenham acabado os comandos
    if ([controller totalComandos] > totalComandosExecutados && !estadoSimulacao) {
        [self performSelector:@selector(construindoRegistro) withObject:nil afterDelay:1.0];
    } else {
        estadoSimulacao = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Gráfico", nil) style:UIBarButtonItemStylePlain target:self action:@selector(mostrarGrafico)];
    }
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalComandosExecutados + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Precisamos checar se é a ultima linha E se já chegamos no momento em que a célula não tem mais comandos para apresentar 
    if (indexPath.row == totalComandosExecutados && [controller totalComandos] <= totalComandosExecutados) {
        
        NSString * simpleTableIdentifier = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            cell.showsReorderControl = YES;
        }
        
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        //cell.imageView.image = [UIImage imageNamed:@"48-badge-check"];
        cell.textLabel.text = NSLocalizedString(@"COMPLETO!", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        
        
        return cell;
    } else {
        
        NSString * simpleTableIdentifier = @"SimpleTableIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            cell.showsReorderControl = YES;
        }

        // Criamos o dicionário que armazenará os dados
        NSMutableDictionary *dicionario;
        
        // Variáveis de controle
        BOOL celulaSecundaria = NO;
        
        // Referência aos comandos no controlador
        NSMutableArray *comandos = controller.comandos;
        
        // Procuramos a posição do nosso dicionário
        
            // Agora nós temos que percorrer todos os comandos do array e, se ele for condicional, temos que olhar dentro para sabermos quantos comandos internos existem
            NSInteger total = 0, i = 0, j = 0;
            
            for (i=0; i < [comandos count]; i++) { // Passando por todos os elementos
                for (j=0; j < [[[comandos objectAtIndex:i] objectForKey:CONDICIONAL_ARRAY] count]+1; j++) {
                    // Se for condicional, expande, caso contrário, sai do loop e vai pro incremento de total. Importante notar o +1, que é necessário para que se inclua o comando da condição, ou seja, o pai do bloco. Mesmo no caso em que o comando não é condicional, o código ainda incrementa total.
                    
                    if (indexPath.row == total) { // Se já tivermos chegado ao elemento procurado, não precisamos continuar percorrendo o laço
                        goto final; // Usando goto pois é a maneira mais simples de quebrar dois loops
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
        
        // Configuramos a célula a partir do dicionário recebido
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        cell.imageView.image = [UIImage imageNamed:[controller nomeParaTag:[[dicionario objectForKey: COMANDO] integerValue]]];
        cell.textLabel.textAlignment = UITextAlignmentRight;
        
        if ([[dicionario objectForKey: CONDICIONAL] boolValue] == YES) {
            cell.accessoryView = ([[dicionario objectForKey: SIMULADOR_CONDICIONAL_ESTADO] boolValue]) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"48-badge-check"]] : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"48-badge-cross"]];
        } else {
            if (indexPath.row == totalComandosExecutados) {
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%0.f %@", progressoAtual, [dicionario objectForKey: UNIDADE]];
            } else {
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%d %@", [[dicionario objectForKey: VALOR] integerValue], [dicionario objectForKey: UNIDADE]];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
        }
        
        if (celulaSecundaria) {
            cell.indentationLevel = 3;
        } else {
            cell.indentationLevel = 1;
        }
        
        return cell;
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
