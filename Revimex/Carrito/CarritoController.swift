//
//  CarritoController.swift
//  Revimex
//
//  Created by Seifer on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
import Motion

class CarritoController: UIViewController,UITableViewDataSource {
    
    var anchoPantalla = CGFloat(0)
    var largoPantalla = CGFloat(0)
    
    @IBOutlet weak var tituloCarrito: UILabel!
    @IBOutlet weak var contenedorTotales: UIView!
    @IBOutlet weak var tablaCarritos: UITableView!
    
    
    let subtotal = UILabel()
    let total = UILabel()
    let totalOferta = UILabel()
    let subtotalMonto = UILabel()
    let totalMonto = UILabel()
    let totalMontoOferta = UILabel()
    let tituloOferta = UILabel()
    let labelOferta = UILabel()
    let buttonContainer = UIButton()
    let sliderOferta = UISlider()
    let continuarBtn = UIButton()
    
    var totalPago = "0"
    var totalOfertado = "0"
    
    var datosoferta:[String:Any?] = [:]
    
    var arrayCarritos = [Carrito]()
    
    class goToDetailsGestureRecognizer: UITapGestureRecognizer {
        var idPropiedad: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instanciaCarritoController = self
        
        
        inicio()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.navigationController != nil{
            self.setCustomBackgroundAndNavbar()
        }
        else{
            let regresarPagina = UITapGestureRecognizer(target: self, action: #selector(back(tapGestureRecognizer:)))
            let regresar = UIButton()
            regresar.setBackgroundImage(UIImage(named: "backBtn.png"), for: .normal)
            regresar.frame = CGRect(x:0,y: 20,width:view.bounds.width*0.15,height:view.bounds.width*0.15)
            regresar.addGestureRecognizer(regresarPagina)
            view.addSubview(regresar)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named:"fondo.png")!)
        }
        
    }
    
    
    func inicio(){
        
        if self.navigationController != nil{
            self.setCustomBackgroundAndNavbar()
        }
        else{
            let regresarPagina = UITapGestureRecognizer(target: self, action: #selector(back(tapGestureRecognizer:)))
            let regresar = UIButton()
            regresar.setBackgroundImage(UIImage(named: "backBtn.png"), for: .normal)
            regresar.frame = CGRect(x:0,y: 20,width:view.bounds.width*0.15,height:view.bounds.width*0.15)
            regresar.addGestureRecognizer(regresarPagina)
            view.addSubview(regresar)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named:"fondo.png")!)
        }
        
        tituloCarrito.isHidden = true
        contenedorTotales.isHidden = true
        tablaCarritos.isHidden = true
        
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
    
    
    func crearVista(){
        
        contenedorTotales.backgroundColor = .clear
        
        subtotal.backgroundColor = UIColor.white
        subtotal.text = "Subtotal"
        subtotal.textAlignment = NSTextAlignment.center
        subtotal.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        total.backgroundColor = UIColor.white
        total.text = "Total"
        total.textAlignment = NSTextAlignment.center
        total.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        totalOferta.backgroundColor = UIColor.white
        totalOferta.text = "Total Oferta"
        totalOferta.textAlignment = NSTextAlignment.center
        totalOferta.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        subtotalMonto.backgroundColor = UIColor.white
        subtotalMonto.text = "$0"
        subtotalMonto.textAlignment = NSTextAlignment.center
        subtotalMonto.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        totalMonto.backgroundColor = UIColor.white
        totalMonto.text = "$0"
        totalMonto.textAlignment = NSTextAlignment.center
        totalMonto.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        totalMontoOferta.backgroundColor = UIColor.white
        totalMontoOferta.text = "$0"
        totalMontoOferta.textAlignment = NSTextAlignment.center
        totalMontoOferta.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        tituloOferta.text = "Ofertar por:"
        tituloOferta.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        labelOferta.text = "100%"
        labelOferta.textAlignment = .center
        labelOferta.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        sliderOferta.minimumValue = 50
        sliderOferta.maximumValue = 100
        sliderOferta.isContinuous = true
        sliderOferta.tintColor = azul
        sliderOferta.addTarget(self, action: #selector(sliderValueDidChangeSliderOferta(_:)), for: .valueChanged)
        
        buttonContainer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let continuar = UITapGestureRecognizer(target: self, action: #selector(continuarProceso(tapGestureRecognizer:)))
        continuarBtn.layer.borderWidth = 1
        continuarBtn.layer.borderColor = UIColor.black.cgColor
        continuarBtn.layer.backgroundColor = UIColor.white.cgColor
        continuarBtn.setTitle("Continuar", for: .normal)
        continuarBtn.setTitleColor(UIColor.black, for: .normal)
        continuarBtn.addGestureRecognizer(continuar)
        
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
                        
                        self.datosoferta = ["propiedades":dat]
                        
                        for element in dat {
                            if let carrito = element as? NSDictionary{
                                print("************Empieza Carrito************")
                                print(carrito)
                                
                                let objectCarrito = Carrito(idPropiedad: "", estado: "", municipio: "", colonia: "", precio: "", fechaAgregado: "", total: "", foto: UIImage(named: "imagenNoEncontrada.png")!)
                                
                                if let created = carrito["created_at"] as? String{
                                    objectCarrito.fechaAgregado = created
                                }
                                
                                if let idPropiedad = carrito["propiedad_id"] as? Int{
                                    objectCarrito.idPropiedad = String(idPropiedad)
                                }
                                
                                if let carritoPropiedad = carrito["propiedades"] as? NSArray{
                                    for propiedad in carritoPropiedad{
                                        if let atributoPropiedad = propiedad as? NSDictionary{
                                            if let estado = atributoPropiedad["Estado__c"] as? String{
                                                objectCarrito.estado = estado
                                            }
                                            
                                            if let municipio = atributoPropiedad["Municipio__c"] as? String{
                                                objectCarrito.municipio = municipio
                                            }
                                            
                                            if let colonia = atributoPropiedad["Colonia__c"] as? String{
                                                objectCarrito.colonia = colonia
                                            }
                                            if let precio = atributoPropiedad["ValorReferencia__c"] as? Int{
                                                objectCarrito.precio = String(precio)
                                            }
                                            if let total = atributoPropiedad["totalPropiedad"] as? String{
                                                objectCarrito.total = total
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
                        self.tablaCarritos.isHidden = false
                        
                        if let labelSinCarritos = self.view.viewWithTag(101){
                            labelSinCarritos.removeFromSuperview()
                        }
                    }
                    else{
                        self.tituloCarrito.isHidden = true
                        self.contenedorTotales.isHidden = true
                        self.tablaCarritos.isHidden = true
                        
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
        totalMontoOferta.text = "$"+totalPago
        
        labelOferta.text = "100%"
        subtotal.frame = CGRect(x:0,y:0,width:ancho/2,height:largo*0.15)
        total.frame = CGRect(x:0,y:largo*0.15,width:ancho/2,height:largo*0.15)
        totalOferta.frame = CGRect(x:0,y:largo*0.3,width:ancho/2,height:largo*0.15)
        subtotalMonto.frame = CGRect(x:ancho/2,y:0,width:ancho/2,height:largo*0.15)
        totalMonto.frame = CGRect(x:ancho/2,y:largo*0.15,width:ancho/2,height:largo*0.15)
        totalMontoOferta.frame = CGRect(x:ancho/2,y:largo*0.3,width:ancho/2,height:largo*0.15)
        buttonContainer.frame = CGRect(x:0,y:largo*0.45,width:ancho,height:largo*0.55)
        tituloOferta.frame = CGRect(x:0,y:0,width:ancho*0.8,height:buttonContainer.bounds.height*0.2)
        sliderOferta.frame = CGRect(x:ancho*0.05,y:buttonContainer.bounds.height*0.2,width:ancho*0.8,height:buttonContainer.bounds.height*0.4)
        labelOferta.frame = CGRect(x:ancho*0.85,y:buttonContainer.bounds.height*0.2,width:ancho*0.15,height:buttonContainer.bounds.height*0.4)
        continuarBtn.frame = CGRect(x:ancho*0.25,y:buttonContainer.bounds.height*0.6 + 1,width:ancho*0.5,height:buttonContainer.bounds.height*0.4 - 6)
        
        buttonContainer.addSubview(tituloOferta)
        buttonContainer.addSubview(sliderOferta)
        buttonContainer.addSubview(labelOferta)
        
        contenedorTotales.addSubview(totalOferta)
        contenedorTotales.addSubview(totalMontoOferta)
        
        if arrayCarritos.count == 1{
            
            let alert = UIAlertController(title: "¿Cual es su forma de pago?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Contado", style: .default))
            
            
            alert.addAction(UIAlertAction(title:"Credito",style: UIAlertActionStyle.default,handler: { action in
                
                //Proceso para iniciar clinte final
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        contenedorTotales.addSubview(subtotal)
        contenedorTotales.addSubview(total)
        contenedorTotales.addSubview(subtotalMonto)
        contenedorTotales.addSubview(totalMonto)
        contenedorTotales.addSubview(buttonContainer)
        buttonContainer.addSubview(continuarBtn)
        
    }
    
    @objc func sliderValueDidChangeSliderOferta(_ sender:UISlider!){

        sender.value = round(sender.value)
        labelOferta.text = String(format: "%.0f", round(sender.value))+"%"
        let unoPorciento = (totalPago.replacingOccurrences(of: ",", with: "") as NSString).doubleValue / 100
        let porcentaje = unoPorciento * Double(round(sender.value))
        totalOfertado = String(porcentaje)
        totalMontoOferta.text = "$"+String(format: "%.2f", porcentaje)
        
        
    }
    
    //********************************funciones de la tabla***************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCarritos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCarritos = tableView.dequeueReusableCell(withIdentifier: "cellCarritos") as! CarritoCellController
        cellCarritos.idOfertaActual = arrayCarritos[indexPath.row].idPropiedad
        cellCarritos.direccion.text = arrayCarritos[indexPath.row].estado+" "+arrayCarritos[indexPath.row].municipio+" "+arrayCarritos[indexPath.row].colonia
        cellCarritos.precio.text = arrayCarritos[indexPath.row].precio
        cellCarritos.desalojo.text = "$20,000"
        cellCarritos.total.text = arrayCarritos[indexPath.row].total
        cellCarritos.foto.image = arrayCarritos[indexPath.row].foto
        cellCarritos.foto.contentMode = .scaleAspectFill
        cellCarritos.foto.clipsToBounds = true
        
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
    
    @objc func back(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }
    
    @objc func continuarProceso(tapGestureRecognizer: UITapGestureRecognizer) {
        
        datosoferta["total_oferta"] = totalOfertado
        datosoferta["total"] = totalPago
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nuevaInversionCtrl = storyboard.instantiateViewController(withIdentifier: "datosInversionista") as! DatosInversionistaController
        self.present(nuevaInversionCtrl, animated: true, completion: nil)
    }
    
}

