//
//  ViewControllerDataBuilder.m
//  Robos
//
//  Created by Pedro Góes on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerDataBuilder.h"

@implementation ViewControllerDataBuilder 

/*
+ (QRootElement *)rootParaComandosOpcoesController {
    QRootElement *root = [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"Comandos", nil);
    root.grouped = YES;
    
    QSection *section = [[QSection alloc] init];
    [root addSection:section];
    
    QFloatElement *slider = [[QFloatElement alloc] init];
    [slider setTitle:NSLocalizedString(@"Valor", nil)];
    [slider setControllerAction:@"handleRadio:"];
    [slider setKey:@"slider"];
    [slider setMinimumValue:0.0];
    [slider setMaximumValue:200.0];
    [slider setFloatValue:50.0];
    [section addElement:slider];
    
    
    QSection *section2 = [[QSection alloc] init];
    [root addSection:section2];
    
    QRadioElement *radio = [[QRadioElement alloc] initWithItems:[NSArray arrayWithObjects:UNIDADE_SEGUNDO, UNIDADE_METRO, nil] selected:0];
    [radio setTitle:NSLocalizedString(@"Unidade", nil)];
    [radio setControllerAction:@"handleRadio:"];
    [radio setKey:@"radio"];
    [section2 addElement:radio];
    
    return root;
}
*/
@end
