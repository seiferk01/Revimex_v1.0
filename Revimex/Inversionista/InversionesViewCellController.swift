//
//  InversionesViewCellController.swift
//  Revimex
//
//  Created by Seifer on 11/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material
import Motion

class InversionesViewCellController: UITableViewCell {

    var foto = UIImageView()
    var contenedorDatos = UIView()
    
    var estado = TextField()
    var calle = TextField()
    var precio = TextField()
    
    var idOfertaActual: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellWidth = self.bounds.width
        let cellHeigth = self.bounds.height
        
        foto.frame = CGRect(x:0, y:0, width:cellHeigth ,height:cellHeigth)
        contenedorDatos.frame = CGRect(x:cellHeigth, y:0, width:cellWidth-cellHeigth ,height:cellHeigth)
        
        let ancho = contenedorDatos.bounds.width
        let largo = contenedorDatos.bounds.height
        
        estado.placeholder = "Estado"
        calle.placeholder = "Calle"
        precio.placeholder = "Precio"
        
        estado.placeholderNormalColor = azul!
        calle.placeholderNormalColor = azul!
        precio.placeholderNormalColor = azul!
        
        estado.isEnabled = false
        calle.isEnabled = false
        precio.isEnabled = false
        
        estado.frame = CGRect(x:0,y:largo*0.1,width:ancho,height:largo*0.115)
        calle.frame = CGRect(x:0,y:largo*0.37,width:ancho,height:largo*0.115)
        precio.frame = CGRect(x:0,y:largo*0.65,width:ancho,height:largo*0.115)
        
        contenedorDatos.addSubview(estado)
        contenedorDatos.addSubview(calle)
        contenedorDatos.addSubview(precio)
        
        self.addSubview(foto)
        self.sendSubview(toBack: foto)
        self.addSubview(contenedorDatos)
        self.sendSubview(toBack: contenedorDatos)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func irDetalles(_ sender: Any) {
        idOfertaSeleccionada = idOfertaActual
    }
    
    

}
