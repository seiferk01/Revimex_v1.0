//
//  PropiedadesInversionistaController.swift
//  Revimex
//
//  Created by Seifer on 14/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class PropiedadesInversionistaController: UIViewController {

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    
    var arrayPropiedadesOferta:[PropiedadInversionista] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = instanciaEtapasInversionistaController.vistasContainer.frame
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        
        traerPropiedades()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func traerPropiedades(){
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayPropiedadesOferta = []
        
        let urlRequestFiltros = "http://18.221.106.92/api/public/inversionista/lista"
        
        var userId = ""
        
        if let user = UserDefaults.standard.object(forKey: "userId") as? Int{
            userId = String(user)
        }
        
        let parameters: [String:Any] = [
            "oferta_id": instanciaMisInversionesController.ofertaSeleccionada,
            "user_id": userId
        ]
        
        print(parameters)
        
        guard let url = URL(string: urlRequestFiltros) else { return }
        
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
                    
                    if let data = json["data"] as? NSArray{
                        for elementoData in data{
                            if let elemento = elementoData as? NSDictionary{
                                if let propiedades = elemento["propiedades"] as? NSArray{
                                    for prop in propiedades{
                                        if let propiedad = prop as? NSDictionary{
                                            
                                            let propiedadInversion = PropiedadInversionista()
                                            
                                            if let Estado = propiedad["Estado__c"] as? String{
                                                propiedadInversion.Estado__c  = Estado
                                            }
                                            if let Plaza = propiedad["Plaza__c"] as? String{
                                                propiedadInversion.Plaza__c  = Plaza
                                            }
                                            if let Colonia = propiedad["Colonia__c"] as? String{
                                                propiedadInversion.Colonia__c  = Colonia
                                            }
                                            if let Valor = propiedad["ValorReferencia__c"] as? String{
                                                propiedadInversion.ValorReferencia__c  = Valor
                                            }
                                            if let total = propiedad["totalPropiedad"] as? String{
                                                propiedadInversion.totalPropiedad  = total
                                            }
                                            if let url = propiedad["url_imagen"] as? String{
                                                propiedadInversion.url_imagen  = url
                                            }
                                            
                                            self.arrayPropiedadesOferta.append(propiedadInversion)
                                            
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
                    self.vista()
                })
                
            }
        }.resume()

    }
    
    
    func vista(){
        
        
        let contenedorPropiedades = UIScrollView()
        
        contenedorPropiedades.frame = CGRect(x:0, y:0, width:ancho, height:largo*0.85)
        let largoContenido = (largo*0.25) * CGFloat(arrayPropiedadesOferta.count)
        contenedorPropiedades.contentSize = CGSize(width: ancho, height: largoContenido)
        contenedorPropiedades.layer.borderColor = gris?.cgColor
        contenedorPropiedades.layer.borderWidth = 0.3
        
        for (index, propiedad) in arrayPropiedadesOferta.enumerated() {
            
            let celda = UIView()
            celda.frame = CGRect(x:-0.5, y:(largo*0.25) * CGFloat(index), width: ancho+1, height:(largo*0.25))
            
            celda.layer.masksToBounds = true
            celda.layer.borderWidth = 0.2
            celda.layer.shadowOffset = CGSize(width: -1, height: 0.2)
            let borderColor: UIColor = gris!
            celda.layer.borderColor = borderColor.cgColor
            
            let anchoCelda = celda.frame.width
            let largoCelda = celda.frame.height
            
            
            let foto = UIImageView(image: UIImage(named: "imagenNoEncontrada.png"))
            foto.frame = CGRect(x:0, y:4, width: anchoCelda*0.3, height:largoCelda-2)
            foto.contentMode = .scaleAspectFit
            foto.clipsToBounds = true
            
            DispatchQueue.global(qos: .userInitiated).async {
                let fotoPropiedad = Utilities.traerImagen(urlImagen: propiedad.url_imagen)
                DispatchQueue.main.async {
                    foto.image = fotoPropiedad
                    if !(propiedad.url_imagen.isEmpty){
                        foto.contentMode = .scaleAspectFill
                    }
                }
            }
            
            let direccion = UILabel()
            direccion.frame = CGRect(x:anchoCelda*0.35, y:0, width: anchoCelda*0.6, height: largoCelda*0.2)
            direccion.font = UIFont(name: "Marion-Italic", size: 12.0)
            direccion.numberOfLines = 2
            direccion.textColor = gris
            direccion.text = propiedad.Estado__c + " " + propiedad.Plaza__c + " " + propiedad.Colonia__c
            
            let precioPropiedad = TextField()
            precioPropiedad.frame = CGRect(x:anchoCelda*0.35, y:largoCelda*0.3, width: anchoCelda*0.6, height:(largoCelda*0.25)/2)
            precioPropiedad.placeholder = "Precio"
            precioPropiedad.text = propiedad.ValorReferencia__c
            precioPropiedad.isEnabled = false
            precioPropiedad.placeholderLabel.textColor = azulObscuro
            precioPropiedad.textAlignment = .center
            
            let desalojoPropiedad = TextField()
            desalojoPropiedad.frame = CGRect(x:anchoCelda*0.35, y:largoCelda*0.55, width: anchoCelda*0.6, height:(largoCelda*0.25)/2)
            desalojoPropiedad.placeholder = "Desalojo"
            desalojoPropiedad.text = propiedad.desalojo
            desalojoPropiedad.isEnabled = false
            desalojoPropiedad.placeholderLabel.textColor = azulObscuro
            desalojoPropiedad.textAlignment = .center
            
            let totalPropiedad = TextField()
            totalPropiedad.frame = CGRect(x:anchoCelda*0.35, y:largoCelda*0.8, width: anchoCelda*0.6, height:(largoCelda*0.25)/2)
            totalPropiedad.placeholder = "Total"
            totalPropiedad.text = propiedad.totalPropiedad
            totalPropiedad.isEnabled = false
            totalPropiedad.placeholderLabel.textColor = azulObscuro
            totalPropiedad.textAlignment = .center
            
            
            celda.addSubview(foto)
            celda.addSubview(direccion)
            celda.addSubview(precioPropiedad)
            celda.addSubview(desalojoPropiedad)
            celda.addSubview(totalPropiedad)
            
            contenedorPropiedades.addSubview(celda)
        }
        
        
        let btnContinuar = UIButton()
        btnContinuar.frame = CGRect(x:ancho/3 ,y:largo*0.9 ,width:ancho/3 ,height:largo*0.07 )
        btnContinuar.setTitle("Continuar", for: .normal)
        btnContinuar.setTitleColor(UIColor.black, for: .normal)
        btnContinuar.layer.borderWidth = 0.5
        btnContinuar.layer.borderColor = UIColor.black.cgColor
        
        
        view.addSubview(contenedorPropiedades)
        view.addSubview(btnContinuar)
        
        
    }
    


}
