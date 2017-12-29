//
//  CarritoController.swift
//  Revimex
//
//  Created by Seifer on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class CarritoController: UIViewController,UITableViewDataSource {
    
    var anchoPantalla = CGFloat(0)
    var largoPantalla = CGFloat(0)
    
    @IBOutlet weak var tituloCarrito: UILabel!
    @IBOutlet weak var contenedorTotales: UIView!
    @IBOutlet weak var tablaCarritos: UITableView!
    
    
    let subtotal = UILabel()
    let total = UILabel()
    let subtotalMonto = UILabel()
    let totalMonto = UILabel()
    let buttonContainer = UIButton()
    let continuarBtn = UIButton()
    
    var totalPago: String = "0"
    
    var arrayCarritos = [Carrito]()
    
    class goToDetailsGestureRecognizer: UITapGestureRecognizer {
        var idPropiedad: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()
        instanciaCarritoController = self
        
        tituloCarrito.isHidden = true
        contenedorTotales.isHidden = true
        
        crearVista()
        
        anchoPantalla = view.bounds.width
        largoPantalla = view.bounds.height
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            mostrarCarritos(userId: userId)
        }
        else{
            solicitarRegistro()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
        
    }
    
    func crearVista(){
        
        contenedorTotales.backgroundColor = .clear
        
        subtotal.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        subtotal.text = "Subtotal"
        subtotal.textAlignment = NSTextAlignment.center
        subtotal.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        total.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        total.text = "Total"
        total.textAlignment = NSTextAlignment.center
        total.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        subtotalMonto.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        subtotalMonto.text = "$"+totalPago
        subtotalMonto.textAlignment = NSTextAlignment.center
        subtotalMonto.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        totalMonto.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        totalMonto.text = "$"+totalPago
        totalMonto.textAlignment = NSTextAlignment.center
        totalMonto.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        buttonContainer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        continuarBtn.layer.borderWidth = 1
        continuarBtn.layer.borderColor = UIColor.black.cgColor
        continuarBtn.setTitle("Continuar", for: .normal)
        continuarBtn.setTitleColor(UIColor.black, for: .normal)
        
        contenedorTotales.addSubview(subtotal)
        contenedorTotales.addSubview(total)
        contenedorTotales.addSubview(subtotalMonto)
        contenedorTotales.addSubview(totalMonto)
        contenedorTotales.addSubview(buttonContainer)
        buttonContainer.addSubview(continuarBtn)
        
    }
    
    
    func mostrarCarritos(userId: Int){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayCarritos = []
        
        let urlCarritos =  "http://18.221.106.92/api/public/cart/" + String(userId)
        
        guard let url = URL(string: urlCarritos) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! NSDictionary
                    print(json)
                    if let total = json["total"] as? String{
                        self.totalPago = total
                    }
                    if let dat = json["data"] as? NSArray {
                        
                        for element in dat {
                            if let carrito = element as? NSDictionary{
                                print("************Empieza Carrito************")
                                print(carrito)
                                
                                let objectCarrito = Carrito(idPropiedad: "", estado: "", precio: "", referencia: "", fechaAgregado: "", foto: UIImage(named: "imagenNoEncontrada.png")!, urlPropiedad: "")
                                
                                if let created = carrito["created_at"] as? String{
                                    objectCarrito.fechaAgregado = created
                                }
                                
                                if let idPropiedad = carrito["propiedad_id"] as? Int{
                                    objectCarrito.idPropiedad = String(idPropiedad)
                                }
                                
                                if let favoritoPropiedad = carrito["propiedades"] as? NSArray{
                                    for propiedad in favoritoPropiedad{
                                        if let atributoPropiedad = propiedad as? NSDictionary{
                                            if let estado = atributoPropiedad["Estado__c"] as? String{
                                                objectCarrito.estado = estado
                                            }
                                            if let precio = atributoPropiedad["ValorReferencia__c"] as? String{
                                                objectCarrito.precio = precio
                                            }
                                            if let referencia = atributoPropiedad["Referencia"] as? String{
                                                objectCarrito.referencia = referencia
                                            }
                                            if let urlPropiedad = atributoPropiedad["url_propiedad"] as? String{
                                                objectCarrito.urlPropiedad = urlPropiedad
                                            }
                                            if let urlImagen = atributoPropiedad["url_imagen"] as? String{
                                                objectCarrito.foto = Utilities.traerImagen(urlImagen: urlImagen)
                                            }
                                        }
                                    }
                                }
                                
                                self.arrayCarritos.append(objectCarrito)
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }catch {
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    if self.arrayCarritos.count > 0 {
                        self.tituloCarrito.isHidden = false
                        self.contenedorTotales.isHidden = false
                        
                        if let labelSinCarritos = self.view.viewWithTag(101){
                            labelSinCarritos.removeFromSuperview()
                        }
                    }
                    else{
                        self.tituloCarrito.isHidden = true
                        self.contenedorTotales.isHidden = true
                        
                        let sinCarritos = UILabel()
                        sinCarritos.text = "Aun no hay propiedades en el carrito"
                        sinCarritos.textColor = UIColor.white
                        sinCarritos.textAlignment = NSTextAlignment.center
                        sinCarritos.font = UIFont.boldSystemFont(ofSize: 20.0)
                        sinCarritos.frame = CGRect(x:0,y:0,width:self.anchoPantalla,height:self.largoPantalla * (0.8))
                        sinCarritos.center = self.view.bounds.center
                        sinCarritos.tag = 101
                        self.view.addSubview(sinCarritos)
                    }
                    self.tablaCarritos.reloadData()
                    self.mostrarMisCarritos()
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
        }.resume()
    }
    
    func mostrarMisCarritos(){
        
        let ancho = contenedorTotales.bounds.width
        let largo = contenedorTotales.bounds.height
        
        subtotalMonto.text = "$"+totalPago
        totalMonto.text = "$"+totalPago
        
        if arrayCarritos.count > 1{
            
        }
        else{
            
            subtotal.frame = CGRect(x:0,y:0,width:ancho/2,height:largo*0.3)
            total.frame = CGRect(x:0,y:largo*0.3 + 1,width:ancho/2,height:largo*0.3)
            subtotalMonto.frame = CGRect(x:ancho/2,y:0,width:ancho/2,height:largo*0.3)
            totalMonto.frame = CGRect(x:ancho/2,y:largo*0.3 + 1,width:ancho/2,height:largo*0.3)
            buttonContainer.frame = CGRect(x:0,y:largo*0.6 + 2,width:ancho,height:largo*0.4)
            continuarBtn.frame = CGRect(x:ancho*0.25,y:buttonContainer.bounds.height*0.2,width:ancho*0.5,height:buttonContainer.bounds.height*0.6)
        }
        
        
    }
    
    //********************************funciones de la tabla***************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCarritos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCarritos = tableView.dequeueReusableCell(withIdentifier: "cellCarritos") as! CarritoCellController
        cellCarritos.precio.text = arrayCarritos[indexPath.row].precio
        print(indexPath.row)
        
        
        return cellCarritos
    }
    
    
    func solicitarRegistro(){
        let contenedorInfo = UIView()
        contenedorInfo.frame = CGRect(x: anchoPantalla * (0.1), y: (largoPantalla * (0.08)), width: anchoPantalla * (0.8), height: largoPantalla * (0.8))
        
        let notLoggedMessage = UILabel()
        notLoggedMessage.numberOfLines = 2
        notLoggedMessage.text = "Inicia sesion en Revimex \n para mostrar el contenido de tu carrito"
        notLoggedMessage.textColor = UIColor.white
        notLoggedMessage.textAlignment = NSTextAlignment.center
        notLoggedMessage.font = UIFont.boldSystemFont(ofSize: 20.0)
        notLoggedMessage.frame = CGRect(x:0,y:0,width:anchoPantalla,height:largoPantalla * (0.8))
        notLoggedMessage.center = contenedorInfo.bounds.center
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mostrarLogin(tapGestureRecognizer:)))
        let loginBtn = UIButton()
        loginBtn.frame = CGRect(x: anchoPantalla * (0.15), y: largoPantalla * (0.8), width: anchoPantalla * (0.7), height: largoPantalla * (0.06))
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.white.cgColor
        loginBtn.setTitle("Registrarse", for: .normal)
        loginBtn.addGestureRecognizer(tapGestureRecognizer)
        
        contenedorInfo.addSubview(notLoggedMessage)
        view.addSubview(contenedorInfo)
        view.addSubview(loginBtn)
        view.sendSubview(toBack: contenedorInfo)
    }
    
    
    @objc func mostrarLogin(tapGestureRecognizer: UITapGestureRecognizer){
        print("fue a login")
        navBarStyleCase = 2
        performSegue(withIdentifier: "carritoToLogin", sender: nil)
    }
    
    
    @objc func irDetalles(tapGestureRecognizer: goToDetailsGestureRecognizer){
        print(tapGestureRecognizer.idPropiedad!)
        idOfertaSeleccionada = tapGestureRecognizer.idPropiedad!
        performSegue(withIdentifier: "carritoToDetails", sender: nil)
    }
    
}

