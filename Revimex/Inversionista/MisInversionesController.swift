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
    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    class ofertaInversionista{
        var public_id:String = ""
        var created_at:String = ""
        var total_oferta:String = ""
        var numPropiedades:Int = 0
        var validacion:Int = -1
        var propiedades:[propiedadInversionsita] = []
    }
    
    class propiedadInversionsita{
        var Estado__c:String = ""
        var Plaza__c:String = ""
        var Colonia__c:String = ""
        var ValorReferencia__c:String = ""
        var desalojo:String = "20,000"
        var totalPropiedad:String = ""
        var url_imagen:String = ""
    }
    
    var arrayOfertas:[ofertaInversionista] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                                    
                                    let ofertaInversion = ofertaInversionista()
                                    
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
                                            
                                            let propiedadInversion = propiedadInversionsita()
                                            
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
                                                if let url = oferta["url_imagen"] as? String{
                                                    propiedadInversion.url_imagen  = url
                                                }
                                            }
                                            
                                            ofertaInversion.propiedades.append(propiedadInversion)
                                        }
                                    }
                                    
                                    ofertaInversion.numPropiedades  = ofertaInversion.propiedades.count
                                    
                                    
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
        row.totalOfertado.text = arrayOfertas[indexPath.row].total_oferta
        row.numPropiedades = arrayOfertas[indexPath.row].numPropiedades
        
        
        switch arrayOfertas[indexPath.row].validacion {
        case 0:
            row.estatus.setTitle("Denegada", for: .normal)
            row.estatus.backgroundColor = rojo
            break
        case 1:
            row.estatus.setTitle("En Validacion", for: .normal)
            row.estatus.backgroundColor = UIColor.orange
            break
        case 2:
            row.estatus.setTitle("Aceptada", for: .normal)
            row.estatus.backgroundColor = verde
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
        row.layer.borderWidth = 0.5
        row.layer.shadowOffset = CGSize(width: -1, height: 0.5)
        let borderColor: UIColor = gris!
        row.layer.borderColor = borderColor.cgColor
        
        
        return row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    @objc func nuevaInversion() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nuevaInversionCtrl = storyboard.instantiateViewController(withIdentifier: "NuevaInversion") as! InversionistaController
        navigationController?.present(nuevaInversionCtrl, animated: true, completion: nil)
    }

}
