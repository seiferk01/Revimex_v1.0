//
//  EtapasBrokerageController.swift
//  Revimex
//
//  Created by Seifer on 30/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class EtapasBrokerageController: UIViewController {

    var ancho = CGFloat()
    var largo = CGFloat()
    
    var background = UIView()

    var barraNavegacion = UIView()
    
    let descripcion = UIView()
    let foto = UIImageView()
    let tipoInmueble = TextField()
    let precio = TextField()
    let estado = TextField()
    let municipio = TextField()
    
    
    
    var contenedorVistas = UIView()
    
    var arrayViews:[UIViewController?]!;
    
    private var actualViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    var detallesPropiedad:UIViewController?
    var datosUsuario:UIViewController?
    var cargaDocumentos:UIViewController?
    var validacionDocumentos:UIViewController?
    var realizarPago:UIViewController?
    var firmaContrato:UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instanciaEtapasBrokerageController = self
        
        
        detallesPropiedad = storyboard?.instantiateViewController(withIdentifier: "BrokerageDetallesPropiedad") as! DetallesPropiedadController
        datosUsuario = storyboard?.instantiateViewController(withIdentifier: "BrokerageDatosUsuarioInversionista") as! DatosUsuarioInversionistaController
        cargaDocumentos = storyboard?.instantiateViewController(withIdentifier: "BrokerageDocumentosInversionista") as! DocumentosInversionistaController
        validacionDocumentos = storyboard?.instantiateViewController(withIdentifier: "BrokerageValidarDocumentos") as! ValidacionDocumentosController
        realizarPago = storyboard?.instantiateViewController(withIdentifier: "BrokerageRealizarPago") as! RealizarPagoController
        firmaContrato = storyboard?.instantiateViewController(withIdentifier: "BrokerageFirmaContrato") as! FirmaContratoController
        
        arrayViews = [detallesPropiedad,datosUsuario,cargaDocumentos,validacionDocumentos,realizarPago,firmaContrato]
        
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.tag = 100
        view.addSubview(visualEffectView)
        view.sendSubview(toBack: visualEffectView)
        
        initiCabecera()
        requestDetails()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initiCabecera(){
        barraNavegacion.frame = CGRect(x:0, y:0, width: ancho, height: largo*0.08)
        
        let cancelarProceso = UITapGestureRecognizer(target: self, action: #selector(cancelProcess(tapGestureRecognizer:)))
        let cancelar = UIButton()
        cancelar.setTitle("Regresar", for: .normal)
        cancelar.setTitleColor(UIColor.white, for: .normal)
        cancelar.frame = CGRect(x:0, y:0, width: ancho*0.25, height: barraNavegacion.bounds.height + 25)
        cancelar.addGestureRecognizer(cancelarProceso)
        
        
        descripcion.frame = CGRect(x:0, y:barraNavegacion.bounds.height, width: ancho, height: largo*0.27)
        
        let anchoDescripcion = descripcion.bounds.width
        let largoDescripcion = descripcion.bounds.height
        
        let titulo = UILabel()
        titulo.text = "Registra tu nuevo Brokerage"
        titulo.textColor = UIColor.white
        titulo.textAlignment = .center
        titulo.frame = CGRect(x:0, y:0, width: anchoDescripcion, height: largoDescripcion*0.1)
        
        
        foto.image = UIImage(named: "imagenNoEncontrada.png")
        foto.frame = CGRect(x:0, y:largoDescripcion*0.2, width: anchoDescripcion*0.3, height: largoDescripcion*0.8)
        foto.contentMode = .scaleAspectFit
        foto.clipsToBounds = true
        
        
        estado.frame = CGRect(x:anchoDescripcion*0.35, y:largoDescripcion*0.3, width: anchoDescripcion*0.6, height: (largoDescripcion*0.25)/2)
        estado.placeholder = "Estado"
        estado.textColor = UIColor.white
        estado.font = UIFont.fontAwesome(ofSize: 12.0)
        estado.isEnabled = false
        estado.placeholderLabel.textColor = UIColor.white
        
        
        municipio.frame = CGRect(x:anchoDescripcion*0.35, y:largoDescripcion*0.55, width: anchoDescripcion*0.6, height: (largoDescripcion*0.25)/2)
        municipio.placeholder = "Municipio"
        municipio.textColor = UIColor.white
        municipio.font = UIFont.fontAwesome(ofSize: 12.0)
        municipio.isEnabled = false
        municipio.placeholderLabel.textColor = UIColor.white
        
        
        tipoInmueble.frame = CGRect(x:anchoDescripcion*0.35, y:largoDescripcion*0.8, width: anchoDescripcion*0.28, height: (largoDescripcion*0.25)/2)
        tipoInmueble.placeholder = "Tipo de Inmueble"
        tipoInmueble.textColor = UIColor.white
        tipoInmueble.font = UIFont.fontAwesome(ofSize: 12.0)
        tipoInmueble.isEnabled = false
        tipoInmueble.placeholderLabel.textColor = UIColor.white
        
        
        precio.frame = CGRect(x:anchoDescripcion*0.67, y:largoDescripcion*0.8, width: anchoDescripcion*0.28, height: (largoDescripcion*0.25)/2)
        precio.placeholder = "Precio"
        precio.textColor = UIColor.white
        precio.font = UIFont.fontAwesome(ofSize: 12.0)
        precio.isEnabled = false
        precio.placeholderLabel.textColor = UIColor.white
        
        
        contenedorVistas.frame = CGRect(x:0, y:(largo*0.35), width: ancho, height: largo*0.65)
        contenedorVistas.backgroundColor = UIColor.white
        
        barraNavegacion.addSubview(cancelar)
        
        descripcion.addSubview(titulo)
        descripcion.addSubview(foto)
        descripcion.addSubview(tipoInmueble)
        descripcion.addSubview(precio)
        descripcion.addSubview(estado)
        descripcion.addSubview(municipio)
        
        view.addSubview(barraNavegacion)
        view.addSubview(descripcion)
        view.addSubview(contenedorVistas)
        
    }
    
    
    //llamado a los detalles de la propiedad seleccionada
    func requestDetails() {
        
        propiedad = Details(Id: "",calle: "",colonia: "",construccion: "",cp: "",estacionamiento: "",estado: "",habitaciones: "",idp: "",lat: "0",lon: "0",municipio: "",niveles: "",origen_propiedad: "",patios: "",precio: "",terreno: "",tipo: "",descripcion: "",pros: "",wcs: "",fotos: [])
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        let urlRequestDetails = "http://18.221.106.92/api/public/propiedades/detalle"
        
        let parameters = "id=" + idOfertaSeleccionada
        
        guard let url = URL(string: urlRequestDetails) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        let httpBody = parameters.data(using: .utf8)
        
        request.httpBody = httpBody
        
        let session  = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    if let propiedadSeleccionada = json["propiedad"] as? NSDictionary {
                        print("*********Propiedad seleccionada***********")
                        print(propiedadSeleccionada)
                        propiedad.fotos = []
                        
                        if  let id = propiedadSeleccionada["Id"] as? String { propiedad.Id = id }
                        if  let calle = propiedadSeleccionada["calle"] as? String { propiedad.calle = calle }
                        if  let colonia = propiedadSeleccionada["colonia"] as? String { propiedad.colonia = colonia }
                        if  let construccion = propiedadSeleccionada["construccion"] as? String { propiedad.construccion = construccion + "m2"}
                        if  let cp = propiedadSeleccionada["cp"] as? String { propiedad.cp = "C.P. " + cp }
                        if  let estacionamiento = propiedadSeleccionada["estacionamiento"] as? String { propiedad.estacionamiento = estacionamiento}
                        if  let estado = propiedadSeleccionada["estado"] as? String { propiedad.estado = estado }
                        if  let habitaciones = propiedadSeleccionada["habitaciones"] as? String { propiedad.habitaciones = habitaciones}
                        if  let idp = propiedadSeleccionada["idp"] as? String { propiedad.idp = idp }
                        if  let lat = propiedadSeleccionada["lat"] as? String,lat != "" { propiedad.lat = lat }
                        if  let lon = propiedadSeleccionada["lon"] as? String,lon != "" { propiedad.lon = lon }
                        if  let municipio = propiedadSeleccionada["municipio"] as? String { propiedad.municipio = municipio }
                        if  let niveles = propiedadSeleccionada["niveles"] as? String { propiedad.niveles = niveles }
                        if  let origen_propiedad = propiedadSeleccionada["origen_propiedad"] as? String { propiedad.origen_propiedad = origen_propiedad }
                        if  let patios = propiedadSeleccionada["patios"] as? String { propiedad.patios = patios}
                        if  let precio = propiedadSeleccionada["precio"] as? String { propiedad.precio = "$" + precio}
                        if  let terreno = propiedadSeleccionada["terreno"] as? String { propiedad.terreno = terreno + "m2"}
                        if  let tipo = propiedadSeleccionada["tipo"] as? String { propiedad.tipo = tipo}
                        if  let descripcion = propiedadSeleccionada["descripcion"] as? String { propiedad.descripcion = descripcion }
                        if  let pros = propiedadSeleccionada["pros"] as? String { propiedad.pros = pros }
                        if  let wcs = propiedadSeleccionada["wcs"] as? String { propiedad.wcs = wcs }
                        if  let files = propiedadSeleccionada["files"] as? Array<Any?> {
                            for element in files{
                                if let file = element as? NSDictionary {
                                    if  let linkPublico = file["linkPublico"]! as? String{
                                        propiedad.fotos.append(linkPublico)
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
                    
                    if propiedad.fotos.count > 0{
                        self.foto.image = Utilities.traerImagen(urlImagen: propiedad.fotos[0])
                    }
                    self.tipoInmueble.text = propiedad.tipo
                    self.precio.text = propiedad.precio
                    self.estado.text = propiedad.estado
                    self.municipio.text = propiedad.municipio
                    
                    let contenedorImagen = UIImageView(image: self.foto.image)
                    contenedorImagen.frame = self.view.bounds
                    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                    visualEffectView.frame = self.view.bounds
                    visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    contenedorImagen.addSubview(visualEffectView)
                    self.view.addSubview(contenedorImagen)
                    self.view.sendSubview(toBack: contenedorImagen)
                    self.view.viewWithTag(100)?.removeFromSuperview()
                    
                    self.cargarVista()
                    
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                    
                })
                
            }
        }.resume()
        
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
            activeVC.view.frame = contenedorVistas.bounds;
            contenedorVistas.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    
    
    
    //para la navegacion del proceso lineal
    func mostrarEtapa(estatus: String){
        
        etapaBrokerage = estatus
        
        cargarVista()
        
        instanciaMisBrokerageViewController.solicitarBrokerages()
        
    }
    
    
    @objc func cancelProcess(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }
    
    //muestra la vista correspondiente al estatus en el que se encuentra el brokerage
    func cargarVista(){
        
         print(etapaBrokerage)
        
        switch etapaBrokerage {
        case "DatosPropiedad":
            
            actualViewController = arrayViews[0]
            
            break
        case "activo":
            
            registrarProgreso(estatus: etapaBrokerage)
            actualViewController = arrayViews[1]
            
            break
        case "datos_usuario":
            
            actualViewController = arrayViews[2]
            
            break
        case "documentos_usuario":
            
            registrarProgreso(estatus: etapaBrokerage)
            actualViewController = arrayViews[3]
            
            break
        case "":
            
            actualViewController = arrayViews[4]
            
            break
        case "pago_realizado":
            
            registrarProgreso(estatus: etapaBrokerage)
            actualViewController = arrayViews[5]
            
            break
        case "firma_contrato":
            
            registrarProgreso(estatus: etapaBrokerage)
            
            break
        default:
            
            //actualViewController = arrayViews[1]
            print("ERROR Caso no especificado en cargarVista")
            
            break
        }
        
    }
    
    
    //registra el progreso de la etapa del brokerage
    func registrarProgreso(estatus: String){
        
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        self.view.addSubview(background)
        activityIndicator.startAnimating()
        
        let urlProgreso = "http://18.221.106.92/api/public//brokerage/progress"

        
        var parameters: [String:Any?] = [:]
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            parameters = [
                "id_prop" :  propiedad.Id,
                "user_id" : String(userId),
                "estatus" : etapaBrokerage
            ]
        }

        guard let url = URL(string: urlProgreso) else { return }

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
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })

            }
        }.resume()

    
    }
    
    

}
