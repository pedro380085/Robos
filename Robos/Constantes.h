//
//  Constantes.h
//  Robos
//
//  Created by Pedro Góes on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Arquivo
#define ARQUIVO                                 @"dados.plist"

// User Defaults
#define MODO_EDICAO                             @"modo_edicao"

// Tipos
#define COMANDO                                 @"Comando"
#define VALOR                                   @"Valor"
#define UNIDADE                                 @"Unidade"
#define CONDICIONAL                             @"Condicional"


// Categorias

// Comando
#define COMANDO_NULO                            1000
#define COMANDO_TODOS                           1001
#define COMANDO_DIRECAO_CIMA                    1003
#define COMANDO_DIRECAO_DIREITA                 1004
#define COMANDO_DIRECAO_BAIXO                   1005
#define COMANDO_DIRECAO_ESQUERDA                1006
#define COMANDO_PARADA                          1007
#define COMANDO_SE                              1008
#define COMANDO_SENAO                           1009
#define COMANDO_ENTAO                           1010
#define COMANDO_SENSOR_1                        1011
#define COMANDO_SENSOR_2                        1012
#define COMANDO_SENSOR_3                        1013

// Valor
#define VALOR_PADRAO                            3

// Unidade
#define UNIDADE_PADRAO                          NSLocalizedString(@"segundos", nil)
#define UNIDADE_SEGUNDO                         NSLocalizedString(@"segundos", nil)
#define UNIDADE_METRO                           NSLocalizedString(@"metros", nil)

// Condicional
#define CONDICIONAL_CONDICAO_OBJETO             @"condicao_obj"
#define CONDICIONAL_CONDICAO_ATIVADO            @"condicao_ati"
#define CONDICIONAL_ARRAY                       @"array"