//
//  DatosUsuarioInversionistaController.swift
//  Revimex
//
//  Created by Seifer on 31/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class DatosUsuarioInversionistaController: UIViewController {

    
    let nombre = TextField()
    let primerApellido = TextField()
    let segundoApellido = TextField()
    let fechaNacimiento = TextField()
    let telefono = TextField()
    let correoElectronico = TextField()
    let rfc = TextField()
    let direccion = TextField()
    let modificarBtn = UIButton()
    let regresar = UIButton()
    let continuar = UIButton()
    let enviarBtn = UIButton()
    
    
    var json:[String:Any?] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datosInversionista()
        
        verificarDatos()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func datosInversionista(){
        
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        let anchoDatosUsuario = view.bounds.width
        let largoDatosUsuario = view.bounds.height
        
        nombre.colorEnable()
        nombre.frame = CGRect(x:anchoDatosUsuario*0.05, y:largoDatosUsuario*0.1, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        nombre.placeholder = "Nombre"
        nombre.font = UIFont.fontAwesome(ofSize: 12.0)
        
        primerApellido.colorEnable()
        primerApellido.frame = CGRect(x:anchoDatosUsuario*0.05, y:largoDatosUsuario*0.2, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        primerApellido.placeholder = "Apellido Paterno"
        primerApellido.font = UIFont.fontAwesome(ofSize: 12.0)
        
        segundoApellido.colorEnable()
        segundoApellido.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.3), width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        segundoApellido.placeholder = "Apellido Materno"
        segundoApellido.font = UIFont.fontAwesome(ofSize: 12.0)
        
        fechaNacimiento.colorEnable()
        fechaNacimiento.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.4), width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        fechaNacimiento.placeholder = "Fecha de Nacimiento"
        fechaNacimiento.font = UIFont.fontAwesome(ofSize: 12.0)
        
        telefono.colorEnable()
        telefono.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.5), width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        telefono.placeholder = "Telefono"
        telefono.font = UIFont.fontAwesome(ofSize: 12.0)
        
        correoElectronico.colorEnable()
        correoElectronico.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.6), width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        correoElectronico.placeholder = "Correo Electronico"
        correoElectronico.font = UIFont.fontAwesome(ofSize: 12.0)
        
        rfc.colorEnable()
        rfc.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.7), width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        rfc.placeholder = "RFC"
        rfc.font = UIFont.fontAwesome(ofSize: 12.0)
        
        direccion.colorEnable()
        direccion.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.8), width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        direccion.placeholder = "Direccion"
        direccion.font = UIFont.fontAwesome(ofSize: 12.0)
        

        let enviar = UITapGestureRecognizer(target: self, action: #selector(enviarDatos(tapGestureRecognizer:)))
        enviarBtn.frame = CGRect(x:anchoDatosUsuario/4, y:largoDatosUsuario*0.9, width: anchoDatosUsuario/2, height: largoDatosUsuario*0.06)
        enviarBtn.setTitle("Confirmar y continuar", for: .normal)
        enviarBtn.setTitleColor(UIColor.black, for: .normal)
        enviarBtn.layer.borderColor = UIColor.black.cgColor
        enviarBtn.layer.borderWidth = 0.5
        enviarBtn.addGestureRecognizer(enviar)
        
        
        
        view.addSubview(nombre)
        view.addSubview(primerApellido)
        view.addSubview(segundoApellido)
        view.addSubview(fechaNacimiento)
        view.addSubview(telefono)
        view.addSubview(correoElectronico)
        view.addSubview(rfc)
        view.addSubview(direccion)
        view.addSubview(enviarBtn)
        
    }
    
    
    
    func verificarDatos(){
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            let urlGetUser = "http://18.221.106.92/api/public/brokerage/getUser"
            
            let parameters: [String:Any] = [
                "user_id" : userId
            ]
            
            guard let url = URL(string: urlGetUser) else { return }
            
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
                if(error == nil){
                    if let data = data{
                        do{
                            let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String:Any?]
                            print("*****************Json de Informacion Usuario*****************")
                            print(jsonResponse)
                            
                            if let data = jsonResponse["data"] as? [String:Any?]{
                                self.json = data
                            }
                            
                        }catch{
                            print(error)
                        }
                        
                    }
                    
                    OperationQueue.main.addOperation({
                        activityIndicator.stopAnimating()
                        background.removeFromSuperview()
                        if let nom = self.json["name"] as? String{
                            self.nombre.text = nom
                        }
                        if let ap1 = self.json["apellidoPaterno"] as? String{
                            self.primerApellido.text = ap1
                        }
                        if let ap2 = self.json["apellidoMaterno"] as? String{
                            self.segundoApellido.text = ap2
                        }
                        if let fec = self.json["fecha_nacimiento"] as? String{
                            self.fechaNacimiento.text = fec
                        }
                        if let tel = self.json["tel"] as? String{
                            self.telefono.text = tel
                        }
                        if let email = self.json["email"] as? String{
                            self.correoElectronico.text = email
                        }
                        if let r_f_c = self.json["rfc"] as? String{
                            self.rfc.text = r_f_c
                        }
                        if let dir = self.json["direccion"] as? String{
                            self.direccion.text = dir
                        }
                        
                        let alert = UIAlertController(title: "Aviso", message: "Verifique sus datos para continuar", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert,animated:true,completion:nil)
                        
                    })
                    
                    
                }
            }.resume()
        }
    }
    
    
        @objc func enviarDatos(tapGestureRecognizer: UITapGestureRecognizer) {
            
            let activityIndicator = UIActivityIndicatorView()
            let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
            background.center = self.view.center
            self.view.addSubview(background)
            activityIndicator.startAnimating()
            
            let estatus = "datos_usuario"
            var respuesta = "x"
    
            let urlOferta = "http://18.221.106.92/api/public/brokerage/progressUser"
    
            if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
                let parameters: [String:Any?] = [
                    "id_prop" : propiedad.Id,
                    "user_id" : String(userId),
                    "inv_nombre" : nombre.text,
                    "inv_primer_apellido" : primerApellido.text,
                    "inv_segundo_apellido" : segundoApellido.text,
                    "inv_fecha_nacimiento" : fechaNacimiento.text,
                    "inv_telefono" : telefono.text,
                    "inv_correo" : correoElectronico.text,
                    "inv_rfc" : rfc.text,
                    "inv_direccion" : direccion.text,
                    "estatus" : estatus
                ]
    
                guard let url = URL(string: urlOferta) else { return }
    
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
    
                            print(json)
                            print(json["message"])
                            if let msg = json["message"] as? String{
                                respuesta = msg
                            }
    
                        } catch {
                            print("El error es: ")
                            print(error)
                        }
    
                    }
                }.resume()
    
                OperationQueue.main.addOperation({
                    
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
    
                    let alert = UIAlertController(title: "Aviso", message: respuesta, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert,animated:true,completion:nil)
                    
                    if respuesta == "Se registro correctamente el avance"{
                        instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
                    }
                    
    
                })
    
            }
        }


}
