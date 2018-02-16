//
//  EtapasInversionistaController.swift
//  Revimex
//
//  Created by Seifer on 14/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class EtapasInversionistaController: UIViewController {
    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    
    let vistasContainer = UIView()

    var propiedades:UIViewController?
    var pagos:UIViewController?
    var contrato:UIViewController?
    
    var arrayViews:[UIViewController?]!
    
    private var actualViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instanciaEtapasInversionistaController = self
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        
        crearCabecera()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        propiedades = storyboard.instantiateViewController(withIdentifier: "InversionistaPropiedadesController") as! PropiedadesInversionistaController
        pagos = storyboard.instantiateViewController(withIdentifier: "InversionistaPagoController") as! PagoInversionistaController
        contrato = storyboard.instantiateViewController(withIdentifier: "InversionistaContratoController") as! ContratoInversionistaController
        
        arrayViews = [propiedades,pagos,contrato]
        
        mostrarVista(vista: "propiedades")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func crearCabecera(){
        
        let barraNavegacion = UIView()
        
        barraNavegacion.frame = CGRect(x:0, y:0, width: ancho, height: largo*0.1)
        
        let cancelarProceso = UITapGestureRecognizer(target: self, action: #selector(cancelProcess(tapGestureRecognizer:)))
        let cancelar = UIButton()
        cancelar.setTitle("Regresar", for: .normal)
        cancelar.setTitleColor(UIColor.black, for: .normal)
        cancelar.frame = CGRect(x:0, y:0, width: ancho*0.25, height: barraNavegacion.bounds.height)
        cancelar.addGestureRecognizer(cancelarProceso)
        
        barraNavegacion.addSubview(cancelar)
        
        let titulo = UILabel()
        titulo.frame = CGRect(x:-0.5, y:largo*0.1, width:ancho+1, height:largo*0.07)
        titulo.text = "Finaliza tu proceso de compra"
        titulo.font = UIFont.boldSystemFont(ofSize: 18.0)
        titulo.textAlignment = .center
        titulo.layer.borderColor = gris?.cgColor
        titulo.layer.borderWidth = 0.3
        
        let progreso = UIView()
        progreso.frame = CGRect(x:0, y:largo*0.18, width:ancho, height:largo*0.12)
        
        let subtitulo = UILabel()
        subtitulo.frame = CGRect(x:0, y:progreso.bounds.height*0.6, width:ancho, height:progreso.bounds.height*0.4)
        subtitulo.font = UIFont(name: "Marion-Italic", size: 20.0)
        subtitulo.textColor = azulObscuro
        subtitulo.text = "Propiedades"
        subtitulo.textAlignment = .center
        
        let iconoPropiedades = UIImageView()
        iconoPropiedades.frame = CGRect(x:ancho*0.1, y:0, width:ancho*0.2, height:progreso.bounds.height*0.6)
        iconoPropiedades.image = UIImage(named: "propiedadesListo.png")
        iconoPropiedades.contentMode = .scaleAspectFit
        
        let iconoPago = UIImageView()
        iconoPago.frame = CGRect(x:ancho*0.4, y:0, width:ancho*0.2, height:progreso.bounds.height*0.6)
        iconoPago.image = UIImage(named: "pagos.png")
        iconoPago.contentMode = .scaleAspectFit
        
        let iconoContrato = UIImageView()
        iconoContrato.frame = CGRect(x:ancho*0.7, y:0, width:ancho*0.2, height:progreso.bounds.height*0.6)
        iconoContrato.image = UIImage(named: "contrato.png")
        iconoContrato.contentMode = .scaleAspectFit
        
        progreso.addSubview(iconoPropiedades)
        progreso.addSubview(iconoPago)
        progreso.addSubview(iconoContrato)
        progreso.addSubview(subtitulo)
        
        vistasContainer.frame = CGRect(x: -0.5, y: largo*0.3, width: ancho+1, height: largo*0.7)
        
        
        view.addSubview(barraNavegacion)
        view.addSubview(titulo)
        view.addSubview(progreso)
        view.addSubview(vistasContainer)
        
    }
    
    
    func mostrarVista(vista: String){
        
        switch vista {
        case "propiedades":
            actualViewController = arrayViews[0]
            break
        case "pagos":
            actualViewController = arrayViews[1]
            break
        case "contrato":
            actualViewController = arrayViews[2]
            break
        default:
            print("ERROR: Caso no especificado en EtapaInversionistaController.mostrarVista()")
            break
        }
        
        
    }
    
    
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = actualViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = vistasContainer.bounds;
            vistasContainer.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    @objc func cancelProcess(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }


}
