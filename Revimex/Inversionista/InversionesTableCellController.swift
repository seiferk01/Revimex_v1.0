//
//  InversionesTableCellController.swift
//  Revimex
//
//  Created by Seifer on 08/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class InversionesTableCellController: UITableViewCell {
    
    var oferta = TextField()
    var fecha = TextField()
    var totalOfertado = TextField()
    
    var verPropiedades = UIButton()
    var estatus = UIButton()
    var etiquetaEstatus = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize: CGRect = UIScreen.main.bounds
        
        let ancho = screenSize.width
        let largo = self.bounds.height
        
        
        oferta.placeholder = "Oferta:"
        oferta.frame = CGRect(x:0, y:largo*0.25, width: ancho, height: largo*0.15)
        oferta.placeholderLabel.textColor = azulObscuro
        oferta.textAlignment = .center
        oferta.font = UIFont.boldSystemFont(ofSize: 20.0)
        oferta.isEnabled = false
        
        fecha.placeholder = "Fecha ofertada:"
        fecha.frame = CGRect(x:0, y:largo*0.6, width: ancho*0.5, height: largo*0.15)
        fecha.isEnabled = false
        fecha.placeholderLabel.textColor = azulObscuro
        
        totalOfertado.placeholder = "Ofertaste:"
        totalOfertado.frame = CGRect(x:0, y:largo*0.95, width: ancho*0.5, height: largo*0.15)
        totalOfertado.isEnabled = false
        totalOfertado.placeholderLabel.textColor = azulObscuro
        
        verPropiedades.frame = CGRect(x:ancho*0.55, y:largo*0.6, width: ancho*0.4, height: largo*0.25)
        verPropiedades.setTitle("Ver Propiedades", for: .normal)
        verPropiedades.layer.borderWidth = 0.5
        verPropiedades.layer.borderColor = azulObscuro?.cgColor
        verPropiedades.backgroundColor = azulObscuro
        
        estatus.frame = CGRect(x:ancho*0.55, y:largo*0.95, width: ancho*0.4, height: largo*0.25)
        
        etiquetaEstatus.alpha = 0
        etiquetaEstatus.frame = CGRect(x:ancho*0.55, y:largo*0.95, width: ancho*0.4, height: largo*0.25)
        etiquetaEstatus.text = "Inversion finalizada"
        etiquetaEstatus.font = UIFont(name: "Marion-Italic", size: 18.0)
        etiquetaEstatus.textAlignment = .center
        etiquetaEstatus.textColor = UIColor.black
        
        
        
        
        self.addSubview(oferta)
        self.addSubview(fecha)
        self.addSubview(totalOfertado)
        self.addSubview(verPropiedades)
        self.addSubview(estatus)
        self.addSubview(etiquetaEstatus)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

}
