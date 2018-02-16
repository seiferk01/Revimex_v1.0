//
//  OfertaInversionista.swift
//  Revimex
//
//  Created by Seifer on 12/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class OfertaInversionista: NSObject {
    var public_id:String = ""
    var created_at:String = ""
    var total_oferta:String = ""
    var numPropiedades:Int = 0
    var validacion:Int = -1
    var precio_minino = ""
    var razon = ""
    var comentario = ""
    var propiedades:[PropiedadInversionista] = []
}
