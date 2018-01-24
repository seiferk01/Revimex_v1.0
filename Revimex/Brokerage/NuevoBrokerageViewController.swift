//
//  NuevoBrokerageViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
import AVFoundation
import Photos.PHPhotoLibrary
//
class NuevoBrokerageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    class navigationGestureRecognizer: UITapGestureRecognizer {
        var anterior: [UIView]!
        var actual: [UIView]!
        var siguiente: [UIView]!
    }
    
    class addImageGestureRecognizer: UITapGestureRecognizer {
        var imageTag: Int!
        var nombrerDocumento: String!
    }

    let imagePicker = UIImagePickerController()
    var identificadorImagen:Int = -1

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    
    @IBOutlet weak var barraNavegacion: UIView!
    @IBOutlet weak var contenedorDatos: UIView!
    @IBOutlet weak var tableBrokerage: UITableView!
    
    let descripcion = UIView()
    let datosUsuario = UIView()
    
    let contenedorCarga = UIView()
    
    let contenedorFormaPago = UIView()
    
    let contenedorContrato = UIView()
    
    
    
    
    var idBrokerageSeleccionado = -1
    var brokerageSeleccionado:NuevoBrokerage = NuevoBrokerage(id:"",id_ai:0,estado:"",municipio:"",valorReferencia:"",precioOriginal:"",tipo:"",construccion:"",terreno:"",urlFotoPrincipal:"", urlFotos:[[:]])
    
    var txFlMontoInversion = TextField()
    var txFlTiempoInversion = TextField()
    var rendimientoMensual = TextField()
    var rendimientoTotal = TextField()
    
    let foto = UIImageView()
    let tipoInmueble = TextField()
    let precio = TextField()
    let estado = TextField()
    let municipio = TextField()
    
    let nombre = TextField()
    let primerApellido = TextField()
    let segundoApellido = TextField()
    let fechaNacimiento = TextField()
    let telefono = TextField()
    let correoElectronico = TextField()
    let rfc = TextField()
    let direccion = TextField()
    
    
    var json:[String:Any?] = [:]
    
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
        
        datosInversionista()
        
        cargarDocumentos()
        
        formaPago()
        
        contrato()
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
    
    
    func datosInversionista(){
        
        
        descripcion.frame = CGRect(x:0, y:barraNavegacion.bounds.height, width: ancho, height: largo*0.32)
        descripcion.alpha = 0
        
        
        datosUsuario.frame = CGRect(x:0, y:(largo*0.45), width: ancho, height: largo*0.6)
        datosUsuario.alpha = 0
        
        let anchoDescripcion = descripcion.bounds.width
        let largoDescripcion = descripcion.bounds.height
        
        let titulo = UILabel()
        titulo.text = "Completa los datos del Brokerage"
        titulo.frame = CGRect(x:0, y:0, width: anchoDescripcion, height: largoDescripcion*0.1)
        
        
        foto.image = Utilities.traerImagen(urlImagen: brokerageSeleccionado.urlFotoPrincipal)
        foto.frame = CGRect(x:0, y:largoDescripcion*0.2, width: anchoDescripcion*0.3, height: largoDescripcion*0.8)
        foto.contentMode = .scaleAspectFit
        foto.clipsToBounds = true
        
        
        tipoInmueble.frame = CGRect(x:anchoDescripcion*0.35, y:largoDescripcion*0.7, width: anchoDescripcion*0.28, height: (largoDescripcion*0.25)/2)
        tipoInmueble.placeholder = "Tipo de Inmueble"
        tipoInmueble.font = UIFont.fontAwesome(ofSize: 12.0)
        tipoInmueble.text = brokerageSeleccionado.tipo
        tipoInmueble.isEnabled = false
        
        
        precio.frame = CGRect(x:anchoDescripcion*0.67, y:largoDescripcion*0.7, width: anchoDescripcion*0.28, height: (largoDescripcion*0.25)/2)
        precio.placeholder = "Precio"
        precio.font = UIFont.fontAwesome(ofSize: 12.0)
        precio.text = brokerageSeleccionado.valorReferencia
        precio.isEnabled = false
        
        
        estado.frame = CGRect(x:anchoDescripcion*0.35, y:largoDescripcion*0.2, width: anchoDescripcion*0.6, height: (largoDescripcion*0.25)/2)
        estado.placeholder = "Estado"
        estado.font = UIFont.fontAwesome(ofSize: 12.0)
        estado.text = brokerageSeleccionado.estado
        estado.isEnabled = false
        
        
        municipio.frame = CGRect(x:anchoDescripcion*0.35, y:largoDescripcion*0.45, width: anchoDescripcion*0.6, height: (largoDescripcion*0.25)/2)
        municipio.placeholder = "Municipio"
        municipio.font = UIFont.fontAwesome(ofSize: 12.0)
        municipio.text = brokerageSeleccionado.municipio
        municipio.isEnabled = false
        
        let enviar = UITapGestureRecognizer(target: self, action: #selector(enviarDatos(tapGestureRecognizer:)))
        let modificarBtn = UIButton()
        modificarBtn.frame = CGRect(x:anchoDescripcion*0.45, y:largoDescripcion*0.93, width: anchoDescripcion*0.4, height: largoDescripcion*0.08)
        modificarBtn.setTitle("Guardar cambios", for: .normal)
        modificarBtn.setTitleColor(UIColor.black, for: .normal)
        modificarBtn.layer.borderColor = UIColor.black.cgColor
        modificarBtn.layer.borderWidth = 0.5
        modificarBtn.addGestureRecognizer(enviar)
        
        
        let anchoDatosUsuario = datosUsuario.bounds.width
        let largoDatosUsuario = datosUsuario.bounds.height
        
        nombre.colorEnable()
        nombre.frame = CGRect(x:anchoDatosUsuario*0.05, y:0, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        nombre.placeholder = "Nombre"
        nombre.font = UIFont.fontAwesome(ofSize: 12.0)
        
        primerApellido.colorEnable()
        primerApellido.frame = CGRect(x:anchoDatosUsuario*0.05, y:largoDatosUsuario*0.1, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        primerApellido.placeholder = "Apellido Paterno"
        primerApellido.font = UIFont.fontAwesome(ofSize: 12.0)
        
        segundoApellido.colorEnable()
        segundoApellido.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.1)*2, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        segundoApellido.placeholder = "Apellido Materno"
        segundoApellido.font = UIFont.fontAwesome(ofSize: 12.0)
        
        fechaNacimiento.colorEnable()
        fechaNacimiento.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.1)*3, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        fechaNacimiento.placeholder = "Fecha de Nacimiento"
        fechaNacimiento.font = UIFont.fontAwesome(ofSize: 12.0)
        
        telefono.colorEnable()
        telefono.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.1)*4, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        telefono.placeholder = "Telefono"
        telefono.font = UIFont.fontAwesome(ofSize: 12.0)
        
        correoElectronico.colorEnable()
        correoElectronico.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.1)*5, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        correoElectronico.placeholder = "Correo Electronico"
        correoElectronico.font = UIFont.fontAwesome(ofSize: 12.0)
        correoElectronico.isEnabled = false
        
        rfc.colorEnable()
        rfc.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.1)*6, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        rfc.placeholder = "RFC"
        rfc.font = UIFont.fontAwesome(ofSize: 12.0)
        
        direccion.colorEnable()
        direccion.frame = CGRect(x:anchoDatosUsuario*0.05, y:(largoDatosUsuario*0.1)*7, width: anchoDatosUsuario*0.9, height: (largoDatosUsuario*0.1)/2)
        direccion.placeholder = "Direccion"
        direccion.font = UIFont.fontAwesome(ofSize: 12.0)
        
        let regreso = navigationGestureRecognizer(target: self, action: #selector(regresar(tapGestureRecognizer:)))
        regreso.anterior = [contenedorDatos,tableBrokerage]
        regreso.actual = [descripcion,datosUsuario]
        let regresar = UIButton()
        regresar.frame = CGRect(x:anchoDatosUsuario*0.05, y:largoDatosUsuario*0.8, width: anchoDatosUsuario*0.4, height: largoDatosUsuario*0.06)
        regresar.setTitle("Regresar", for: .normal)
        regresar.setTitleColor(UIColor.black, for: .normal)
        regresar.layer.borderColor = UIColor.black.cgColor
        regresar.layer.borderWidth = 0.5
        regresar.addGestureRecognizer(regreso)
        
        let siguiente = navigationGestureRecognizer(target: self, action: #selector(continuar(tapGestureRecognizer:)))
        siguiente.actual = [descripcion,datosUsuario]
        siguiente.siguiente = [contenedorCarga]
        let continuar = UIButton()
        continuar.frame = CGRect(x:anchoDatosUsuario*0.55, y:largoDatosUsuario*0.8, width: anchoDatosUsuario*0.4, height: largoDatosUsuario*0.06)
        continuar.setTitle("Continuar", for: .normal)
        continuar.setTitleColor(UIColor.black, for: .normal)
        continuar.layer.borderColor = UIColor.black.cgColor
        continuar.layer.borderWidth = 0.5
        continuar.addGestureRecognizer(siguiente)
        
        
        descripcion.addSubview(titulo)
        descripcion.addSubview(foto)
        descripcion.addSubview(tipoInmueble)
        descripcion.addSubview(precio)
        descripcion.addSubview(estado)
        descripcion.addSubview(municipio)
        descripcion.addSubview(modificarBtn)
        
        datosUsuario.addSubview(nombre)
        datosUsuario.addSubview(primerApellido)
        datosUsuario.addSubview(segundoApellido)
        datosUsuario.addSubview(fechaNacimiento)
        datosUsuario.addSubview(telefono)
        datosUsuario.addSubview(correoElectronico)
        datosUsuario.addSubview(rfc)
        datosUsuario.addSubview(direccion)
        datosUsuario.addSubview(regresar)
        datosUsuario.addSubview(continuar)
        
        view.addSubview(descripcion)
        view.addSubview(datosUsuario)
    }
    
    func cargarDocumentos(){
        
        contenedorCarga.frame = CGRect(x:0, y:largo*0.1, width: ancho, height: largo-(largo*0.1))
        
        contenedorCarga.alpha = 0
        
        contenedorCarga.addSubview(rowDocumento(documento: "CÉDULA RFC SAT", posicion: 0))
        contenedorCarga.addSubview(rowDocumento(documento: "INE", posicion: 1))
        contenedorCarga.addSubview(rowDocumento(documento: "COMPROBANTE DE DOMICILIO", posicion: 2))
        contenedorCarga.addSubview(rowDocumento(documento: "ESTADO DE CUENTA BANCARIO", posicion: 3))
        
        let siguiente = navigationGestureRecognizer(target: self, action: #selector(continuar(tapGestureRecognizer:)))
        siguiente.actual = [contenedorCarga]
        siguiente.siguiente = [contenedorFormaPago]
        let continuar = UIButton()
        continuar.frame = CGRect(x:ancho*0.55, y:largo*0.83, width: ancho*0.4, height: largo*0.035)
        continuar.setTitle("Continuar", for: .normal)
        continuar.setTitleColor(UIColor.black, for: .normal)
        continuar.layer.borderColor = UIColor.black.cgColor
        continuar.layer.borderWidth = 0.5
        continuar.addGestureRecognizer(siguiente)
        
        let regreso = navigationGestureRecognizer(target: self, action: #selector(regresar(tapGestureRecognizer:)))
        regreso.anterior = [descripcion,datosUsuario]
        regreso.actual = [contenedorCarga]
        let regresar = UIButton()
        regresar.frame = CGRect(x:ancho*0.05, y:largo*0.83, width: ancho*0.4, height: largo*0.035)
        regresar.setTitle("Regresar", for: .normal)
        regresar.setTitleColor(UIColor.black, for: .normal)
        regresar.layer.borderColor = UIColor.black.cgColor
        regresar.layer.borderWidth = 0.5
        regresar.addGestureRecognizer(regreso)
        
        
        contenedorCarga.addSubview(regresar)
        contenedorCarga.addSubview(continuar)
        view.addSubview(contenedorCarga)
    }
    
    func formaPago(){
        
        contenedorFormaPago.alpha = 0
        
        contenedorFormaPago.frame = CGRect(x:0, y:0, width: ancho, height: largo)
        
        let titulo = UILabel()
        titulo.text = "Formas de pago"
        titulo.frame = CGRect(x:0, y:largo*0.05, width: ancho, height: largo*0.15)
        
        let subtitulo = UILabel()
        subtitulo.text = "Fecha limite para realizar el pago"
        subtitulo.textAlignment = .center
        subtitulo.frame = CGRect(x:0, y:largo*0.15, width: ancho, height: largo*0.15)
        
        let imagen = UIImageView(image: UIImage(named: "formasPago.png"))
        imagen.frame = CGRect(x:ancho*0.05, y:largo*0.3, width: ancho*0.9, height: largo*0.4)
        imagen.contentMode = .scaleAspectFit
        imagen.clipsToBounds = true
        
        let siguiente = navigationGestureRecognizer(target: self, action: #selector(continuar(tapGestureRecognizer:)))
        siguiente.actual = [contenedorFormaPago]
        siguiente.siguiente = [contenedorContrato]
        let continuar = UIButton()
        continuar.frame = CGRect(x:ancho*0.55, y:largo*0.93, width: ancho*0.4, height: largo*0.035)
        continuar.setTitle("Continuar", for: .normal)
        continuar.setTitleColor(UIColor.black, for: .normal)
        continuar.layer.borderColor = UIColor.black.cgColor
        continuar.layer.borderWidth = 0.5
        continuar.addGestureRecognizer(siguiente)
        
        let regreso = navigationGestureRecognizer(target: self, action: #selector(regresar(tapGestureRecognizer:)))
        regreso.anterior = [contenedorCarga]
        regreso.actual = [contenedorFormaPago]
        let regresar = UIButton()
        regresar.frame = CGRect(x:ancho*0.05, y:largo*0.93, width: ancho*0.4, height: largo*0.035)
        regresar.setTitle("Regresar", for: .normal)
        regresar.setTitleColor(UIColor.black, for: .normal)
        regresar.layer.borderColor = UIColor.black.cgColor
        regresar.layer.borderWidth = 0.5
        regresar.addGestureRecognizer(regreso)
        
        contenedorFormaPago.addSubview(titulo)
        contenedorFormaPago.addSubview(subtitulo)
        contenedorFormaPago.addSubview(imagen)
        contenedorFormaPago.addSubview(regresar)
        contenedorFormaPago.addSubview(continuar)
        view.addSubview(contenedorFormaPago)
        
    }
    
    func contrato(){
        
        contenedorContrato.alpha = 0
        
        contenedorContrato.frame = CGRect(x:0, y:0, width: ancho, height: largo)
        
        let titulo = UILabel()
        titulo.text = "Contrato"
        titulo.font = UIFont.fontAwesome(ofSize: 20.0)
        titulo.textAlignment = .center
        titulo.frame = CGRect(x:0, y:largo*0.05, width: ancho, height: largo*0.1)
        
        let imagen = UIImageView(image: UIImage(named: "contratoDemo.jpg"))
        imagen.frame = CGRect(x:ancho*0.05, y:largo*0.15, width: ancho*0.9, height: largo*0.6)
        imagen.contentMode = .scaleAspectFit
        imagen.clipsToBounds = true
        
        let firma = TextField()
        firma.frame = CGRect(x:ancho*0.1, y:largo*0.75, width: ancho*0.8, height: largo*0.05)
        firma.placeholder = "Realizar Firma Digital"
        firma.textAlignment = .center
        firma.font = UIFont.fontAwesome(ofSize: 20.0)
        firma.isEnabled = false
        
        let cancelarProceso = UITapGestureRecognizer(target: self, action: #selector(cancelProcess(tapGestureRecognizer:)))
        let finalizar = UIButton()
        finalizar.frame = CGRect(x:ancho*0.55, y:largo*0.93, width: ancho*0.4, height: largo*0.035)
        finalizar.setTitle("Finalizar", for: .normal)
        finalizar.setTitleColor(UIColor.black, for: .normal)
        finalizar.layer.borderColor = UIColor.black.cgColor
        finalizar.layer.borderWidth = 0.5
        finalizar.addGestureRecognizer(cancelarProceso)
        
        let regreso = navigationGestureRecognizer(target: self, action: #selector(regresar(tapGestureRecognizer:)))
        regreso.anterior = [contenedorFormaPago]
        regreso.actual = [contenedorContrato]
        let regresar = UIButton()
        regresar.frame = CGRect(x:ancho*0.05, y:largo*0.93, width: ancho*0.4, height: largo*0.035)
        regresar.setTitle("Regresar", for: .normal)
        regresar.setTitleColor(UIColor.black, for: .normal)
        regresar.layer.borderColor = UIColor.black.cgColor
        regresar.layer.borderWidth = 0.5
        regresar.addGestureRecognizer(regreso)
        
        contenedorContrato.addSubview(titulo)
        contenedorContrato.addSubview(imagen)
        contenedorContrato.addSubview(firma)
        contenedorContrato.addSubview(regresar)
        contenedorContrato.addSubview(finalizar)
        view.addSubview(contenedorContrato)
        
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
        
        let parameters = "id=" + String(idBrokerageSeleccionado)
        
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
                        if  let estado = propiedadSeleccionada["estado"] as? String { propiedad.estado = estado }
                        if  let idp = propiedadSeleccionada["idp"] as? String { propiedad.idp = idp }
                        if  let municipio = propiedadSeleccionada["municipio"] as? String { propiedad.municipio = municipio }
                        if  let precio = propiedadSeleccionada["precio"] as? String { propiedad.precio = "$" + precio}
                        if  let tipo = propiedadSeleccionada["tipo"] as? String { propiedad.tipo = tipo}
                        if  let fotoPrincipal = propiedadSeleccionada["fotoPrincipal"] as? String {
                            propiedad.fotos.append(fotoPrincipal)
                        }
                    }
                    
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    
                    self.foto.image = Utilities.traerImagen(urlImagen: propiedad.fotos[0])
                    self.tipoInmueble.text = propiedad.tipo
                    self.precio.text = propiedad.precio
                    self.estado.text = propiedad.estado
                    self.municipio.text = propiedad.municipio
                    
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
        }.resume()
        
    }
    
    
    func verificarDatos(){
        //indicador de loading
//        let activityIndicator = UIActivityIndicatorView()
//        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
//        background.center = self.view.center
//        view.addSubview(background)
//        activityIndicator.startAnimating()
        
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            let url = "http://18.221.106.92/api/public/user/" + String(userId)
            
            guard let urlInfo = URL(string: url) else{ print("ERROR en URL"); return}
            
            var request = URLRequest(url: urlInfo)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            session.dataTask(with: request){(data,response,error) in
                if(error == nil){
                    if let data = data{
                        do{
                            let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String:Any?]
                            print("*****************Json de Informacion Usuario*****************")
                            print(jsonResponse)
                            
                            self.json = jsonResponse
                            
                        }catch{
                            print(error)
                        }
                        
                    }
                    
                    OperationQueue.main.addOperation({
//                        activityIndicator.stopAnimating()
//                        background.removeFromSuperview()
                        if let nom = self.json["name"] as? String{
                            self.nombre.text = nom
                        }
                        if let ap1 = self.json["apellidoPaterno"] as? String{
                            self.primerApellido.text = ap1
                        }
                        if let ap2 = self.json["apellidoMaterno"] as? String{
                            self.segundoApellido.text = ap2
                        }
                        if let fec = self.json["fecha_nacimiento"] as? String{
                            self.fechaNacimiento.text = fec
                        }
                        if let tel = self.json["tel"] as? String{
                            self.telefono.text = tel
                        }
                        if let email = self.json["email"] as? String{
                            self.correoElectronico.text = email
                        }
                        if let r_f_c = self.json["rfc"] as? String{
                            self.rfc.text = r_f_c
                        }
                        if let dir = self.json["direccion"] as? String{
                            self.direccion.text = dir
                        }
                        
                        let alert = UIAlertController(title: "Aviso", message: "Verifique sus datos para continuar", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert,animated:true,completion:nil)
                        
                    })
                    
                    
                }
            }.resume()
        }
    }
    
    @objc func enviarDatos(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let urlOferta = "http://18.221.106.92/api/public/oferta/user"
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            let parameters: [String:Any?] = [
                "user_id" :  String(userId),
                "nombre" : nombre.text,
                "primerApellido" : primerApellido.text,
                "segundoApellido" : segundoApellido.text,
                "fecha_nacimiento" : fechaNacimiento.text,
                "telefono" : telefono.text,
                "rfc" : rfc.text,
                "direccion" : direccion.text
            ]
            
            guard let url = URL(string: urlOferta) else { return }
            
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
                    
                }
            }.resume()
            
            OperationQueue.main.addOperation({
                let alert = UIAlertController(title: "Aviso", message: "Datos guardados", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert,animated:true,completion:nil)
            })
            
        }
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
        
        rendimientoTotal.text = "$ "+numberF.string(from: NSNumber(value: total ) )!
    }
}

