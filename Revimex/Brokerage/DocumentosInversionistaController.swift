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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        
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
        preview.image = UIImage.fontAwesomeIcon(name: .camera,textColor: UIColor.black,size: CGSize(width: 80, height: 80))
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let rowImage = view.viewWithTag(identificadorImagen) as? UIImageView{
            rowImage.image = image
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func enviarDocumentos(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let estatus = "documentos_usuario"
        
        let alert = UIAlertController(title: "Confirmar ", message: "¿Estas seguro que deseas enviar estos documentos?", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default))
        
        
        alert.addAction(UIAlertAction(title:"Si",style: UIAlertActionStyle.default,handler: { action in
            
            //integrar aqui servicio para enviar documentos a salesforce
            
            instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

}
