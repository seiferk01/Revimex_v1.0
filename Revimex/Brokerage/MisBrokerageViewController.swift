//
//  MisBrokerageViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
//
class MisBrokerageViewController: UIViewController,UITableViewDataSource {
    
    class movimientosRecognizer: UITapGestureRecognizer {
        var idSalesforce: String!
    }
    
    @IBOutlet weak var flBtnNuevo: FABButton!
    public var nuevoBrokerage:NuevoBrokerageViewController!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ancho = CGFloat()
    var largo = CGFloat()

    
    var arrayBrokerages:[PropiedadBrokerage] = []
    
    var detallesBrokerageSeleccionado = PropiedadBrokerage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instanciaMisBrokerageViewController = self
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        solicitarBrokerages()
        
        iniFlBtn()
    }
    
    func iniFlBtn(){
        flBtnNuevo.image = Icon.cm.add
        flBtnNuevo.tintColor = UIColor.white
        flBtnNuevo.backgroundColor = verde
        flBtnNuevo.addTarget(self, action: #selector(nuevoBrokerageAction), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retomarProceso() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let etapasBrokerage = storyboard.instantiateViewController(withIdentifier: "EtapasBrokerage") as! EtapasBrokerageController
        navigationController?.present(etapasBrokerage, animated: true, completion: nil)
        
        
    }
    
    
    @objc func nuevoBrokerageAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        nuevoBrokerage = storyboard.instantiateViewController(withIdentifier: "NuevoBrokerage") as! NuevoBrokerageViewController
        navigationController?.present(nuevoBrokerage, animated: true, completion: nil)
    }
    
    
    func solicitarBrokerages(){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayBrokerages = []
        
        let urlBrokerages = "http://18.221.106.92/api/public/brokerage/getListProcess"
        
        var parameters: [String:Any] = [:]
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            parameters = [
                "user_id" : userId,
            ]
        }
        
        print(parameters)
        
        guard let url = URL(string: urlBrokerages) else { return }
        
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
                    let json = try JSONSerialization.jsonObject (with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                    
                    print(json)
                    
                    for element in json {
                        
                        if let propiedad = element as? NSDictionary {
                            
                            let brokerage = PropiedadBrokerage()
                            
                            if let favs = propiedad["favs"] as? Int{
                                brokerage.favoritos = String(favs)
                            }
                            if let likes = propiedad["likes"] as? Int {
                                brokerage.likes = String(likes)
                            }
                            if let estatus = propiedad["estatus"] as? String {
                                brokerage.estatus = estatus
                            }
                            if let fecha_registro = propiedad["fecha_registro"] as? String {
                                brokerage.fecha_registro = fecha_registro
                            }
                            if let pros = propiedad["pros"] as? String{
                                brokerage.pros = pros
                            }
                            if let estado = propiedad["estado"] as? String{
                                brokerage.estado = estado
                            }
                            if let plaza = propiedad["plaza"] as? String{
                                brokerage.plaza = plaza
                            }
                            if let latitud = propiedad["latitud"] as? String{
                                brokerage.latitud = latitud
                            }
                            if let longitud = propiedad["longitud"] as? String{
                                brokerage.longitud = longitud
                            }
                            if let idp = propiedad["idp"] as? String{
                                brokerage.idp = idp
                            }
                            if let id_ai = propiedad["id_ai"] as? Int{
                                brokerage.id_ai = String(id_ai)
                            }
                            if let monto = propiedad["monto"] as? Int{
                                brokerage.monto = String(monto)
                            }
                            if let tiempo = propiedad["tiempo"] as? Int{
                                brokerage.tiempo = String(tiempo)
                            }
                            if let url_img = propiedad["url_img"] as? String{
                                brokerage.urlImagen = url_img
                                brokerage.foto = Utilities.traerImagen(urlImagen: url_img)
                            }
                            
                            self.arrayBrokerages.append(brokerage)
                            
                            
                        }
                        
                    }
                
                    
                } catch {
                    print("El error es: ")
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBrokerages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "BrokerageTableCell") as! BrokerageTableCellController
        
        row.estatusBrokerage.text = arrayBrokerages[indexPath.row].estatus
        row.fotoBrokerage.image = arrayBrokerages[indexPath.row].foto
        row.detallesBrokerage.favoritos = arrayBrokerages[indexPath.row].favoritos
        row.detallesBrokerage.likes = arrayBrokerages[indexPath.row].likes
        row.detallesBrokerage.estatus = arrayBrokerages[indexPath.row].estatus
        row.detallesBrokerage.fecha_registro = arrayBrokerages[indexPath.row].fecha_registro
        row.detallesBrokerage.pros = arrayBrokerages[indexPath.row].pros
        row.detallesBrokerage.estado = arrayBrokerages[indexPath.row].estado
        row.detallesBrokerage.plaza = arrayBrokerages[indexPath.row].plaza
        row.detallesBrokerage.latitud = arrayBrokerages[indexPath.row].latitud
        row.detallesBrokerage.longitud = arrayBrokerages[indexPath.row].longitud
        row.detallesBrokerage.idp = arrayBrokerages[indexPath.row].idp
        row.detallesBrokerage.id_ai = arrayBrokerages[indexPath.row].id_ai
        row.detallesBrokerage.monto = arrayBrokerages[indexPath.row].monto
        row.detallesBrokerage.tiempo = arrayBrokerages[indexPath.row].tiempo
        row.detallesBrokerage.urlImagen = arrayBrokerages[indexPath.row].urlImagen
        row.detallesBrokerage.foto = arrayBrokerages[indexPath.row].foto
        
        switch arrayBrokerages[indexPath.row].estatus {
        case "Firma del contrato":
            let enviar = movimientosRecognizer(target: self, action: #selector(llamarMovimientos(tapGestureRecognizer:)))
            enviar.idSalesforce = arrayBrokerages[indexPath.row].idp
            row.movimientosBtnBrokerage.setBackgroundImage(UIImage(named: "movimientos.png") as UIImage?, for: .normal)
            row.movimientosBtnBrokerage.addGestureRecognizer(enviar)
            row.opcionesBtnBrokerage.setTitle("Finalizar Brokerage", for: .normal)
            break
        default:
            row.movimientosBtnBrokerage.setBackgroundImage(UIImage(named: "movimientosDisable.png") as UIImage?, for: .normal)
            row.opcionesBtnBrokerage.setTitle("x Cancelar Proceso", for: .normal)
            break
        }
        
        return row
    }
    
    
    func msgBrokerageTerminado(){
        let alert = UIAlertController(title: "Aviso", message: "El proceso de brokerage ya esta finalizado", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }
    
    
    @objc func llamarMovimientos(tapGestureRecognizer: movimientosRecognizer) {
    
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        self.view.addSubview(background)
        activityIndicator.startAnimating()
        
        var jsonResponse:[String:Any?] = [:]
        
        let urlProgreso = "http://18.221.106.92/api/public//brokerage/allPays"
        
        
        var parameters: [String:Any?] = [:]
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            parameters = [
                "id_prop" : tapGestureRecognizer.idSalesforce,
                "user_id" : String(userId)
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
                    
                    jsonResponse = json
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    
                    self.siguientePago(movimientos: jsonResponse,idSalesforce: tapGestureRecognizer.idSalesforce)
                    
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
        }.resume()
        
    }
    
    func siguientePago(movimientos: [String:Any?],idSalesforce: String){
        
        let urlProgreso = "http://18.221.106.92/api/public/brokerage/nextPay"
        var siguientePago = ""
        var parameters: [String:Any?] = [:]
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            parameters = [
                "id_prop" : idSalesforce,
                "user_id" : String(userId)
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
                    if let sigPago = json["fecha"] as? String{
                        siguientePago = sigPago
                    }
                } catch {
                    print("El error es: ")
                    print(error)
                }
                OperationQueue.main.addOperation({
                    self.mostrarMovimientos(movimientos: movimientos, siguientePago: siguientePago)
                })
            }
        }.resume()
        
    }
    
    
    func mostrarMovimientos(movimientos: [String:Any?],siguientePago: String){
        
        let modalDetalles = UIViewController()
        modalDetalles.view.frame = CGRect(x:0, y:0, width:ancho, height:largo)
        modalDetalles.view.backgroundColor = UIColor.white
        
        
        let titulo = UILabel()
        titulo.frame = CGRect(x:0, y:largo*0.05, width:ancho, height:largo*0.1)
        titulo.text = "Historial de pagos"
        titulo.font = UIFont.boldSystemFont(ofSize: 20.0)
        titulo.textAlignment = .center
        titulo.layer.borderColor = gris?.cgColor
        titulo.layer.borderWidth = 0.3
        
        
        let subtitulo = UILabel()
        subtitulo.frame = CGRect(x:0, y:largo*0.15, width:ancho, height:largo*0.05)
        subtitulo.font = UIFont(name: "Marion-Italic", size: 17.0)
        subtitulo.textColor = azulObscuro
        subtitulo.text = "El siguiente pago sera el \(siguientePago)"
        
        let contenedorPagos = UIScrollView()
        
        if let pagos = movimientos["pagos"] as? NSArray{
            
            contenedorPagos.frame = CGRect(x: 0, y: largo*0.25, width: ancho, height: largo*0.65)
            let largoContenido = (largo*0.1) * CGFloat(pagos.count)
            contenedorPagos.contentSize = CGSize(width: ancho, height: largoContenido)
            
            contenedorPagos.layer.masksToBounds = true
            contenedorPagos.layer.borderWidth = 0.3
            contenedorPagos.layer.shadowOffset = CGSize(width: -1, height: 0.3)
            let borderColor: UIColor = gris!
            contenedorPagos.layer.borderColor = borderColor.cgColor
            
            for (index, pago) in pagos.enumerated() {
                
                if let pagoObject = pago as? [String:Any?]{
                    
                    let infoPago = TextField()
                    infoPago.frame = CGRect(x:0, y:((largo*0.1) * CGFloat(index)) + largo*0.05, width:ancho, height:(largo*0.1)/2)
                    if let numPago = pagoObject["numero_pago"] as? Int{
                        infoPago.placeholder = "Pago " + String(numPago)
                    }
                    if let fecha = pagoObject["fecha_hora"] as? String, let monto = pagoObject["monto"] as? String {
                        infoPago.text = fecha + " | " + monto
                    }
                    infoPago.isEnabled = false
                    infoPago.placeholderLabel.textColor = azulObscuro
                    //infoPago.textAlignment = .center
                    
                    contenedorPagos.addSubview(infoPago)
                    
                }
                
            }
        }
        
        let dismissButton:UIButton! = UIButton()
        dismissButton.setTitle("Ok", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.frame = CGRect(x:ancho*0.65, y:largo*0.92, width:ancho/4, height:largo*0.05)
        dismissButton.backgroundColor = azulObscuro
        dismissButton.addTarget(self,action: #selector(self.cerrarModal),for: .touchUpInside)
        
        
        modalDetalles.view.addSubview(titulo)
        modalDetalles.view.addSubview(subtitulo)
        modalDetalles.view.addSubview(contenedorPagos)
        modalDetalles.view.addSubview(dismissButton)
        
        
        modalDetalles.modalTransitionStyle = .partialCurl
        present(modalDetalles, animated: true, completion: nil)
    }
    
    
    func mostrarDetalles(){
        //****manejar errores en los calculos con parseos
        
        let modalDetalles = UIViewController()
        modalDetalles.view.frame = CGRect(x:0, y:0, width:ancho, height:largo)
        modalDetalles.view.backgroundColor = UIColor.white
        
        
        let titulo = UILabel()
        titulo.frame = CGRect(x:0, y:largo*0.05, width:ancho, height:largo*0.05)
        titulo.text = "Detalles"
        titulo.font = UIFont.boldSystemFont(ofSize: 17.0)
        titulo.textAlignment = .center
        
        let subtitulo = UILabel()
        subtitulo.frame = CGRect(x:0, y:largo*0.1, width:ancho, height:largo*0.05)
        subtitulo.text = detallesBrokerageSeleccionado.estado + ", " + detallesBrokerageSeleccionado.plaza
        
        let pros = UITextView()
        pros.frame = CGRect(x:-0.5, y:largo*0.15, width:ancho+1, height:largo*0.15)
        if detallesBrokerageSeleccionado.pros.isEmpty{
            pros.text = "Descripcion no disponible"
        }
        else{
            pros.text = detallesBrokerageSeleccionado.pros.replacingOccurrences(of: "<br>", with: "\n")
        }
        pros.layer.borderWidth = 0.5
        pros.layer.borderColor = UIColor.gray.cgColor
        pros.isEditable = false
        
        let inversionInicial = TextField()
        inversionInicial.frame = CGRect(x:0, y:largo*0.35, width:ancho, height:(largo*0.1)/2)
        inversionInicial.placeholder = "Inversion inicial"
        inversionInicial.text = detallesBrokerageSeleccionado.monto
        inversionInicial.isEnabled = false
        inversionInicial.placeholderLabel.textColor = azulObscuro
        //inversionInicial.textAlignment = .center
        
        let pagoMensual = TextField()
        pagoMensual.frame = CGRect(x:0, y:largo*0.45, width:ancho, height:(largo*0.1)/2)
        pagoMensual.placeholder = "Pago mensual"
        let tmp = ((0.2/12) * Double(detallesBrokerageSeleccionado.tiempo)!)+1;
        let res_tot = ( Double(detallesBrokerageSeleccionado.monto)! * tmp);
        let res_mes = Int( ( res_tot - Double(detallesBrokerageSeleccionado.monto)! ) / Double(detallesBrokerageSeleccionado.tiempo)! )
        pagoMensual.text = String(res_mes)
        pagoMensual.isEnabled = false
        pagoMensual.placeholderLabel.textColor = azulObscuro
        //pagoMensual.textAlignment = .center
        
        let rendimiento = TextField()
        rendimiento.frame = CGRect(x:0, y:largo*0.55, width:ancho, height:(largo*0.1)/2)
        rendimiento.placeholder = "Rendimiento"
        rendimiento.text = String(Int(pagoMensual.text!)!*Int(detallesBrokerageSeleccionado.tiempo)!)
        rendimiento.isEnabled = false
        rendimiento.placeholderLabel.textColor = azulObscuro
        //rendimiento.textAlignment = .center
        
        let tiempoInversion = TextField()
        tiempoInversion.frame = CGRect(x:0, y:largo*0.65, width:ancho, height:(largo*0.1)/2)
        tiempoInversion.placeholder = "Tiempo de Inversion"
        tiempoInversion.text = detallesBrokerageSeleccionado.tiempo
        tiempoInversion.isEnabled = false
        tiempoInversion.placeholderLabel.textColor = azulObscuro
        //tiempoInversion.textAlignment = .center
        
        let valor = TextField()
        valor.frame = CGRect(x:0, y:largo*0.75, width:ancho, height:(largo*0.1)/2)
        valor.placeholder = "Valor propiedad vs Valor Mercado"
        valor.text = "$7,530 MXN. vs $10,530 MXN."
        valor.isEnabled = false
        valor.placeholderLabel.textColor = azulObscuro
        //valor.textAlignment = .center
        
        let mejora = TextField()
        mejora.frame = CGRect(x:0, y:largo*0.85, width:ancho, height:(largo*0.1)/2)
        mejora.placeholder = "Mejora de la inversión / Cobertura"
        mejora.text = String(Int(detallesBrokerageSeleccionado.monto)!+Int(rendimiento.text!)!)
        mejora.isEnabled = false
        mejora.placeholderLabel.textColor = azulObscuro
        //mejora.textAlignment = .center
        
        let dismissButton:UIButton! = UIButton()
        dismissButton.setTitle("Ok", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.frame = CGRect(x:ancho*0.65, y:largo*0.92, width:ancho/4, height:largo*0.05)
        dismissButton.backgroundColor = azulObscuro
        dismissButton.addTarget(self,action: #selector(self.cerrarModal),for: .touchUpInside)
        
        
        modalDetalles.view.addSubview(titulo)
        modalDetalles.view.addSubview(subtitulo)
        modalDetalles.view.addSubview(pros)
        modalDetalles.view.addSubview(inversionInicial)
        modalDetalles.view.addSubview(pagoMensual)
        modalDetalles.view.addSubview(rendimiento)
        modalDetalles.view.addSubview(tiempoInversion)
        modalDetalles.view.addSubview(valor)
        modalDetalles.view.addSubview(mejora)
        modalDetalles.view.addSubview(dismissButton)
        
        
        modalDetalles.modalTransitionStyle = .partialCurl
        present(modalDetalles, animated: true, completion: nil)
        
    }
    @objc func cerrarModal(){
        dismiss(animated: true, completion: nil)
    }
    

}

