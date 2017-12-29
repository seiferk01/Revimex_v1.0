//
//  InversionistaController.swift
//  Revimex
//
//  Created by Seifer on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class InversionistaController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    class propiedadInversion {
        var idPropiedad: String
        var estado: String
        var precio: String
        var referencia: String
        var fechaAgregado: String
        var foto: UIImage
        var urlPropiedad: String
        
        init(idPropiedad: String,estado: String, precio: String, referencia: String, fechaAgregado: String, foto: UIImage, urlPropiedad: String){
            self.idPropiedad = idPropiedad
            self.estado = estado
            self.precio = precio
            self.referencia = referencia
            self.fechaAgregado = fechaAgregado
            self.foto = foto
            self.urlPropiedad = urlPropiedad
        }
    }
    
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var montoInversionPicker: UIPickerView!
    @IBOutlet weak var tiempoInversionPicker: UIPickerView!
    
    var valoresMonto: [Int] = []
    var valoresTiempo: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()
        
        //genera el titulo dependiendo si ya se inicio sesion o no
        titulo.font = UIFont.boldSystemFont(ofSize: 18.0)
        if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
            titulo.text = "Invierte de manera sencilla con Revimex"
        }
        else{
            titulo.text = "Registrate para comenzar a invertir"
        }
        
        //genera los datos de los picker
        asignarValoresPicker()
        
        //llama las propiedades disponibles
        propiedadesDisponibles(montoIversion: "100000")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
    }
    
    func asignarValoresPicker(){
        
        var monto = 100000
        repeat{
            valoresMonto.append(monto)
            monto += 50000
        }while monto<1000000
        
        valoresTiempo.append(1)
        valoresTiempo.append(12)
        valoresTiempo.append(24)
        valoresTiempo.append(48)
        valoresTiempo.append(72)
        
    }
    
    
    //*******************************funciones del picker*************************************
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var etiquetaValor: String!
        if pickerView == montoInversionPicker{
            etiquetaValor = "$"+String(valoresMonto[row])
        }
        else if pickerView == tiempoInversionPicker{
            etiquetaValor = String(valoresTiempo[row])+" meses"
        }
        return etiquetaValor
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rowActual: Int!
        if pickerView == montoInversionPicker{
            rowActual = valoresMonto.count
        }
        else if pickerView == tiempoInversionPicker{
            rowActual = valoresTiempo.count
        }
        return rowActual
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var valorRowActual: Int!
        if pickerView == montoInversionPicker{
            valorRowActual = valoresMonto[row]
            propiedadesDisponibles(montoIversion: String(valorRowActual))
        }
        else if pickerView == tiempoInversionPicker{
            valorRowActual = valoresTiempo[row]
        }
    }
    
    
    //******************************funciones de la tabla***********************************
    //llamado a la lista de propiedades
    func propiedadesDisponibles(montoIversion: String){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        let urlInversion = "http://18.221.106.92/api/public/prop_brokerage/"+montoIversion
        
        //url para la llamada
        guard let url = URL(string: urlInversion) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data)
                    
                    print("json de sugerencias de inversion: ")
                    print(json)
                    
                    for propiedad in json as! NSArray{
                        if let propiedadInversion = propiedad as? NSDictionary{
                            print("*****************Empieza propiedad Inversion*****************")
                            print(propiedadInversion)
                            
                            
                        }
                    }
                    
                } catch {
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    //self.tableView.reloadData()
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
        }.resume()
    }

}
