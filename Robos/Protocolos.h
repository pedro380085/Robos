//
//  Protocolos.h
//  Robos
//
//  Created by Pedro Góes on 21/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CaixaViewDelegate <NSObject>

@optional
- (IBAction) novoComandoAdicionado: (id) sender;
- (IBAction) adicionarNovoComando;
- (IBAction) retornarNovoComando;
- (IBAction) entrarModoEdicao;
- (IBAction) novoSensorAdicionado:(id)sender;
- (void) viewWillAppear:(BOOL)animated;

@end

@protocol CaixaViewDataSource <NSObject>

@optional
- (IBAction) novoComandoAdicionado: (id) sender;
- (IBAction) retornarNovoComando;
    
@end
