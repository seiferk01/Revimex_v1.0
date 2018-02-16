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
import AVFoundation
import Photos.PHPhotoLibrary

class DatosInversionistaController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    class addImageGestureRecognizer: UITapGestureRecognizer {
        var imageTag: Int!
        var nombrerDocumento: String!
    }
    
    let imagePicker = UIImagePickerController()
    var identificadorImagen:Int = -1
    
    var placeholderImage = UIImage()
    
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
        
        placeholderImage = UIImage.fontAwesomeIcon(name: .camera,textColor: UIColor.black,size: CGSize(width: 80, height: 80))
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        verificarDatos()
        
        crearFormulario()
        
        contenedorCarga.alpha = 0
        
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
        
        let documentos = UITapGestureRecognizer(target: self, action: #selector(cargaDeDocumentos(tapGestureRecognizer:)))
        let cargarDocumentos = UIButton()
        cargarDocumentos.frame = CGRect(x:ancho/3, y:((largo*0.1)*8)+(largo*0.1)/4, width: ancho/3, height: largo*0.05)
        cargarDocumentos.setTitle("Continuar", for: .normal)
        cargarDocumentos.layer.borderColor = UIColor.black.cgColor
        cargarDocumentos.layer.borderWidth = 0.5
        cargarDocumentos.setTitleColor(UIColor.black, for: .normal)
        cargarDocumentos.addGestureRecognizer(documentos)
        

        barraNavegacion.addSubview(cancelar)
        contenedorFormulario.addSubview(nombre)
        contenedorFormulario.addSubview(primerApellido)
        contenedorFormulario.addSubview(segundoApellido)
        contenedorFormulario.addSubview(fechaNacimiento)
        contenedorFormulario.addSubview(telefono)
        contenedorFormulario.addSubview(correoElectronico)
        contenedorFormulario.addSubview(rfc)
        contenedorFormulario.addSubview(direccion)
        contenedorFormulario.addSubview(cargarDocumentos)
        
        view.addSubview(contenedorFormulario)
        view.addSubview(barraNavegacion)
    }
    
    @objc func cargaDeDocumentos(tapGestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1, animations: {
            
            self.contenedorFormulario.alpha = 0
            self.contenedorCarga.alpha = 1
            
        },completion: { (finished: Bool) in
            
        })
    }
    
    func cargarDocumentos(){
        
        contenedorCarga.frame = CGRect(x:0, y:largo*0.1, width: ancho, height: largo-(largo*0.1))
        
        contenedorCarga.addSubview(rowDocumento(documento: "CÉDULA RFC SAT", posicion: 0))
        contenedorCarga.addSubview(rowDocumento(documento: "INE", posicion: 1))
        contenedorCarga.addSubview(rowDocumento(documento: "COMPROBANTE DE DOMICILIO", posicion: 2))
        contenedorCarga.addSubview(rowDocumento(documento: "ESTADO DE CUENTA BANCARIO", posicion: 3))
        
        let enviar = UITapGestureRecognizer(target: self, action: #selector(enviarDatos(tapGestureRecognizer:)))
        let enviarContinuar = UIButton()
        enviarContinuar.frame = CGRect(x:ancho/3, y:((largo*0.1)*8)+(largo*0.1)/4, width: ancho/3, height: largo*0.05)
        enviarContinuar.setTitle("Continuar", for: .normal)
        enviarContinuar.layer.borderColor = UIColor.black.cgColor
        enviarContinuar.layer.borderWidth = 0.5
        enviarContinuar.setTitleColor(UIColor.black, for: .normal)
        enviarContinuar.addGestureRecognizer(enviar)
        
        contenedorCarga.addSubview(enviarContinuar)
        
        view.addSubview(contenedorCarga)
        
    }
    
    func rowDocumento(documento: String, posicion: CGFloat) -> UIView{
        
        let row = UIView()
        
        row.frame = CGRect(x:0, y:(largo*0.2)*posicion, width: ancho, height: largo*0.2)
        
        let preview = UIImageView()
        preview.frame = CGRect(x: 0, y: 0, width: ancho*0.25, height: (largo*0.2)-2)
        preview.image = placeholderImage
        preview.contentMode = .scaleAspectFit
        preview.clipsToBounds = true
        preview.tag = Int(posicion)+100
        
        let etiqueta = UILabel()
        etiqueta.frame = CGRect(x: ancho*0.25, y: 0, width: ancho*0.75, height: (largo*0.2)-2)
        etiqueta.text = "Presiona para agregar tu \n"+documento
        etiqueta.numberOfLines = 2
        etiqueta.font = UIFont.fontAwesome(ofSize: 15.0)
        etiqueta.textAlignment = .left
        
        let selectImageGestureRecognizer = addImageGestureRecognizer(target: self, action: #selector(obtenerImagen(tapGestureRecognizer: )))
        selectImageGestureRecognizer.imageTag = preview.tag
        selectImageGestureRecognizer.nombrerDocumento = documento
        
        row.addGestureRecognizer(selectImageGestureRecognizer)
        
        row.addSubview(preview)
        row.addSubview(etiqueta)
        
        return row
    }
    
    
    @objc func obtenerImagen(tapGestureRecognizer: addImageGestureRecognizer){
        
        identificadorImagen = tapGestureRecognizer.imageTag
        
        let alert = UIAlertController(title: "Agregar "+tapGestureRecognizer.nombrerDocumento, message: "¿Desea tomar una fotografía o agregar una imagen de su galería?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"Cámara",style: UIAlertActionStyle.default,handler: { action in
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                // Already Authorized
                self.tomarFoto()
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        // User granted
                        self.tomarFoto()
                    } else {
                        // User Rejected
                        self.present(Utilities.showAlertSimple("Permiso denegado anteriormente", "Por favor concede el permiso de la camara desde la configuracion de tu iPhone"), animated: true)
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Galería", style: UIAlertActionStyle.default, handler: { action in
            
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                self.abrirGaleria()
            }
            else{
                PHPhotoLibrary.requestAuthorization(){ (status) -> Void in
                    if status == .authorized{
                        self.abrirGaleria()
                    } else {
                        self.present(Utilities.showAlertSimple("Permiso denegado anteriormente", "Por favor concede el permiso de la galeria desde la configuracion de tu iPhone"), animated: true)
                    }
                }
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    func tomarFoto(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.present(Utilities.showAlertSimple("Error", "La camara de su dispositivo no esta disponible"), animated: true)
        }
    }
    
    func abrirGaleria(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            self.present(Utilities.showAlertSimple("Error", "La Galería no esta disponible"), animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData,pickedImage: pickedImage)
        }
        
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        let oldSize: CGSize = image.size
        let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
        imagedata = resizeImage(newSize, image: image)
        
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func createRequest(with imageBase64: String, pickedImage: UIImage){
        
        var resultado = false
        
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        self.view.addSubview(background)
        activityIndicator.startAnimating()
        
        let urlGoogle = "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyCoufQ-7IiWlsYdUQDBywYSoH1SfQfVTIo"
        
        let parameters: [String:Any?] = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "SAFE_SEARCH_DETECTION"
                    ],
                    [
                        "type": "LABEL_DETECTION"
                    ]
                ]
            ]
        ]
        
        guard let url = URL(string: urlGoogle) else { return }
        
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
                    
                    if let responses = json["responses"] as? NSArray{
                        for response in responses{
                            if let Result = response as? [String:Any?]{
                                
                                if let labels = Result["labelAnnotations"] as? NSArray{
                                    for label in labels{
                                        if let labelElement = label as? [String:Any?]{
                                            if (labelElement["description"] as! String) == "identity document" || (labelElement["description"] as! String) == "document" || (labelElement["description"] as! String) == "text"{
                                                resultado = true
                                            }
                                        }
                                    }
                                }
                                
                                if let anotation = Result["safeSearchAnnotation"] as? [String:Any?]{
                                    if let adult = anotation["adult"] as? String,
                                        let violence = anotation["violence"] as? String{
                                        if !((adult == "VERY_UNLIKELY" || adult == "UNLIKELY")&&(violence == "VERY_UNLIKELY" || violence == "UNLIKELY")){
                                            resultado = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                    
                    if let rowImage = self.view.viewWithTag(self.identificadorImagen) as? UIImageView{
                        
                        if resultado{
                            rowImage.image = pickedImage
                        }
                        else{
                            let alert = UIAlertController(title: "Aviso", message: "La imagen seleccionada no es un documento o se ha detectado contenido inapropiado, por favor intente con otra", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert,animated:true,completion:nil)
                        }
                        
                    }
                    
                })
                
            }
        }.resume()
        
    }
    
    
    
    
    
    
    
    
    
    
    @objc func enviarDatos(tapGestureRecognizer: UITapGestureRecognizer) {
        let urlOferta = "http://18.221.106.92/api/public/oferta/user"
        
        var mensaje = "No recibido"
        
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
                        print(json["message"])
                        if let msg = json["message"] as? String{
                            mensaje = msg
                        }
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        
                        if mensaje == "user data updated"{
                            self.enviarDocumentos()
                        }
                        else{
                            let alert = UIAlertController(title: "Aviso", message: "Hubo un problema al actualizar tus datos, intentalo nuevamente por favor", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title:"Aceptar",style: UIAlertActionStyle.default,handler: { action in
                                self.back(vista: self)
                            }))
                            
                            self.present(alert,animated:true,completion:nil)
                        }
                        
                    })
                    
                }
            }.resume()
            
            
        }
    }
    
    func enviarDocumentos() {
        
        if let rfc = view.viewWithTag(100) as? UIImageView,
            let ine = view.viewWithTag(101) as? UIImageView,
            let comprobante = view.viewWithTag(102) as? UIImageView,
            let edoCuenta = view.viewWithTag(103) as? UIImageView{
            
            if rfc.image == placeholderImage{
                documentoFaltante(documento: "CEDULA RFC SAT")
                return
            }
            if ine.image == placeholderImage{
                documentoFaltante(documento: "INE")
                return
            }
            if comprobante.image == placeholderImage{
                documentoFaltante(documento: "COMPROBANTE DE DOMICILIO")
                return
            }
            if edoCuenta.image == placeholderImage{
                documentoFaltante(documento: "ESTADO DE CUENTA BANCARIO")
                return
            }
            
            let alert = UIAlertController(title: "Confirmar ", message: "¿Estas seguro que deseas enviar estos documentos?", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "No", style: .default))
            
            
            alert.addAction(UIAlertAction(title:"Si",style: UIAlertActionStyle.default,handler: { action in
                
                //integrar aqui servicio para enviar documentos a salesforce
                
                self.enviarOferta()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Aviso", message: "Hubo un problema al verificar los documentos, por favor intente mas tarde", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated:true,completion:nil)
        }
        
        
    }
    
    func documentoFaltante(documento: String){
        let alert = UIAlertController(title: "Aviso", message: "Por favor carga tu "+documento, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }
    
    
    func enviarOferta (){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        self.view.addSubview(background)
        activityIndicator.startAnimating()
        
        var respuesta = "Respuesta no recibida"
        
        let urlOferta = "http://18.221.106.92/api/public/oferta"
        
        
        let parameters: [String:Any?] = instanciaCarritoController.datosoferta
        
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
                
                OperationQueue.main.addOperation({
                    
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                    
                    if respuesta == "Se trasladaron correctamente las propiedades"{
                        instanciaCarritoController.inicio()
                        
                        let alert = UIAlertController(title: "¡Datos enviados!", message: "A partir de ahora tu OFERTA estará sujeta en proceso de Aprobación.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title:"Aceptar",style: UIAlertActionStyle.default,handler: { action in
                            instanciaMisInversionesController.solicitarOfertas()
                            self.back(vista: self)
                        }))
                        
                        self.present(alert,animated:true,completion:nil)
                    }
                    else{
                        let alert = UIAlertController(title: "Aviso", message: "Hubo un problema al enviar su oferta, intentelo mas tarde por favor", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title:"Aceptar",style: UIAlertActionStyle.default,handler: { action in
                            self.back(vista: self)
                        }))
                        
                        self.present(alert,animated:true,completion:nil)
                    }

                
                })
                
            }
        }.resume()
            
        
        
    }
    
    
    
    @objc func cancelProcess(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }
    
}
