//
//  FirmaContratoController.swift
//  Revimex
//
//  Created by Hector Morales on 05/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material
import EPSignature

class FirmaContratoController: UIViewController, EPSignatureDelegate {

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    let firmarBtn = UIButton()
    
    var imgViewSignature = UIImageView()
    
    let generar = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        
        contrato()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func contrato(){
        
        let titulo = UILabel()
        titulo.text = "Contrato"
        titulo.font = UIFont.fontAwesome(ofSize: 20.0)
        titulo.textAlignment = .center
        titulo.frame = CGRect(x:0, y:0, width: ancho, height: largo*0.1)
        
        let imagen = UIImageView(image: UIImage(named: "contratoDemo.jpg"))
        imagen.frame = CGRect(x:ancho*0.05, y:largo*0.1, width: ancho*0.9, height: largo*0.6)
        imagen.clipsToBounds = true
        
        imgViewSignature.frame = CGRect(x:ancho*0.1, y:largo*0.45, width: ancho*0.8, height: largo*0.35)
        imgViewSignature.shadowColor = UIColor.black
        imgViewSignature.clipsToBounds = false
        
        let borde = UIView()
        borde.frame = CGRect(x:0, y:imgViewSignature.bounds.height-1, width: imgViewSignature.bounds.width, height: 0.2)
        borde.layer.borderColor = UIColor.black.cgColor
        borde.layer.borderWidth = 0.2
        imgViewSignature.addSubview(borde)
        
        let firmar = UITapGestureRecognizer(target: self, action: #selector(onTouchSignatureButton(tapGestureRecognizer:)))
        firmarBtn.frame = CGRect(x:ancho*0.1, y:largo*0.8, width: ancho*0.8, height: largo*0.05)
        firmarBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 12.0)
        firmarBtn.setTitleColor(UIColor.black, for: .normal)
        firmarBtn.setTitle("Firmar Contrato", for: .normal)
        firmarBtn.addGestureRecognizer(firmar)
        
        let continuar = UITapGestureRecognizer(target: self, action: #selector(generarContrato(tapGestureRecognizer:)))
        generar.frame = CGRect(x:ancho/4, y:largo*0.9, width: ancho/2, height: largo*0.06)
        generar.setTitle("Generar Contrato", for: .normal)
        generar.setTitleColor(UIColor.black, for: .normal)
        generar.layer.borderColor = UIColor.black.cgColor
        generar.layer.borderWidth = 0.5
        generar.addGestureRecognizer(continuar)

        
        
        view.addSubview(titulo)
        view.addSubview(imagen)
        view.addSubview(imgViewSignature)
        view.addSubview(firmarBtn)
        view.addSubview(generar)
        
        
        
    }
    
    
    @objc func onTouchSignatureButton(tapGestureRecognizer: UITapGestureRecognizer) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "Ingrese su firma"
        signatureVC.title = "Firma"
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
    }
    
    func epSignature(_: EPSignatureViewController, didCancel error : NSError) {
        print("User canceled")
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        imgViewSignature.image = signatureImage
    }
    
    
    @objc func generarContrato(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let estatus = "firma_contrato"
        
        if imgViewSignature.image != nil{
            
            //integrar aqui servicio para generar y descargar el contrato
            
            let alert = UIAlertController(title: "Aviso", message: "El contrato se descargo exitosamente (eso pasara cuando tengamos el servicio de salesforce), tu proceso de brokerage se concluyo exitosamente!!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                
                instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
                
                self.back(vista: self)
                
            }))
            self.present(alert,animated:true,completion:nil)
        }
        else{
            let alert = UIAlertController(title: "Aviso", message: "Debes firmar el contrato primero", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Firmar",style: UIAlertActionStyle.default,handler: { action in
                self.onTouchSignatureButton(tapGestureRecognizer: UITapGestureRecognizer())
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert,animated:true,completion:nil)
        }
    }


}
