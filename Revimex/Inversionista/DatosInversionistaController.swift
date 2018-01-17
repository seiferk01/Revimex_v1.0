//
//  DatosInversionistaController.swift
//  Revimex
//
//  Created by Seifer on 15/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material
import Motion

class DatosInversionistaController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

//    class addImageGestureRecognizer: UITapGestureRecognizer {
//        var imageTag: Int!
//    }
//
//    let imagePicker = UIImagePickerController()
//
//    var documentoImagen = UIImageView() 
    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    let contenedorFormulario = UIView()
    let contenedorCarga = UIView()
    
    let nombre = TextField()
    let primerApellido = TextField()
    let segundoApellido = TextField()
    let fechaNacimiento = TextField()
    let telefono = TextField()
    let correoElectronico = TextField()
    let rfc = TextField()
    let direccion = TextField()
    
    
    var json:[String:Any?] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        verificarDatos()
        
        crearFormulario()
        
        cargarDocumentos()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func verificarDatos(){
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            let url = "http://18.221.106.92/api/public/user/" + String(userId)
            
            guard let urlInfo = URL(string: url) else{ print("ERROR en URL"); return}
            
            var request = URLRequest(url: urlInfo)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            session.dataTask(with: request){(data,response,error) in
                if(error == nil){
                    if let data = data{
                        do{
                            let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String:Any?]
                            print("*****************Json de Informacion Usuario*****************")
                            print(jsonResponse)
                            
                            self.json = jsonResponse
                            
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
    
    func crearFormulario(){
        
        
        let barraNavegacion = UIView()
        barraNavegacion.frame = CGRect(x:0, y:0, width: ancho, height: largo*0.1)
        
        let cancelarProceso = UITapGestureRecognizer(target: self, action: #selector(cancelProcess(tapGestureRecognizer:)))
        let cancelar = UIButton()
        cancelar.frame = CGRect(x:0, y:0, width: ancho/3, height: largo*0.1)
        cancelar.setTitle("Cancelar", for: .normal)
        cancelar.setTitleColor(UIColor.black, for: .normal)
        cancelar.addGestureRecognizer(cancelarProceso)
        
        
        contenedorFormulario.frame = CGRect(x:0, y:largo*0.1, width: ancho, height: largo-(largo*0.1))
        
        nombre.colorEnable()
        nombre.frame = CGRect(x:ancho*0.05, y:0, width: ancho*0.9, height: (largo*0.1)/2)
        nombre.placeholder = "Nombre"
        nombre.font = UIFont.fontAwesome(ofSize: 14.0)
        
        primerApellido.colorEnable()
        primerApellido.frame = CGRect(x:ancho*0.05, y:largo*0.1, width: ancho*0.9, height: (largo*0.1)/2)
        primerApellido.placeholder = "Apellido Paterno"
        primerApellido.font = UIFont.fontAwesome(ofSize: 14.0)
        
        segundoApellido.colorEnable()
        segundoApellido.frame = CGRect(x:ancho*0.05, y:(largo*0.1)*2, width: ancho*0.9, height: (largo*0.1)/2)
        segundoApellido.placeholder = "Apellido Materno"
        segundoApellido.font = UIFont.fontAwesome(ofSize: 14.0)
        
        fechaNacimiento.colorEnable()
        fechaNacimiento.frame = CGRect(x:ancho*0.05, y:(largo*0.1)*3, width: ancho*0.9, height: (largo*0.1)/2)
        fechaNacimiento.placeholder = "Fecha de Nacimiento"
        fechaNacimiento.font = UIFont.fontAwesome(ofSize: 14.0)
        
        telefono.colorEnable()
        telefono.frame = CGRect(x:ancho*0.05, y:(largo*0.1)*4, width: ancho*0.9, height: (largo*0.1)/2)
        telefono.placeholder = "Telefono"
        telefono.font = UIFont.fontAwesome(ofSize: 14.0)
        
        correoElectronico.colorEnable()
        correoElectronico.frame = CGRect(x:ancho*0.05, y:(largo*0.1)*5, width: ancho*0.9, height: (largo*0.1)/2)
        correoElectronico.placeholder = "Correo Electronico"
        correoElectronico.font = UIFont.fontAwesome(ofSize: 14.0)
        correoElectronico.isEnabled = false
        
        rfc.colorEnable()
        rfc.frame = CGRect(x:ancho*0.05, y:(largo*0.1)*6, width: ancho*0.9, height: (largo*0.1)/2)
        rfc.placeholder = "RFC"
        rfc.font = UIFont.fontAwesome(ofSize: 14.0)
        
        direccion.colorEnable()
        direccion.frame = CGRect(x:ancho*0.05, y:(largo*0.1)*7, width: ancho*0.9, height: (largo*0.1)/2)
        direccion.placeholder = "Direccion"
        direccion.font = UIFont.fontAwesome(ofSize: 14.0)
        
        let enviar = UITapGestureRecognizer(target: self, action: #selector(enviarDatos(tapGestureRecognizer:)))
        let enviarContinuar = UIButton()
        enviarContinuar.frame = CGRect(x:ancho/3, y:((largo*0.1)*8)+(largo*0.1)/4, width: ancho/3, height: largo*0.05)
        enviarContinuar.setTitle("Continuar", for: .normal)
        enviarContinuar.layer.borderColor = UIColor.black.cgColor
        enviarContinuar.layer.borderWidth = 0.5
        enviarContinuar.setTitleColor(UIColor.black, for: .normal)
        enviarContinuar.addGestureRecognizer(enviar)
        
        
        barraNavegacion.addSubview(cancelar)
        contenedorFormulario.addSubview(nombre)
        contenedorFormulario.addSubview(primerApellido)
        contenedorFormulario.addSubview(segundoApellido)
        contenedorFormulario.addSubview(fechaNacimiento)
        contenedorFormulario.addSubview(telefono)
        contenedorFormulario.addSubview(correoElectronico)
        contenedorFormulario.addSubview(rfc)
        contenedorFormulario.addSubview(direccion)
        contenedorFormulario.addSubview(enviarContinuar)
        
        view.addSubview(contenedorFormulario)
        view.addSubview(barraNavegacion)
    }
    
    
    
    @objc func cancelProcess(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }
    
    @objc func enviarDatos(tapGestureRecognizer: UITapGestureRecognizer) {
        let urlOferta = "http://18.221.106.92/api/public/oferta/user"
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            let parameters: [String:Any?] = [
                "user_id" :  String(userId),
                "nombre" : nombre.text,
                "primerApellido" : primerApellido.text,
                "segundoApellido" : segundoApellido.text,
                "fecha_nacimiento" : fechaNacimiento.text,
                "telefono" : telefono.text,
                "rfc" : rfc.text,
                "direccion" : direccion.text
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
                    
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        UIView.animate(withDuration: 1, animations: {
                            
                            self.contenedorFormulario.alpha = 0
                            self.contenedorCarga.alpha = 1
                            
                        },completion: { (finished: Bool) in
                            
                        })
                        
                    })
                    
                }
            }.resume()
            
            
        }
    }
    
    
    func cargarDocumentos(){
        
        contenedorCarga.frame = CGRect(x:0, y:largo*0.1, width: ancho, height: largo-(largo*0.1))
        
        contenedorCarga.alpha = 0
        
        contenedorCarga.addSubview(rowDocumento(documento: "CÉDULA RFC SAT", posicion: 0))
        contenedorCarga.addSubview(rowDocumento(documento: "INE", posicion: 1))
        contenedorCarga.addSubview(rowDocumento(documento: "COMPROBANTE DE DOMICILIO", posicion: 2))
        contenedorCarga.addSubview(rowDocumento(documento: "ESTADO DE CUENTA BANCARIO", posicion: 3))
        
        
        
        view.addSubview(contenedorCarga)
    }

    func rowDocumento(documento: String, posicion: CGFloat) -> UIView{
        
        let row = UIView()
        
        row.frame = CGRect(x:0, y:(largo*0.2)*posicion, width: ancho, height: largo*0.2)
        
        let preview = UIImageView()
        preview.frame = CGRect(x: 0, y: 0, width: ancho*0.25, height: (largo*0.2)-2)
        preview.image = UIImage.fontAwesomeIcon(name: .camera,textColor: UIColor.black,size: CGSize(width: 80, height: 80))
        preview.contentMode = .scaleAspectFill
        preview.clipsToBounds = true
        
        let etiqueta = UILabel()
        etiqueta.frame = CGRect(x: ancho*0.25, y: 0, width: ancho*0.75, height: (largo*0.2)-2)
        etiqueta.text = "Presiona para agregar tu \n"+documento
        etiqueta.numberOfLines = 2
        etiqueta.font = UIFont.fontAwesome(ofSize: 15.0)
        etiqueta.textAlignment = .left
        
//        let selectImageGestureRecognizer = addImageGestureRecognizer(target: self, action: #selector(obtenerImagen(tapGestureRecognizer: )))
//        selectImageGestureRecognizer.imageTag = posicion
        
//        row.addGestureRecognizer(selectImageGestureRecognizer)
        
        row.addSubview(preview)
        row.addSubview(etiqueta)
        
        return row
    }
    
    
    
}
