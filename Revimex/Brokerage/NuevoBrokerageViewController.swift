//
//  NuevoBrokerageViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class NuevoBrokerageViewController: UIViewController {
    
    class navigationGestureRecognizer: UITapGestureRecognizer {
        var anterior: [UIView]!
        var actual: [UIView]!
        var siguiente: [UIView]!
    }
    
    

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    
    @IBOutlet weak var barraNavegacion: UIView!
    @IBOutlet weak var contenedorDatos: UIView!
    @IBOutlet weak var tableBrokerage: UITableView!
    
    
    
    
    var txFlMontoInversion = TextField()
    var txFlTiempoInversion = TextField()
    var rendimientoMensual = TextField()
    var rendimientoTotal = TextField()
    
    var rendimientoAnual = ""
    var montoInversion = 0
    
    
    
    
    
    
    private var actualAlert:UIAlertController!;
    
    private var dataMonto:[Int]!;
    private var dataTiempo:[Int]!;
    
    private var indexMonto:Int!;
    private var indexTiempo:Int!;
    
    public var dataBrokerage:[NuevoBrokerage]!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        instanciaNuevoBrokerageViewController = self
        
        dataBrokerage = [];
        dataMonto = fillInversion()
        dataTiempo = fillTiempo()
        
        tableBrokerage.dataSource = self;
        tableBrokerage.delegate = self;
        tableBrokerage.rowHeight = 200;
        
        
        iniVista()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func iniVista(){
        
        
        barraNavegacion.frame = CGRect(x:0, y:0, width: ancho, height: largo*0.08)
        
        let cancelarProceso = UITapGestureRecognizer(target: self, action: #selector(cancelProcess(tapGestureRecognizer:)))
        let cancelar = UIButton()
        cancelar.setTitle("Cancelar", for: .normal)
        cancelar.setTitleColor(UIColor.black, for: .normal)
        cancelar.frame = CGRect(x:0, y:0, width: ancho*0.3, height: barraNavegacion.bounds.height + 25)
        cancelar.addGestureRecognizer(cancelarProceso)
        
        contenedorDatos.frame = CGRect(x:0, y:barraNavegacion.bounds.height + 25, width: ancho, height: largo*0.32)
        let anchoContenedor = contenedorDatos.bounds.width
        let largoContenedor = contenedorDatos.bounds.height
        
        txFlMontoInversion.frame = CGRect(x:anchoContenedor*0.05, y:0, width: anchoContenedor*0.9, height: (largoContenedor*0.3/2))
        txFlMontoInversion.placeholder = "Monto de Inversión"
        txFlMontoInversion.colorEnable()
        txFlMontoInversion.tag = 15
        txFlMontoInversion.delegate = self
        
        txFlTiempoInversion.frame = CGRect(x:anchoContenedor*0.05, y:largoContenedor*0.3, width: anchoContenedor*0.9, height: (largoContenedor*0.3)/2)
        txFlTiempoInversion.placeholder = "Tiempo de Inversión"
        txFlTiempoInversion.colorEnable()
        txFlTiempoInversion.delegate = self
        
        rendimientoMensual.frame = CGRect(x:anchoContenedor*0.05, y:largoContenedor*0.6, width: anchoContenedor*0.4, height: (largoContenedor*0.3)/2)
        rendimientoMensual.placeholder = "Rendimiento mensual"
        rendimientoMensual.colorEnable()
        rendimientoMensual.isEnabled = false
        
        rendimientoTotal.frame = CGRect(x:anchoContenedor*0.55, y:largoContenedor*0.6, width: anchoContenedor*0.4, height: (largoContenedor*0.3)/2)
        rendimientoTotal.placeholder = "Rendimiento final"
        rendimientoTotal.colorEnable()
        rendimientoTotal.isEnabled = false
        
        txFlMontoInversion.text = "$ \(dataMonto[0])";
        txFlTiempoInversion.text = "\(dataTiempo[0]) meses";
        indexMonto = 0;
        indexTiempo = 0;
        
        tableBrokerage.frame = CGRect(x:0, y:(largo*0.4), width: ancho, height: largo*0.6 - 25)
        
        barraNavegacion.addSubview(cancelar)
        contenedorDatos.addSubview(txFlMontoInversion)
        contenedorDatos.addSubview(txFlTiempoInversion)
        contenedorDatos.addSubview(rendimientoMensual)
        contenedorDatos.addSubview(rendimientoTotal)
        
    }
  
    
    
    private func seleccionarMonto(){
        let alertPicker = UIAlertController(title: "Elija el Monto de su Inversión", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert);
        let pickerMonto = UIPickerView(frame: CGRect(x:0, y: 20, width: 250, height: 162));
        pickerMonto.backgroundColor = UIColor(white: 1, alpha: 0.7);
        pickerMonto.tag = 10;
        pickerMonto.delegate = self;
        pickerMonto.dataSource = self;
        alertPicker.view.addSubview(pickerMonto);
        //let actionCancelar = UIAlertAction(title: "Cancel", style: .default,handler: nil);
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default){ action in
            self.busqueda();
            self.actualAlert.dismiss(animated: true, completion: nil);
        }
        //alertPicker.addAction(actionCancelar);
        alertPicker.addAction(actionAceptar);
        self.actualAlert = alertPicker;
        present(alertPicker, animated: true, completion: nil);
    }
    
    private func seleccionarTiempo(){
        let alertPicker = UIAlertController(title: "Defina el tiempo de Inversión", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert);
        let pickerTiempo = UIPickerView(frame: CGRect(x:0, y:20, width: 250, height: 162));
        pickerTiempo.backgroundColor = UIColor(white: 1, alpha: 0.7);
        pickerTiempo.tag = 11;
        pickerTiempo.delegate = self;
        pickerTiempo.dataSource = self;
        alertPicker.view.addSubview(pickerTiempo);
        //let actionCancelar = UIAlertAction(title: "Cancel", style: .default, handler: nil);
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default){ action in
            self.busqueda();
            self.actualAlert.dismiss(animated: true, completion: nil);
        }
        //alertPicker.addAction(actionCancelar);
        alertPicker.addAction(actionAceptar);
        self.actualAlert = alertPicker;
        present(alertPicker, animated: true, completion: nil);
    }
    
    private func fillInversion()->[Int]{
        var respuesta:[Int] = [];
        var inicio = 100000;
        //var index = 0;
        
        repeat{
            respuesta.append(inicio);
            inicio = inicio + 50000;
        }while inicio <= 1000000
        
        return respuesta;
    }
    
    private func fillTiempo()->[Int]{
        var respuesta:[Int] = []
        var inicio = 1
        
        repeat{
            respuesta.append(inicio);
            inicio = inicio + 1;
        }while inicio <= 36
        
        return respuesta;
    }
    
    private func busqueda(){
        if(!txFlMontoInversion.isEmpty && !txFlTiempoInversion.isEmpty){
            buscarBrokerages(monto: dataMonto[self.indexMonto], tiempo:dataTiempo[self.indexTiempo] ){ brokerages in
                DispatchQueue.main.async{
                    self.dataBrokerage = [];
                    self.dataBrokerage = brokerages;
                    self.tableBrokerage.reloadData();
                }
            }
        }
    }
    
    private func buscarBrokerages(monto:Int,tiempo:Int,completado: @escaping(_ brokerages:[NuevoBrokerage])->Void){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        
        let url = "http://18.221.106.92/api/public/prop_brokerage/\(monto)";
        var brokerages:[NuevoBrokerage] = [];
        guard let urlBrokerage = URL(string: url) else{return};
        var request = URLRequest(url: urlBrokerage);
        request.httpMethod = "GET";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        let session = URLSession.shared;
        
        session.dataTask(with: request){ (data,response,error) in
            if(error == nil){
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! NSArray;
                        for node in json {
                            let temp = node as! NSDictionary;
                            let id = temp["Id"] as! String!;
                            let id_ai = temp["idp"] as! Int!;
                            let estado = temp["estado"] as! String!;
                            let municipio = temp["municipio"] as! String!;
                            let valorReferencia = temp["precio"] as! String!;
                            let precioOriginal = temp["Precio_Original__c"] as! String!;
                            let tipo = temp["tipo"] as! String!;
                            let construccion = temp["construccion"] as! String!;
                            let terreno = temp["terreno"] as! String!;
                            let urlFotoPrincipal = temp["fotoPrincipal"] as! String!;
                            let urlFotos = temp["images"] as! [[String:Any?]];
                            
                            let tempBrokerage = NuevoBrokerage(id: id, id_ai: id_ai, estado: estado, municipio: municipio, valorReferencia: valorReferencia, precioOriginal: precioOriginal,tipo: tipo,construccion: construccion,terreno: terreno,urlFotoPrincipal: urlFotoPrincipal,urlFotos: urlFotos);
                            brokerages.append(tempBrokerage);
                            
                        }
                        completado(brokerages);
                    }catch{
                        print(error);
                    }
                };
            }
        }.resume();
        
        activityIndicator.stopAnimating()
        background.removeFromSuperview()
        
    }
    
    
    @objc func cancelProcess(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }
    
    @objc func regresar(tapGestureRecognizer: navigationGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            for vista in tapGestureRecognizer.actual{
                vista.alpha = 0
            }
            for vista in tapGestureRecognizer.anterior{
                vista.alpha = 1
            }
            
        },completion: { (finished: Bool) in
            
        })
        
    }
    
    @objc func continuar(tapGestureRecognizer: navigationGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            for vista in tapGestureRecognizer.actual{
                vista.alpha = 0
            }
            for vista in tapGestureRecognizer.siguiente{
                vista.alpha = 1
            }
            
        },completion: { (finished: Bool) in
            
        })
        
    }
    
    
    
    
    
    
}









extension NuevoBrokerageViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBrokerage.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableBrokerage.dequeueReusableCell(withIdentifier: "NuevoBrokerage_Row", for: indexPath) as! NuevoBrokerageCellController;
        item.setNuevoBrokerage(nuevoBrokerage: dataBrokerage[indexPath.row]);
        return item;
    }
    
}


extension NuevoBrokerageViewController: TextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.tag == 15){
            seleccionarMonto();
        }else{
            seleccionarTiempo();
        }
        return false;
    }
}

extension NuevoBrokerageViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 10){
            return dataMonto.count;
        }else{
            return dataTiempo.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 10){
            let numberF = NumberFormatter();
            numberF.numberStyle = .decimal;
            let valor = "$ "+numberF.string(from: NSNumber(value: dataMonto[row]))!;
            
            return valor;
        }else{
            return "\(dataTiempo[row]) meses";
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let numberF = NumberFormatter();
        numberF.numberStyle = .decimal;
        
        if(pickerView.tag == 10){
            self.indexMonto = row;
            self.montoInversion = dataMonto[row]
            self.txFlMontoInversion.text = "$ "+numberF.string(from: NSNumber(value: dataMonto[row]))!;
        }else{
            self.indexTiempo = row;
            self.txFlTiempoInversion.text = "\(dataTiempo[row]) meses";
        }
        
        let tmp = ((0.2/12) * Double(dataTiempo[indexTiempo]))+1;
        let res_tot = ( Double(dataMonto[indexMonto]) * tmp);
        let res_mes = Int( ( res_tot - Double(dataMonto[indexMonto]) ) / Double(dataTiempo[indexTiempo]) )
        let total = res_mes * dataTiempo[indexTiempo]
        
        rendimientoMensual.text = "$ "+numberF.string(from: NSNumber(value: res_mes))!
        
        rendimientoAnual = "$ "+numberF.string(from: NSNumber(value: (res_mes * 12)))!
        
        rendimientoTotal.text = "$ "+numberF.string(from: NSNumber(value: total ) )!
    }
}

