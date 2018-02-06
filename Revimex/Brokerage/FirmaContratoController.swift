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
    
    var imgViewSignature = UIImageView()
    
    
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
        titulo.frame = CGRect(x:0, y:largo*0.05, width: ancho, height: largo*0.1)
        
        let imagen = UIImageView(image: UIImage(named: "contratoDemo.jpg"))
        imagen.frame = CGRect(x:ancho*0.05, y:largo*0.15, width: ancho*0.9, height: largo*0.6)
        //imagen.contentMode = .scaleAspectFit
        imagen.clipsToBounds = true
        
        imgViewSignature.frame = CGRect(x:ancho*0.1, y:largo*0.65, width: ancho*0.8, height: largo*0.2)
        imgViewSignature.addBorder(toSide: .Bottom, withColor: UIColor.black.cgColor, andThickness: 1.0)
//        imgViewSignature.layer.borderColor = UIColor.black.cgColor
//        imgViewSignature.layer.borderWidth = 0.5
        
        let firmar = UITapGestureRecognizer(target: self, action: #selector(onTouchSignatureButton(tapGestureRecognizer:)))
        let firmarBtn = UIButton()
        firmarBtn.frame = CGRect(x:ancho*0.1, y:largo*0.85, width: ancho*0.8, height: largo*0.1)
        firmarBtn.setTitleColor(UIColor.black, for: .normal)
        firmarBtn.setTitle("Firmar Contrato", for: .normal)
        firmarBtn.addGestureRecognizer(firmar)
        
        
        view.addSubview(titulo)
        view.addSubview(imagen)
        view.addSubview(imgViewSignature)
        view.addSubview(firmarBtn)
        
        
        
        
        
        view.addSubview(imgViewSignature)
        view.addSubview(firmarBtn)
        
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
    


}
