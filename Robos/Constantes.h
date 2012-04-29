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

/* Keys para os dicionários */

// Tipos
#define COMANDO                                 @"Comando"
#define VALOR                                   @"Valor"
#define UNIDADE                                 @"Unidade"
#define CONDICIONAL                             @"Condicional"

// Condicional
#define CONDICIONAL_CONDICAO_OBJETO             @"condicao_objeto"
#define CONDICIONAL_CONDICAO_ESTADO             @"condicao_estado"
#define CONDICIONAL_ARRAY                       @"array"

// Simulador
#define SIMULADOR_CONDICIONAL_ESTADO            @"simulador"

/* Valores para os dicionários */

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
#define VALOR_PADRAO                            4

// Unidade
#define UNIDADE_PADRAO                          NSLocalizedString(@"segundos", nil)
#define UNIDADE_SEGUNDO                         NSLocalizedString(@"segundos", nil)
#define UNIDADE_METRO                           NSLocalizedString(@"metros", nil)

// Simulador
#define VELOCIDADE                              2.0               // m/s

