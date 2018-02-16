//
//  MisInversionesController.swift
//  Revimex
//
//  Created by Seifer on 09/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class MisInversionesController: UIViewController,UITableViewDataSource,TableViewDelegate {
    
    @IBOutlet weak var nuevaInversionBtn: FABButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var ofertaSeleccionada = ""
    
    
    class ofertaDenegadaGestureRecognizer: UITapGestureRecognizer {
        var precio_minino: String!
        var razon: String!
        var comentario: String!
    }
    
    class propiedadesGestureRecognizer: UITapGestureRecognizer {
        var arrayPropiedades: [PropiedadInversionista]!
        var oferta: String!
    }

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    
    var arrayOfertas:[OfertaInversionista] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        instanciaMisInversionesController = self 
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        solicitarOfertas()
        
        iniFlBtn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func iniFlBtn(){
        nuevaInversionBtn.image = Icon.cm.add
        nuevaInversionBtn.tintColor = UIColor.white
        nuevaInversionBtn.backgroundColor = azulObscuro
        nuevaInversionBtn.addTarget(self, action: #selector(nuevaInversion), for: .touchUpInside)
    }
    
    
    func solicitarOfertas(){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayOfertas = []
        
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            let urlFvoritos =  "http://18.221.106.92/api/public/oferta/inversionista/" + String(userId)
            
            guard let url = URL(string: urlFvoritos) else { return }
            
            let session  = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let response = response {
                    print("response:")
                    print(response)
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                        
                        print(json)
                        
                        if let data = json["data"] as? NSArray{
                            for dat in data{
                                if let oferta = dat as? NSDictionary{
                                    
                                    let ofertaInversion = OfertaInversionista()
                                    
                                    if let public_id = oferta["public_id"] as? String{
                                        ofertaInversion.public_id  = public_id
                                    }
                                    if let created = oferta["created_at"] as? String{
                                        ofertaInversion.created_at  = created
                                    }
                                    if let total = oferta["total_oferta"] as? String{
                                        ofertaInversion.total_oferta  = total
                                    }
                                    if let validacion = oferta["validacion"] as? Int{
                                        ofertaInversion.validacion  = validacion
                                    }
                                    
                                    if let propiedades = oferta["propiedades"] as? NSArray{
                                        for prop in propiedades{
                                            
                                            let propiedadInversion = PropiedadInversionista()
                                            
                                            if let propiedad = prop as? NSDictionary{
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
                                            }
                                            
                                            ofertaInversion.propiedades.append(propiedadInversion)
                                        }
                                    }
                                    
                                    ofertaInversion.numPropiedades  = ofertaInversion.propiedades.count
                                    if let precio_minino = oferta["precio_minino"] as? String{
                                        ofertaInversion.precio_minino  = precio_minino
                                    }
                                    if let razon = oferta["razon"] as? String{
                                        ofertaInversion.razon  = razon
                                    }
                                    if let comentario = oferta["comentario"] as? String{
                                        ofertaInversion.comentario  = comentario
                                    }
                                    
                                    self.arrayOfertas.append(ofertaInversion)
                                    
                                }
                            }
                        }
                        
                        
                    }catch {
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                        activityIndicator.stopAnimating()
                        background.removeFromSuperview()
                        
                    })
                    
                }
            }.resume()
        }
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfertas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "InversionesTableCell") as! InversionesTableCellController
        
        row.oferta.text = arrayOfertas[indexPath.row].public_id
        row.fecha.text = arrayOfertas[indexPath.row].created_at
        row.totalOfertado.text = arrayOfertas[indexPath.row].total_oferta + " en " + String(arrayOfertas[indexPath.row].numPropiedades) + " propiedades"
        
        let verPropiedadesGestureRecognizer = propiedadesGestureRecognizer(target: self, action: #selector(verPropiedades(tapGestureRecognizer: )))
        verPropiedadesGestureRecognizer.arrayPropiedades = arrayOfertas[indexPath.row].propiedades
        verPropiedadesGestureRecognizer.oferta = arrayOfertas[indexPath.row].public_id
        row.verPropiedades.addGestureRecognizer(verPropiedadesGestureRecognizer)
        
        switch arrayOfertas[indexPath.row].validacion {
        case 0:
            let denegadaGestureRecognizer = ofertaDenegadaGestureRecognizer(target: self, action: #selector(ofertaDenegada(tapGestureRecognizer: )))
            denegadaGestureRecognizer.precio_minino = arrayOfertas[indexPath.row].precio_minino
            denegadaGestureRecognizer.razon = arrayOfertas[indexPath.row].razon
            denegadaGestureRecognizer.comentario = arrayOfertas[indexPath.row].comentario
            row.estatus.setTitle("Denegada", for: .normal)
            row.estatus.backgroundColor = rojo
            row.estatus.addGestureRecognizer(denegadaGestureRecognizer)
            row.estatus.alpha = 1
            row.etiquetaEstatus.alpha = 0
            break
        case 1:
            row.estatus.setTitle("En Validacion", for: .normal)
            row.estatus.backgroundColor = UIColor.orange
            row.estatus.alpha = 1
            row.etiquetaEstatus.alpha = 0
            break
        case 2:
            let continuar = propiedadesGestureRecognizer(target: self, action: #selector(continuar(tapGestureRecognizer: )))
            continuar.oferta = arrayOfertas[indexPath.row].public_id
            row.estatus.setTitle("Oferta Aceptada", for: .normal)
            row.estatus.backgroundColor = verde
            row.estatus.addGestureRecognizer(continuar)
            row.estatus.alpha = 1
            row.etiquetaEstatus.alpha = 0
            break
        case 3:
            row.estatus.alpha = 0
            row.etiquetaEstatus.alpha = 1
            break
        default:
            print("Error: caso no especificado boton en celda mis inversiones cell controller")
            break
        }
        
        row.layer.masksToBounds = true
        row.layer.borderWidth = 0.3
        row.layer.shadowOffset = CGSize(width: -1, height: 0.3)
        let borderColor: UIColor = gris!
        row.layer.borderColor = borderColor.cgColor
        
        
        return row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    @objc func ofertaDenegada(tapGestureRecognizer: ofertaDenegadaGestureRecognizer) {
        let alert = UIAlertController(title: "Oferta Denegada", message: "La razón por la cuál se rechazo la oferta es: " + tapGestureRecognizer.razon + "\nEl precio mínimo para esta oferta es de: " + tapGestureRecognizer.precio_minino + "\n\nComentario: " + tapGestureRecognizer.comentario , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }
    
    @objc func verPropiedades(tapGestureRecognizer: propiedadesGestureRecognizer) {
        
        let modalDetalles = UIViewController()
        modalDetalles.view.frame = CGRect(x:0, y:0, width:ancho, height:largo)
        modalDetalles.view.backgroundColor = UIColor.white
        
        
        let titulo = UILabel()
        titulo.frame = CGRect(x:-0.5, y:largo*0.05, width:ancho+1, height:largo*0.1)
        titulo.text = "Oferta: " + tapGestureRecognizer.oferta
        titulo.font = UIFont.boldSystemFont(ofSize: 18.0)
        titulo.textAlignment = .center
        titulo.layer.borderColor = gris?.cgColor
        titulo.layer.borderWidth = 0.3
        
        let subtitulo = UILabel()
        subtitulo.frame = CGRect(x:0, y:largo*0.15, width:ancho, height:largo*0.1)
        subtitulo.font = UIFont(name: "Marion-Italic", size: 20.0)
        subtitulo.textColor = azulObscuro
        subtitulo.text = "Lista de propiedades"
        subtitulo.textAlignment = .center
        
        let contenedorPropiedades = UIScrollView()
        
        contenedorPropiedades.frame = CGRect(x: -0.5, y: largo*0.25, width: ancho+1, height: largo*0.65)
        let largoContenido = (largo*0.25) * CGFloat(tapGestureRecognizer.arrayPropiedades.count)
        contenedorPropiedades.contentSize = CGSize(width: ancho, height: largoContenido)
        contenedorPropiedades.layer.borderColor = gris?.cgColor
        contenedorPropiedades.layer.borderWidth = 0.3
        
        for (index, propiedad) in tapGestureRecognizer.arrayPropiedades.enumerated() {
            
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
                let fotoPropiedad = Utilities.traerImagen(urlImagen: "http://18.221.106.92/"+propiedad.url_imagen)
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
        
        
        let dismissButton:UIButton! = UIButton()
        dismissButton.setTitle("Ok", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.frame = CGRect(x:ancho*0.65, y:largo*0.92, width:ancho/4, height:largo*0.05)
        dismissButton.backgroundColor = azulObscuro
        dismissButton.addTarget(self,action: #selector(self.cerrarModal),for: .touchUpInside)
        
        
        modalDetalles.view.addSubview(titulo)
        modalDetalles.view.addSubview(subtitulo)
        modalDetalles.view.addSubview(contenedorPropiedades)
        modalDetalles.view.addSubview(dismissButton)
        
        
        modalDetalles.modalTransitionStyle = .partialCurl
        present(modalDetalles, animated: true, completion: nil)
        
        
    }
    @objc func cerrarModal(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func continuar(tapGestureRecognizer: propiedadesGestureRecognizer) {
        
        ofertaSeleccionada = tapGestureRecognizer.oferta
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let etapasInversionsita = storyboard.instantiateViewController(withIdentifier: "EtapasInversionista") as! EtapasInversionistaController
        navigationController?.present(etapasInversionsita, animated: true, completion: nil)
        
    }
    
    
    
    @objc func nuevaInversion() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nuevaInversionCtrl = storyboard.instantiateViewController(withIdentifier: "NuevaInversion") as! InversionistaController
        navigationController?.present(nuevaInversionCtrl, animated: true, completion: nil)
    }

}
