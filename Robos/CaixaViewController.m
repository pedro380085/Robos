//
//  CaixaViewController.m
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CaixaViewController.h"

@interface CaixaViewController () {
    BOOL modoAjuda;
}

@end

@implementation CaixaViewController

@synthesize delegate, comandoCondicional, navigationItem;

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
    
    modoAjuda = NO;
}

- (void) viewWillAppear:(BOOL)animated {

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(retornarNovoComando)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ajuda", nil) style:UIBarButtonItemStylePlain target:self action:@selector(entrarModoAjuda:)];
    self.navigationItem.title = NSLocalizedString(@"Ferramentas", nil);
    labelAjuda.text = @"";
    
    if (comandoCondicional == COMANDO_SE) {
        [self resetarInterface];
    } else if (comandoCondicional == COMANDO_SENAO) {
            [self resetarInterface];
    } else if (comandoCondicional == COMANDO_ENTAO) {
            botaoSe.hidden = NO;
            botaoSenao.hidden = YES;
            botaoEntao.hidden = YES;
    } else if (comandoCondicional == COMANDO_TODOS) {
        botaoSe.hidden = NO;
        botaoSenao.hidden = NO;
        botaoEntao.hidden = NO;
    } else if (comandoCondicional == COMANDO_NULO) {
        botaoSe.hidden = YES;
        botaoSenao.hidden = YES;
        botaoEntao.hidden = YES;
    } else {
        botaoSe.hidden = NO;
        botaoSenao.hidden = YES;
        botaoEntao.hidden = YES;
    }
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
        [labelAjuda setText:NSLocalizedString(@"Toque nas ferramentas", nil)];
    }
    
    modoAjuda = !modoAjuda;
}

- (void)mostrarAjuda {
    
}

- (void)resetarInterface {
    botaoSe.hidden = NO;
    botaoSenao.hidden = NO;
    botaoEntao.hidden = NO;
}

- (IBAction)novoComandoAdicionado:(id)sender {
    if (modoAjuda) {
        switch ([sender tag]) {
            case COMANDO_DIRECAO_CIMA:
                [labelAjuda setText:NSLocalizedString(@"Ir para frente", nil)];
                break;
            case COMANDO_DIRECAO_DIREITA:
                [labelAjuda setText:NSLocalizedString(@"Ir para a direita", nil)];
                break;
            case COMANDO_DIRECAO_BAIXO:
                [labelAjuda setText:NSLocalizedString(@"Ir para trás", nil)];
                break;
            case COMANDO_DIRECAO_ESQUERDA:
                [labelAjuda setText:NSLocalizedString(@"Ir para a esquerda", nil)];
                break;
            case COMANDO_PARADA:
                [labelAjuda setText:NSLocalizedString(@"Parar", nil)];
                break;
            case COMANDO_SE:
                [labelAjuda setText:NSLocalizedString(@"Se", nil)];
                break;
            case COMANDO_SENAO:
                [labelAjuda setText:NSLocalizedString(@"Senão", nil)];
                break;
            case COMANDO_ENTAO:
                [labelAjuda setText:NSLocalizedString(@"Então", nil)];
                break;
                
            default:
                break;
        }
    } else {
        [delegate viewWillAppear:YES];
        [delegate novoComandoAdicionado:sender];
    }
}

- (IBAction)retornarNovoComando {
    [delegate viewWillAppear:YES];
    [delegate retornarNovoComando];
}

@end
