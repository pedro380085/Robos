//
//  RobosViewController.h
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Constantes.h"
#import "Protocolos.h"
#import "CompiladorViewController.h"
#import "CaixaViewController.h"
#import "CondicionalController.h"
#import "ComandosOpcoesController.h"
#import "ViewControllerDataBuilder.h"

@class CaixaViewController;

@interface RobosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, CaixaViewDelegate> {
    IBOutlet UITableView *tabela;
    IBOutlet UIBarButtonItem *botaoModoLeitura;
    IBOutlet UIBarButtonItem *botaoExecutar;
    CaixaViewController *caixaComandos;
    NSMutableArray *comandos;
    NSDictionary *dicionarioComandos;
    NSArray *dicionarioUnidades;
    
    BOOL modoLeitura;

}

@property (nonatomic) NSMutableArray * comandos;
@property (nonatomic) NSDictionary * dicionarioComandos;
@property (nonatomic) NSArray * dicionarioUnidades;

- (NSString *)nomeParaTag:(NSInteger) tag;
- (void)salvarDados;
- (void)carregarDados;
- (IBAction)executarTocado;
- (IBAction)leituraTocado;
- (NSInteger)totalComandos;

@end
