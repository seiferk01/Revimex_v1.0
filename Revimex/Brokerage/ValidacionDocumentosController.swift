//
//  ValidacionDocumentosController.swift
//  Revimex
//
//  Created by Hector Morales on 05/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class ValidacionDocumentosController: UIViewController {

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        
        cargarEstatus()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cargarEstatus(){
        
        let titulo = UILabel()
        titulo.frame = CGRect(x:0, y:largo*0.2, width: ancho, height: largo*0.2)
        titulo.text = "Documentos en proceso de validacion"
        titulo.textColor = UIColor.black
        titulo.textAlignment = .center
        titulo.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        let estatusValidacion = UILabel()
        estatusValidacion.frame = CGRect(x:0, y:largo*0.4, width: ancho, height: largo*0.2)
        estatusValidacion.text = "Sus documentos fueron validados correctamente"
        estatusValidacion.textColor = verde
        estatusValidacion.textAlignment = .center
        estatusValidacion.font = UIFont(name: "Marion-Italic", size: 15.0)
        
        let imagenEstatus = UIImageView()
        imagenEstatus.image = UIImage(named: "aprovado.png")
        imagenEstatus.frame = CGRect(x:ancho*0.4, y:largo*0.6, width: ancho*0.2, height: ancho*0.2)
        imagenEstatus.contentMode = .scaleAspectFit
        
        let siguienteRecognizer = UITapGestureRecognizer(target: self, action: #selector(siguiente(tapGestureRecognizer:)))
        let continuar = UIButton()
        continuar.frame = CGRect(x:ancho/4, y:largo*0.9, width: ancho/2, height: largo*0.06)
        continuar.setTitle("Continuar", for: .normal)
        continuar.setTitleColor(UIColor.black, for: .normal)
        continuar.layer.borderColor = UIColor.black.cgColor
        continuar.layer.borderWidth = 0.5
        continuar.addGestureRecognizer(siguienteRecognizer)
        
        
        view.addSubview(titulo)
        view.addSubview(estatusValidacion)
        view.addSubview(imagenEstatus)
        view.addSubview(continuar)
        
    }
    
    //funcion para registrar el estatus de documentos en proceso de validacion (PENDIENTE DE DEFINIR)
    @objc func siguiente(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var estatus = ""
        
        //integrar aqui servicio para validar documentos
        
        instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
        
        
    }


}
