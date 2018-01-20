//
//  NuevoBrokerage.swift
//  Revimex
//
//  Created by Seifer on 19/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class NuevoBrokerage: NSObject {
        
        public var id:String!;
        public var id_ai:Int!;
        public var estado:String!;
        public var municipio:String!;
        public var valorReferencia:String!;
        public var precioOriginal:String!;
        public var tipo:String!;
        public var construccion:String!;
        public var terreno:String!;
        public var urlFotoPrincipal:String!;
        public var urlFotos:[[String:Any?]]!;
        
    init(id:String!,id_ai:Int!,estado:String!,municipio:String!,valorReferencia:String!,precioOriginal:String!,tipo:String!,construccion:String!,terreno:String!,urlFotoPrincipal:String!, urlFotos:[[String:Any?]]!) {
            self.id = id;
            self.id_ai = id_ai;
            self.estado = estado;
            self.municipio = municipio;
            self.valorReferencia = valorReferencia;
            self.precioOriginal = precioOriginal;
            self.tipo = tipo;
            self.construccion = construccion;
            self.terreno = terreno;
            self.urlFotoPrincipal = urlFotoPrincipal;
            self.urlFotos = urlFotos;
        }
    
    
}
