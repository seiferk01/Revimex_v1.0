//
//  TableViewCell.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class TableViewCell: UITableViewCell {

    
    var contenedorImagen = UIImageView()
    var vistaFoto = UIImageView()
    var estado = TextField()
    var precio = TextField()
    var referencia = TextField()
    
    @IBOutlet weak var irBtn: UIButton!
    
    
    var idOfertaActual: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let ancho = screenSize.width
        let largo = self.bounds.height
        
        vistaFoto.frame = CGRect(x:0, y:5, width:ancho*0.4, height: largo-5)
        estado.frame = CGRect(x:ancho*0.4, y:(largo*0.15), width:ancho*0.6, height: (largo*0.3)/2)
        precio.frame = CGRect(x:ancho*0.4, y:(largo*0.45), width:ancho*0.6, height: (largo*0.3)/2)
        referencia.frame = CGRect(x:ancho*0.4, y:(largo*0.75), width:ancho*0.6, height: (largo*0.3)/2)
        
        estado.placeholder = "Estado"
        precio.placeholder = "Precio"
        referencia.placeholder = "Referencia"
        
        estado.isEnabled = false
        precio.isEnabled = false
        referencia.isEnabled = false
        
        
        contenedorImagen.frame = CGRect(x:0, y:0, width:ancho, height: largo)
        contenedorImagen.contentMode = .scaleAspectFill
        contenedorImagen.clipsToBounds = true
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = CGRect(x:0, y:0, width:ancho, height: largo)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contenedorImagen.addSubview(visualEffectView)
        self.addSubview(contenedorImagen)
        self.sendSubview(toBack: contenedorImagen)
        
        self.addSubview(vistaFoto)
        self.addSubview(estado)
        self.addSubview(precio)
        self.addSubview(referencia)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func irDetalles(_ sender: Any) {
        idOfertaSeleccionada = idOfertaActual
    }
    
  
    
}
