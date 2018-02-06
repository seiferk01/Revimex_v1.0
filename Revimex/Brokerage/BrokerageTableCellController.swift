//
//  BrokerageTableCellController.swift
//  Revimex
//
//  Created by Seifer on 01/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class BrokerageTableCellController: UITableViewCell {

    
    @IBOutlet weak var fotoBrokerage: UIImageView!
    @IBOutlet weak var estatusBrokerage: UILabel!
    @IBOutlet weak var opcionesBtnBrokerage: UIButton!
    @IBOutlet weak var movimientosBtnBrokerage: UIButton!
    @IBOutlet weak var detallesBtnBrokerage: UIButton!
    
    let detallesBrokerage = PropiedadBrokerage()
    
    var estatus = "Propiedad apartada"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        estatusBrokerage.font = UIFont(name: "Marion-Italic", size: 15.0)
        estatusBrokerage.textColor = UIColor.gray
        
        movimientosBtnBrokerage.setBackgroundImage(UIImage(named: "movimientosDisable.png") as UIImage?, for: .normal)
        self.opcionesBtnBrokerage.setTitle("x Cancelar Proceso", for: .normal)
        
        
        switch estatusBrokerage.text! {
        case "firma_contrato":
            movimientosBtnBrokerage.setBackgroundImage(UIImage(named: "movimientos.png") as UIImage?, for: .normal)
            self.opcionesBtnBrokerage.setTitle("Finalizar Brokerage", for: .normal)
            break
        default:
            movimientosBtnBrokerage.setBackgroundImage(UIImage(named: "movimientosDisable.png") as UIImage?, for: .normal)
            self.opcionesBtnBrokerage.setTitle("x Cancelar Proceso", for: .normal)
            break
        }
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func mostrarDetalles(_ sender: Any) {
        
        instanciaMisBrokerageViewController.detallesBrokerageSeleccionado = detallesBrokerage
        instanciaMisBrokerageViewController.mostrarDetalles()
        
    }
    
    
    //Lee el estatus que tiene la propiedad seleccionada y lo tranfoma en el parametro necesario para enviar al servicio
    @IBAction func retomar(_ sender: Any) {
        
        idOfertaSeleccionada = detallesBrokerage.id_ai
        
        switch estatusBrokerage.text! {
        case "firma_contrato":
            estatus = "firma_contrato"
            break
        case "Propiedad apartada":
            estatus = "activo"
            break
        case "Datos de usuario registrado":
            estatus = "datos_usuario"
            break
        case "Documentos de usuario registrado":
            estatus = "documentos_usuario"
            break
        case "Pago realizado":
            estatus = "pago_realizado"
            break
        default:
            estatus = "activo"
            print("ERROR: El estaus enviado no esta dentro de los casos BrokerageTableCellController")
            break
        }
        
        etapaBrokerage = estatus
        instanciaMisBrokerageViewController.retomarProceso()
    }
    

}
