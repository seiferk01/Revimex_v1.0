//
//  InversionistaController.swift
//  Revimex
//
//  Created by Seifer on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
import Motion
import GooglePlaces

extension InversionistaController: TextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        selectionPicker(campoDeTexto: textField)
        
        return false
    }
}

extension InversionistaController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayDatosPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayDatosPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            metrosTerreno.text = arrayDatosPicker[row]
            metrosTerr.text = arrayDatosPicker[row]
            terrenoFiltro = row
            break
        case 2:
            metrosConstruccion.text = arrayDatosPicker[row]
            metrosCons.text = arrayDatosPicker[row]
            construccionFiltro = row
            break
        case 3:
            numeroRecamaras.text = arrayDatosPicker[row]
            recamaras.text = arrayDatosPicker[row]
            recamarasFiltro = row
            break
        case 4:
            numeroBanos.text = arrayDatosPicker[row]
            banos.text = arrayDatosPicker[row]
            banosFiltro = row
            break
        case 5:
            ordenadasPor.text = arrayDatosPicker[row]
            break
        case 6:
            montoInversion.text = arrayDatosPicker[row]
            monto.text = arrayDatosPicker[row]
            precioMax = Int(arrayDatosPicker[row])!
            if row == 0{
                precioMax = 1000000000
            }
            break
        default:
            print("Caso no especificado")
        }
    }
}


class InversionistaController: UIViewController, GMSAutocompleteViewControllerDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var formatedAddress = "México"
    var terrenoFiltro = 0
    var construccionFiltro = 0
    var recamarasFiltro = 0
    var banosFiltro = 0
    var precioMax = 1000000000
    var precioMaxBase = 1000000000
    var precioMin = 0
    var escriturasFiltro = 0
    var invasionFiltro = 0
    
    var northeastLat: Double = 32.7186534
    var northeastLng: Double = -86.5887
    var southwestLat: Double = 14.3895
    var southwestLng: Double = -118.6523001
    var locationLat: Double = 23.634501
    var locationLng: Double = -102.552784
    
    
    let navegacion = UIView()
    var contenedorFiltros = UIView()
    var filtrosSeleccionados = UIView()
    
    let busqueda = TextField()
    let metrosTerreno = TextField()
    let metrosConstruccion = TextField()
    let numeroRecamaras = TextField()
    let numeroBanos = TextField()
    let ordenadasPor = TextField()
    let conSinEscrituras = UISwitch()
    let conSinInvasion = UISwitch()
    let montoInversion = TextField()
    
    let tituloFiltros = UILabel()
    let lugar = TextField()
    let escrituras = TextField()
    let monto = TextField()
    let invasion = TextField()
    let metrosTerr = TextField()
    let metrosCons = TextField()
    let recamaras = TextField()
    let banos = TextField()
    
    var arrayDatosPicker: [String] = []
    
    
    class PropiedadInvesion{
        
        var estado:String = ""
        var calle:String = ""
        var precio:String = ""
        var foto = UIImage()
        var id = ""
        
        init(){
            
        }
    }
    
    var arrayPropiedades:[PropiedadInvesion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearVista()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        instanciaMisLineasController.menuContextual()
//    }
    
    
    func crearVista(){
        
        
        screenWidth = view.bounds.width
        screenHeight = view.bounds.height
        
        navegacion.frame = CGRect(x:0, y:0, width: screenWidth, height: screenHeight*0.08)
        contenedorFiltros.frame = CGRect(x:0, y:(navegacion.bounds.height)+0.5, width: screenWidth, height: screenHeight*0.6)
        
        let ancho = contenedorFiltros.bounds.width
        let largo = contenedorFiltros.bounds.height * 0.15
        
        let cancelarProceso = UITapGestureRecognizer(target: self, action: #selector(cancelProcess(tapGestureRecognizer:)))
        let cancelar = UIButton()
        cancelar.setTitle("Cancelar", for: .normal)
        cancelar.setTitleColor(UIColor.black, for: .normal)
        cancelar.frame = CGRect(x:0, y:0, width: screenWidth*0.3, height: navegacion.bounds.height + 25)
        cancelar.addGestureRecognizer(cancelarProceso)
        
        let continuar = UITapGestureRecognizer(target: self, action: #selector(irCarrito(tapGestureRecognizer:)))
        let carrito = UIButton()
        carrito.setTitle("Carrito", for: .normal)
        carrito.setTitleColor(UIColor.black, for: .normal)
        carrito.frame = CGRect(x:screenWidth*0.7, y:0, width: screenWidth*0.3, height: navegacion.bounds.height + 25)
        carrito.addGestureRecognizer(continuar)
        
        let titulo = UILabel()
        titulo.frame = CGRect(x:0 ,y:0, width: ancho, height: largo)
        titulo.font = UIFont.boldSystemFont(ofSize: 18.0)
        titulo.text = "Invierte de manera sencilla con Revimex"
        titulo.textAlignment = .center
        
        
        busqueda.colorEnable()
        busqueda.delegate = self
        busqueda.placeholder = "Donde quieres invertir?"
        busqueda.frame = CGRect(x:ancho*0.1 ,y:largo, width: ancho*0.8, height: largo/2)
        
        
        metrosTerreno.colorEnable()
        metrosTerreno.delegate = self
        metrosTerreno.placeholder = "Metros de terreno"
        metrosTerreno.font = UIFont.fontAwesome(ofSize: 12.0)
        metrosTerreno.frame = CGRect(x:ancho*0.1 ,y:largo*2, width: ancho*0.35, height: largo/2)
        
        metrosConstruccion.colorEnable()
        metrosConstruccion.delegate = self
        metrosConstruccion.placeholder = "Metros de construccion"
        metrosConstruccion.font = UIFont.fontAwesome(ofSize: 12.0)
        metrosConstruccion.frame = CGRect(x:ancho*0.55 ,y:largo*2, width: ancho*0.35, height: largo/2)
        
        
        numeroRecamaras.colorEnable()
        numeroRecamaras.delegate = self
        numeroRecamaras.placeholder = "Recamaras"
        numeroRecamaras.font = UIFont.fontAwesome(ofSize: 12.0)
        numeroRecamaras.frame = CGRect(x:ancho*0.1 ,y:largo*3, width: ancho*0.35, height: largo/2)
        
        numeroBanos.colorEnable()
        numeroBanos.delegate = self
        numeroBanos.placeholder = "Baños"
        numeroBanos.font = UIFont.fontAwesome(ofSize: 12.0)
        numeroBanos.frame = CGRect(x:ancho*0.55 ,y:largo*3, width: ancho*0.35, height: largo/2)
        
        
        ordenadasPor.colorEnable()
        ordenadasPor.delegate = self
        ordenadasPor.placeholder = "Ordenar por"
        ordenadasPor.font = UIFont.fontAwesome(ofSize: 12.0)
        ordenadasPor.frame = CGRect(x:ancho*0.1 ,y:largo*4, width: ancho*0.3, height: largo/2)
        
        conSinEscrituras.frame = CGRect(x:ancho*0.5 ,y:(largo*0.05)+(largo*4), width: ancho*0.2, height: largo)
        conSinEscrituras.addTarget(self, action: #selector(conSinEscriturasValueDidChange(_:)), for: .valueChanged)
        let tituloEscrituras = UILabel()
        tituloEscrituras.frame = CGRect(x:ancho*0.5 ,y:(largo*0.05)+(largo*4)-conSinEscrituras.bounds.height, width: ancho*0.2, height: largo/3)
        tituloEscrituras.font = UIFont.fontAwesome(ofSize: 12.0)
        tituloEscrituras.text = "Escrituras"
        
        conSinInvasion.frame = CGRect(x:ancho*0.8 ,y:(largo*0.05)+(largo*4), width: ancho*0.2, height: largo)
        conSinInvasion.addTarget(self, action: #selector(conSinInvasionValueDidChange(_:)), for: .valueChanged)
        let tituloInvasion = UILabel()
        tituloInvasion.frame = CGRect(x:ancho*0.8 ,y:(largo*0.05)+(largo*4)-conSinInvasion.bounds.height, width: ancho*0.2, height: largo/3)
        tituloInvasion.font = UIFont.fontAwesome(ofSize: 12.0)
        tituloInvasion.text = "Invadidas"
        
        
        montoInversion.colorEnable()
        montoInversion.delegate = self
        montoInversion.placeholder = "Cuanto quieres invertir?"
        montoInversion.frame = CGRect(x:ancho*0.1 ,y:largo*5, width: ancho*0.8, height: largo/2)
        
        
        let buscarPropiedades = UITapGestureRecognizer(target: self, action: #selector(buscarPropiedadesInversion(tapGestureRecognizer:)))
        let botonBuscar = UIButton()
        botonBuscar.setTitle("Buscar", for: .normal)
        botonBuscar.setTitleColor(UIColor.black, for: .normal)
        botonBuscar.layer.borderColor = UIColor.black.cgColor
        botonBuscar.layer.borderWidth = 0.5
        botonBuscar.frame = CGRect(x:ancho*0.3 ,y:largo*6, width: ancho*0.4, height: largo/2)
        botonBuscar.addGestureRecognizer(buscarPropiedades)
        
        
        navegacion.addSubview(cancelar)
        navegacion.addSubview(carrito)
        contenedorFiltros.addSubview(titulo)
        contenedorFiltros.addSubview(busqueda)
        contenedorFiltros.addSubview(metrosTerreno)
        contenedorFiltros.addSubview(metrosConstruccion)
        contenedorFiltros.addSubview(numeroRecamaras)
        contenedorFiltros.addSubview(numeroBanos)
        contenedorFiltros.addSubview(ordenadasPor)
        contenedorFiltros.addSubview(tituloEscrituras)
        contenedorFiltros.addSubview(conSinEscrituras)
        contenedorFiltros.addSubview(tituloInvasion)
        contenedorFiltros.addSubview(conSinInvasion)
        contenedorFiltros.addSubview(montoInversion)
        contenedorFiltros.addSubview(botonBuscar)
        
        
        
        filtrosSeleccionados.alpha = 0
        filtrosSeleccionados.frame = CGRect(x:0 ,y:(navegacion.bounds.height)+0.5 ,width:contenedorFiltros.bounds.width ,height: contenedorFiltros.bounds.height/2)
        filtrosSeleccionados.tag = 100
        filtrosSeleccionados.backgroundColor = UIColor.white
        
        let filtrosSeleccionadosAncho = filtrosSeleccionados.bounds.width
        let filtrosSeleccionadosLargo = filtrosSeleccionados.bounds.height
        
        
        tituloFiltros.text = "Caracteristicas seleccionadas"
        tituloFiltros.font = UIFont.fontAwesome(ofSize: 17.0)
        tituloFiltros.textAlignment = .center
        tituloFiltros.frame = CGRect(x:0, y:0, width: filtrosSeleccionadosAncho, height: filtrosSeleccionadosLargo*0.15)
        
        
        lugar.font = UIFont.fontAwesome(ofSize: 12.0)
        lugar.isEnabled = false
        lugar.placeholder = "Lugar"
        lugar.textAlignment = .center
        lugar.frame = CGRect(x:0, y:filtrosSeleccionadosLargo*0.185, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        escrituras.font = UIFont.fontAwesome(ofSize: 12.0)
        escrituras.isEnabled = false
        escrituras.placeholder = "Escrituras"
        escrituras.textAlignment = .center
        escrituras.frame = CGRect(x:filtrosSeleccionadosAncho/2, y:filtrosSeleccionadosLargo*0.185, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        
        monto.font = UIFont.fontAwesome(ofSize: 12.0)
        monto.isEnabled = false
        monto.placeholder = "Monto"
        monto.textAlignment = .center
        monto.frame = CGRect(x:0, y:(filtrosSeleccionadosLargo*0.185)*2, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        invasion.font = UIFont.fontAwesome(ofSize: 12.0)
        invasion.isEnabled = false
        invasion.placeholder = "Invasion"
        invasion.textAlignment = .center
        invasion.frame = CGRect(x:filtrosSeleccionadosAncho/2, y:(filtrosSeleccionadosLargo*0.185)*2, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        
        metrosTerr.font = UIFont.fontAwesome(ofSize: 12.0)
        metrosTerr.isEnabled = false
        metrosTerr.placeholder = "Metros Terreno"
        metrosTerr.textAlignment = .center
        metrosTerr.frame = CGRect(x:0, y:(filtrosSeleccionadosLargo*0.185)*3, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        metrosCons.font = UIFont.fontAwesome(ofSize: 12.0)
        metrosCons.isEnabled = false
        metrosCons.placeholder = "Metros Construccion"
        metrosCons.textAlignment = .center
        metrosCons.frame = CGRect(x:filtrosSeleccionadosAncho/2, y:(filtrosSeleccionadosLargo*0.185)*3, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        
        recamaras.font = UIFont.fontAwesome(ofSize: 12.0)
        recamaras.isEnabled = false
        recamaras.placeholder = "Recamaras"
        recamaras.textAlignment = .center
        recamaras.frame = CGRect(x:0, y:(filtrosSeleccionadosLargo*0.185)*4, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        banos.font = UIFont.fontAwesome(ofSize: 12.0)
        banos.isEnabled = false
        banos.placeholder = "Baños"
        banos.textAlignment = .center
        banos.frame = CGRect(x:filtrosSeleccionadosAncho/2, y:(filtrosSeleccionadosLargo*0.185)*4, width: filtrosSeleccionadosAncho/2, height: (filtrosSeleccionadosLargo*0.16)/2)
        
        
        let busquedaNueva = UITapGestureRecognizer(target: self, action: #selector(nuevaBusquedaInversion(tapGestureRecognizer:)))
        let nuevaBusqueda = UIButton()
        nuevaBusqueda.setTitle("Nueva Busqueda", for: .normal)
        nuevaBusqueda.setTitleColor(UIColor.black, for: .normal)
        nuevaBusqueda.layer.borderColor = UIColor.black.cgColor
        nuevaBusqueda.layer.borderWidth = 0.5
        nuevaBusqueda.frame = CGRect(x:filtrosSeleccionadosAncho*0.3, y:filtrosSeleccionadosLargo*0.84, width: filtrosSeleccionadosAncho*0.4, height: filtrosSeleccionadosLargo*0.16)
        nuevaBusqueda.addGestureRecognizer(busquedaNueva)
        
        
        filtrosSeleccionados.addSubview(tituloFiltros)
        filtrosSeleccionados.addSubview(lugar)
        filtrosSeleccionados.addSubview(escrituras)
        filtrosSeleccionados.addSubview(monto)
        filtrosSeleccionados.addSubview(invasion)
        filtrosSeleccionados.addSubview(metrosTerr)
        filtrosSeleccionados.addSubview(metrosCons)
        filtrosSeleccionados.addSubview(recamaras)
        filtrosSeleccionados.addSubview(banos)
        filtrosSeleccionados.addSubview(nuevaBusqueda)
        
        
        view.addSubview(navegacion)
        view.addSubview(contenedorFiltros)
        
        view.sendSubview(toBack: tableView)
        tableView.alpha = 0
        tableView.frame = CGRect(x:0, y:((navegacion.bounds.height)+0.5)+filtrosSeleccionadosLargo ,width:filtrosSeleccionadosAncho, height: view.bounds.height - ((navegacion.bounds.height)+0.5)-filtrosSeleccionadosLargo)
        
    }
    
    
    @objc func cancelProcess(tapGestureRecognizer: UITapGestureRecognizer) {
        back(vista: self)
    }
    
    @objc func irCarrito(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "inversionToCart", sender: nil)
    }
    
    
    
    @objc func conSinEscriturasValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            escrituras.text = "Con escrituras"
            escriturasFiltro = 1
        }
        else{
            escrituras.text = "Todas"
            escriturasFiltro = 0
        }
    }
    
    @objc func conSinInvasionValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            invasion.text = "No Invadidas"
            invasionFiltro = 1
        }
        else{
            invasion.text = "Todas"
            invasionFiltro = 0
        }
    }
    
    @objc func buscarPropiedadesInversion(tapGestureRecognizer: UITapGestureRecognizer) {
        
        lugar.text = busqueda.text
        monto.text = montoInversion.text
        metrosTerr.text = metrosTerreno.text
        metrosCons.text = metrosConstruccion.text
        recamaras.text = numeroRecamaras.text
        banos.text = numeroBanos.text
        view.addSubview(filtrosSeleccionados)
        
        let top = contenedorFiltros.bounds.height/2
        let originalTransform = self.contenedorFiltros.transform
        let scaledTransform = originalTransform.scaledBy(x: 1, y: 0.5)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0, y: -top)
        UIView.animate(withDuration: 0.5, animations: {
            self.contenedorFiltros.transform = scaledAndTranslatedTransform
            self.filtrosSeleccionados.alpha = 1
            self.tableView.alpha = 1
        })
        
        getLocationDetails()
        
    }
    
    @objc func nuevaBusquedaInversion(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let top = contenedorFiltros.bounds.height/4
        let originalTransform = self.contenedorFiltros.transform
        let scaledTransform = originalTransform.scaledBy(x: 1, y: 2)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0, y: top)
        UIView.animate(withDuration: 0.5, animations: {
            self.contenedorFiltros.transform = scaledAndTranslatedTransform
            self.filtrosSeleccionados.alpha = 0
            self.tableView.alpha = 0
            
        },completion: { (finished: Bool) in
            if let oldFiltrosSeleccionados = self.view.viewWithTag(100){
                oldFiltrosSeleccionados.removeFromSuperview()
            }
        })
        
    }
    
    
    func selectionPicker(campoDeTexto: UITextField){
        
        var titulo = "Indefinido"
        arrayDatosPicker = []
        var identificador:Int = 0
        
        switch campoDeTexto {
        case busqueda:
            searchFieldTapped()
            break
        case metrosTerreno:
            identificador = 1
            titulo = "Cuantos metros de terreno?"
            arrayDatosPicker.append("Todas")
            arrayDatosPicker.append("1 - 50")
            arrayDatosPicker.append("51 - 100")
            arrayDatosPicker.append("101 - 200")
            arrayDatosPicker.append("200+")
            break
        case metrosConstruccion:
            identificador = 2
            titulo = "Cuantas recamaras?"
            arrayDatosPicker.append("Todas")
            arrayDatosPicker.append("1 - 50")
            arrayDatosPicker.append("51 - 100")
            arrayDatosPicker.append("101 - 200")
            arrayDatosPicker.append("200+")
            break
        case numeroRecamaras:
            identificador = 3
            titulo = "Cuantas recamaras?"
            arrayDatosPicker.append("Todas")
            var cont: Int = 1
            repeat{
                arrayDatosPicker.append(String(cont))
                cont += 1
            }while cont<5
            break
        case numeroBanos:
            identificador = 4
            titulo = "Cuantos baños?"
            arrayDatosPicker.append("Todas")
            var cont: Int = 1
            repeat{
                arrayDatosPicker.append(String(cont))
                cont += 1
            }while cont<4
            break
        case ordenadasPor:
            identificador = 5
            titulo = "Que deseas ver primero?"
            arrayDatosPicker.append("Mas baratas")
            arrayDatosPicker.append("Mas caras")
            break
        case montoInversion:
            identificador = 6
            titulo = "Cuanto deseas invertir?"
            arrayDatosPicker.append("Sin limite")
            var cont: Int = 100000
            repeat{
                arrayDatosPicker.append(String(cont))
                cont += 50000
            }while cont<1000001
            break
        default:
            print("No se agrego el caso")
            break
        }
        

        
        let alertPicker = UIAlertController(title: titulo, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerMetrosTerreno = UIPickerView(frame: CGRect(x:0, y:20, width: 250, height: 162))
        pickerMetrosTerreno.tag = identificador
        pickerMetrosTerreno.backgroundColor = UIColor(white: 1, alpha: 0.7)
        pickerMetrosTerreno.delegate = self
        pickerMetrosTerreno.dataSource = self
        alertPicker.view.addSubview(pickerMetrosTerreno)
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default){ action in
            //self.busqueda()
            //self.actualAlert.dismiss(animated: true, completion: nil)
        }
        alertPicker.addAction(actionAceptar)
        present(alertPicker, animated: true, completion: nil)
        
    }
    
    
    


    //*************************funciones del GMSAutocompleteViewControllerDelegate****************************
    //muestra la vista de autocomplete al hacer top en el campo de busqueda
    func searchFieldTapped() {
        //filtro para autocomplete
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.country = "MX"
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)

    }

    //Maneja la direccion del autocomplete seleccionada por el ususario
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        //asigna la direccion seleccionada en el autocomplete
        print("Place: \(place)")
        formatedAddress = place.formattedAddress!
        busqueda.text = formatedAddress
        lugar.text = formatedAddress
        dismiss(animated: true, completion: nil)

    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    

    //*********************request del geojson a google con la direccion seleccionada**************************
    func getLocationDetails(){

        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        busqueda.text = formatedAddress
        lugar.text = formatedAddress

        let encodedAddress = formatedAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let urlRequestDetails = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q&components=country:MX&address="+encodedAddress


        print(urlRequestDetails)

        guard let url = URL(string: urlRequestDetails) else { return }

        var request = URLRequest (url: url)
        request.httpMethod = "POST"


        let session  = URLSession.shared

        session.dataTask(with: request) { (data, response, error) in

            if let response = response {
                print(response)
            }

            if let data = data {

                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]

                    print(json)
                    if let selectedAdress = json["results"] as? NSArray,
                        let adress = selectedAdress[0] as? NSDictionary,
                        let adressGeometry = adress["geometry"] as? NSDictionary,
                        let location = adressGeometry["location"] as? NSDictionary,
                        let bounds = adressGeometry ["viewport"] as? NSDictionary,
                        let northeast = bounds["northeast"] as? NSDictionary,
                        let southwest = bounds["southwest"] as? NSDictionary {

                        self.northeastLat = northeast["lat"] as! Double
                        self.northeastLng = northeast["lng"] as! Double
                        self.southwestLat = southwest["lat"] as! Double
                        self.southwestLng = southwest["lng"] as! Double
                        self.locationLat = location["lat"] as! Double
                        self.locationLng = location["lng"] as! Double
                    }

                } catch {
                    print("El error es: ")
                    print(error)
                }

                OperationQueue.main.addOperation({
                    self.getPropertiesNearTo(lat: self.locationLat,lng: self.locationLng,swlat: self.southwestLat,swlng: self.southwestLng,nelat: self.northeastLat,nelng: self.northeastLng)
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })

            }
        }.resume()
    }



    //**********request a las propiedades dentro de los limites del lugar elegido de las sugerencias*************
    func getPropertiesNearTo(lat: Double,lng: Double,swlat: Double,swlng: Double,nelat: Double,nelng: Double){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayPropiedades = []
        
        let urlRequestFiltros = "http://18.221.106.92/api/public/propiedades/filtros"
     
        let parameters: [String:Any] = [
            "lat" : lat,
            "lng" : lng,
            "swlat" : swlat,
            "swlng" : swlng,
            "nelat" : nelat,
            "nelng" : nelng,
            "inv" : 1,
            "filters" : [
                "terreno" : terrenoFiltro,
                "const" : construccionFiltro,
                "rec" : recamarasFiltro,
                "banos" : banosFiltro,
                "order" : 0,
                "escritura" : escriturasFiltro,
                "invasion" : invasionFiltro
            ],
            "precio" : [
                "minPrecio" : precioMin,
                "maxPrecio" : precioMax
            ],
            "todos" : 0
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
                    if (json["error"] as! String) != "No hay resultados" {
                        for element in json["features"] as! NSArray{

                            if let propiedad = element as? NSDictionary {
                                
                                if let properties = propiedad["properties"] as? NSDictionary{

                                    let elemento = PropiedadInvesion()

                                    if let calle = properties["calle"] as? String{
                                        elemento.calle = calle
                                    }
                                    if let estado = properties["estado"] as? String {
                                        elemento.estado = estado
                                    }
                                    if let prec = properties["precio"] as? String {
                                        elemento.precio = "$" + prec
                                    }
                                    if let prec = properties["precio"] as? String {
                                        elemento.foto = Utilities.traerImagen(urlImagen: prec)
                                    }
                                    if let id = properties["ai"] as? Int{
                                        elemento.id = String(id)
                                    }
                                    
                                    
                                    self.arrayPropiedades.append(elemento)
                                    
                                }
                                
                            }

                        }
                    }
                    else{
                        let alert = UIAlertController(title: "Aviso", message: "No se encontraron propiedades", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(arrayPropiedades.count)
        return arrayPropiedades.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = tableView.dequeueReusableCell(withIdentifier: "inversionRow") as! InversionesViewCellController
        
        row.idOfertaActual = arrayPropiedades[indexPath.row].id
        row.estado.text = arrayPropiedades[indexPath.row].estado
        row.calle.text = arrayPropiedades[indexPath.row].calle
        row.precio.text = arrayPropiedades[indexPath.row].precio
        row.foto.image = arrayPropiedades[indexPath.row].foto
        row.foto.contentMode = .scaleAspectFill
        row.foto.clipsToBounds = true
        
        return row
    }
    

}
