//
//  CarritoCellController.swift
//  Revimex
//
//  Created by Seifer on 28/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
import Motion

class CarritoCellController: UITableViewCell {

    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var contenedorDatos: UIView!
    
    let direccion = TextField()
    let precio = TextField()
    let desalojo = TextField()
    let total = TextField()
    
    var idOfertaActual: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ancho = contenedorDatos.bounds.width
        let largo = contenedorDatos.bounds.height
        
        direccion.placeholder = "Propiedad"
        precio.placeholder = "Precio"
        desalojo.placeholder = "Desalojo"
        total.placeholder = "Total"
        
        direccion.placeholderNormalColor = azul!
        precio.placeholderNormalColor = azul!
        desalojo.placeholderNormalColor = azul!
        total.placeholderNormalColor = azul!
        
        direccion.isEnabled = false
        precio.isEnabled = false
        desalojo.isEnabled = false
        total.isEnabled = false
        
        direccion.frame = CGRect(x:0,y:largo*0.1,width:ancho,height:largo*0.115)
        precio.frame = CGRect(x:0,y:largo*0.37,width:ancho,height:largo*0.115)
        desalojo.frame = CGRect(x:0,y:largo*0.65,width:ancho,height:largo*0.115)
        total.frame = CGRect(x:0,y:largo*0.91,width:ancho,height:largo*0.115)
        
        contenedorDatos.addSubview(direccion)
        contenedorDatos.addSubview(precio)
        contenedorDatos.addSubview(desalojo)
        contenedorDatos.addSubview(total)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func irDetalles(_ sender: Any) {
        idOfertaSeleccionada = idOfertaActual
    }
    
}
