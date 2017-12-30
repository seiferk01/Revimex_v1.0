//
//  Carrito.swift
//  Revimex
//
//  Created by Seifer on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class Carrito: NSObject {
    
    var idPropiedad: String
    var estado: String
    var municipio: String
    var colonia: String
    var precio: String
    var fechaAgregado: String
    var total: String
    var foto: UIImage
    
    init(idPropiedad: String,estado: String, municipio: String, colonia: String, precio: String, fechaAgregado: String, total: String, foto: UIImage){
        self.idPropiedad = idPropiedad
        self.estado = estado
        self.municipio = municipio
        self.colonia = colonia
        self.precio = precio
        self.fechaAgregado = fechaAgregado
        self.total = total
        self.foto = foto
    }
    
}
