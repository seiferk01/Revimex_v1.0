//
//  DocumentosInversionistaController.swift
//  Revimex
//
//  Created by Hector Morales on 05/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import AVFoundation
import Photos.PHPhotoLibrary

class DocumentosInversionistaController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    
    class addImageGestureRecognizer: UITapGestureRecognizer {
        var imageTag: Int!
        var nombrerDocumento: String!
    }
    
    let imagePicker = UIImagePickerController()
    var identificadorImagen:Int = -1
    
    var placeholderImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        placeholderImage = UIImage.fontAwesomeIcon(name: .camera,textColor: UIColor.black,size: CGSize(width: 80, height: 80))
        
        cargarDocumentos()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func cargarDocumentos(){
        
        view.addSubview(rowDocumento(documento: "CÉDULA RFC SAT", posicion: 0))
        view.addSubview(rowDocumento(documento: "INE", posicion: 1))
        view.addSubview(rowDocumento(documento: "COMPROBANTE DE DOMICILIO", posicion: 2))
        view.addSubview(rowDocumento(documento: "ESTADO DE CUENTA BANCARIO", posicion: 3))
        
        let enviar = UITapGestureRecognizer(target: self, action: #selector(enviarDocumentos(tapGestureRecognizer:)))
        let continuar = UIButton()
        continuar.frame = CGRect(x:ancho/4, y:largo*0.9, width: ancho/2, height: largo*0.06)
        continuar.setTitle("Enviar y Continuar", for: .normal)
        continuar.setTitleColor(UIColor.black, for: .normal)
        continuar.layer.borderColor = UIColor.black.cgColor
        continuar.layer.borderWidth = 0.5
        continuar.addGestureRecognizer(enviar)
        
        view.addSubview(continuar)
        
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
    
    
    //funcion para registrar el avance del brokerage, sen envia el estatus "documentos_usuario" y la propiedad queda en estatus "Documentos de usuario registrado"
    @objc func enviarDocumentos(tapGestureRecognizer: UITapGestureRecognizer) {
        
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
            
            let estatus = "documentos_usuario"
            
            let alert = UIAlertController(title: "Confirmar ", message: "¿Estas seguro que deseas enviar estos documentos?", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "No", style: .default))
            
            
            alert.addAction(UIAlertAction(title:"Si",style: UIAlertActionStyle.default,handler: { action in
                
                //integrar aqui servicio para enviar documentos a salesforce
                
                let alertValidacion = UIAlertController(title: "Aviso ", message: "Gracias, se han registrado tus documentos con éxito. A partir de ahora empezará el proceso de validación de tus documentos. Te notificaremos cuando esten validados para que puedas realizar el pago.", preferredStyle: UIAlertControllerStyle.alert)
                alertValidacion.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertValidacion, animated: true, completion: nil)
                
                instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
                
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
    

}
