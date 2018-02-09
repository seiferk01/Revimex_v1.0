//
//  DetallesPropiedadController.swift
//  Revimex
//
//  Created by Seifer on 30/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class DetallesPropiedadController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearVista()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func crearVista(){
        
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        let ancho = view.bounds.width
        let largo = view.bounds.height
        
        let direccionCompleta = UILabel()
        direccionCompleta.frame = CGRect(x:0, y:0, width:ancho, height:largo*0.15)
        direccionCompleta.numberOfLines = 2
        direccionCompleta.text = propiedad.colonia + ", " + propiedad.calle + ", " + propiedad.cp
        
        let descripcion = UITextView()
        descripcion.frame = CGRect(x:-0.5, y:largo*0.15, width:ancho+1, height:largo*0.25)
        descripcion.isEditable = false
        descripcion.layer.borderWidth = 0.5
        descripcion.layer.borderColor = UIColor.gray.cgColor
        if propiedad.pros.isEmpty {
            descripcion.text = "Descripcion no disponible"
        }
        else{
            descripcion.text = propiedad.pros.replacingOccurrences(of: ";", with: ", ")
        }
        
        
        let id = TextField()
        id.frame = CGRect(x:0, y:largo*0.45, width:ancho/2, height:(largo*0.1)/2)
        id.placeholder = " Id"
        id.text = propiedad.Id
        id.isEnabled = false
        id.placeholderLabel.textColor = azul
        
        let niveles = TextField()
        niveles.frame = CGRect(x:ancho/2, y:largo*0.45, width:ancho/2, height:(largo*0.1)/2)
        niveles.placeholder = "Niveles"
        niveles.text = propiedad.niveles
        niveles.isEnabled = false
        niveles.placeholderLabel.textColor = azul
        
        let precio = TextField()
        precio.frame = CGRect(x:0, y:largo*0.55, width:ancho/2, height:(largo*0.1)/2)
        precio.placeholder = " Precio"
        precio.text = propiedad.precio
        precio.isEnabled = false
        precio.placeholderLabel.textColor = azul
        
        let habitaciones = TextField()
        habitaciones.frame = CGRect(x:ancho/2, y:largo*0.55, width:ancho/2, height:(largo*0.1)/2)
        habitaciones.placeholder = "Habitaciones"
        habitaciones.text = propiedad.habitaciones
        habitaciones.isEnabled = false
        habitaciones.placeholderLabel.textColor = azul
        
        let terreno = TextField()
        terreno.frame = CGRect(x:0, y:largo*0.65, width:ancho/2, height:(largo*0.1)/2)
        terreno.placeholder = " Terreno"
        terreno.text = propiedad.terreno
        terreno.isEnabled = false
        terreno.placeholderLabel.textColor = azul
        
        let banos = TextField()
        banos.frame = CGRect(x:ancho/2, y:largo*0.65, width:ancho/2, height:(largo*0.1)/2)
        banos.placeholder = "Banos"
        banos.text = propiedad.wcs
        banos.isEnabled = false
        banos.placeholderLabel.textColor = azul
        
        let rendimientoMensual = TextField()
        rendimientoMensual.frame = CGRect(x:0, y:largo*0.75, width:ancho/2, height:(largo*0.1)/2)
        rendimientoMensual.placeholder = " Rendimiento Mensual"
        rendimientoMensual.text = "1.66% - " + instanciaNuevoBrokerageViewController.rendimientoMensual.text!
        rendimientoMensual.isEnabled = false
        rendimientoMensual.placeholderLabel.textColor = azul
        
        let rendimientoAnual = TextField()
        rendimientoAnual.frame = CGRect(x:ancho/2, y:largo*0.75, width:ancho/2, height:(largo*0.1)/2)
        rendimientoAnual.placeholder = "Rendimiento Anual"
        rendimientoAnual.text = "20% - " + instanciaNuevoBrokerageViewController.rendimientoAnual
        rendimientoAnual.isEnabled = false
        rendimientoAnual.placeholderLabel.textColor = azul
        
        
        let continuar = UITapGestureRecognizer(target: self, action: #selector(apartarBrokerage(tapGestureRecognizer:)))
        let apartarBtn = UIButton()
        apartarBtn.frame = CGRect(x:ancho/4, y:largo*0.85, width:ancho/2, height:largo*0.1)
        apartarBtn.setTitle("APARTAR", for: .normal)
        apartarBtn.setTitleColor(UIColor.black, for: .normal)
        apartarBtn.layer.borderWidth = 0.5
        apartarBtn.layer.borderColor = UIColor.black.cgColor
        apartarBtn.addGestureRecognizer(continuar)
        
        
        view.addSubview(direccionCompleta)
        view.addSubview(descripcion)
        view.addSubview(id)
        view.addSubview(niveles)
        view.addSubview(precio)
        view.addSubview(habitaciones)
        view.addSubview(terreno)
        view.addSubview(banos)
        view.addSubview(rendimientoMensual)
        view.addSubview(rendimientoAnual)
        view.addSubview(apartarBtn)
        
        
    }
    
    
    //funcion para apartar la propiedad, envia el estatus "activo", la propiedad quedara con estatus "Propiedad apartada"
    @objc func apartarBrokerage(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Confirmar ", message: "¿Estas seguro que deseas aparatar esta propiedad?", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default))
        
        
        alert.addAction(UIAlertAction(title:"Si",style: UIAlertActionStyle.default,handler: { action in
            
            let activityIndicator = UIActivityIndicatorView()
            let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
            background.center = self.view.center
            self.view.addSubview(background)
            activityIndicator.startAnimating()
            
            let estatus = "activo"
            var respuesta = ""
            
            let urlRegistro = "http://18.221.106.92/api/public/brokerage/register"
            
            var parameters: [String:Any?] = [:]
            
            if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
                parameters = [
                    "id_prop" :  propiedad.Id,
                    "user_id" : String(userId),
                    "tiempo" : instanciaNuevoBrokerageViewController.txFlTiempoInversion.text,
                    "monto" : instanciaNuevoBrokerageViewController.montoInversion
                ]
            }
            
            print("PARAMETROS BROKERAGE: \(parameters)")
            
            guard let url = URL(string: urlRegistro) else { return }
            
            var request = URLRequest (url: url)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let session  = URLSession.shared
            
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                        
                        
                        if let msg = json["message"] as? String{
                            respuesta = msg
                        }
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        
                        activityIndicator.stopAnimating()
                        background.removeFromSuperview()
                        
                        let alert = UIAlertController(title: "Aviso", message: respuesta, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        if respuesta == "Se registro correctamente el avance"{
                            instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
                        }
                        
                    
                    })
                    
                }
            }.resume()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}
