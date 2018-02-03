//
//  UbicationContoller.swift
//  Revimex
//
//  Created by Seifer on 11/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import GoogleMaps

class UbicationContoller: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var sevicesConatiner: UIView!
    
    
    var mapView: GMSMapView!
    var markerList = [GMSMarker]()
    var marcadorServicio = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        sevicesConatiner.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view?.backgroundColor = UIColor(white: 1, alpha: 0)
        
        crearMapa()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func crearMapa(){
        //inicia asignacion de valores al mapa
        let screenSize = instanciaDescripcionController.vistasContainer.bounds
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(propiedad.lat)!, longitude: Double(propiedad.lon)!, zoom: 15)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0,y: 0,width: screenSize.width,height: screenSize.height), camera: camera)
        mapView.delegate = self
        
        do {
            if let styleURL = Bundle.main.url(forResource: "customWhiteStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        
        //agrega el marcador principal
        addPrincipalMarker()
    }
    
    //funciones para mostrar servicios
    @IBAction func mostrarSuperMercados(_ sender: Any) {
        
        mapView.clear()
        addPrincipalMarker()
        buscarServicios(servicio: "shopping_mall")
        
    }
    
    @IBAction func mostrarRestaurantes(_ sender: Any) {
        
        mapView.clear()
        addPrincipalMarker()
        buscarServicios(servicio: "restaurant")
        
    }
    
    @IBAction func mostrarEscuelas(_ sender: Any) {
        
        mapView.clear()
        addPrincipalMarker()
        buscarServicios(servicio: "school")
        
    }
    
    @IBAction func mostrarTiendas(_ sender: Any) {
        
        mapView.clear()
        addPrincipalMarker()
        buscarServicios(servicio: "convenience_store")
        
    }
    
    @IBAction func mostrarHospitales(_ sender: Any) {
        
        mapView.clear()
        addPrincipalMarker()
        buscarServicios(servicio: "hospital")
        
    }
    
    @IBAction func mostrarParques(_ sender: Any) {
        
        mapView.clear()
        addPrincipalMarker()
        buscarServicios(servicio: "park")
        
    }
    
    
    //agrega el marcador principal al mapa
    func addPrincipalMarker(){
        
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(propiedad.lat)!, longitude: CLLocationDegrees(propiedad.lon)!)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "houseMarker.png")
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.title = propiedad.estado
        marker.map = mapView
        
    }
    
    //request al api de google para localizar servicios
    func buscarServicios(servicio: String){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        markerList = []
        marcadorServicio = servicio
        
        let apiGoogle = "AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q"
        
        let inicioUrl =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + propiedad.lat + "," + propiedad.lon
        
        let urlRequestGoogle = inicioUrl+"&radius=2000&types=" + servicio + "&key=" + apiGoogle
        
        print("URL: " + urlRequestGoogle)
        
        guard let url = URL(string: urlRequestGoogle) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    if let results = json["results"] as? NSObject{
                    
                        if let resArray = results as? NSArray{
                            for result in resArray {
                                
                                var nombre = ""
                                var direccion = ""
                                
                                if let result = result as? NSDictionary{
                                    
                                    print(result)
                                    if let nom = result["name"] as? String {
                                        nombre = nom
                                    }
                                    if let dir = result["vicinity"] as? String {
                                        direccion = dir
                                    }
                                    
                                    if let geometry = result["geometry"] as? NSDictionary {
                                        if let location = geometry["location"] as? NSDictionary{
                                            if let lat = location["lat"] as? Double, let lon = location["lng"] as? Double {
                                                
                                                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                                let marker = GMSMarker(position: position)
                                                marker.appearAnimation = GMSMarkerAnimation.pop
                                                marker.title = nombre + "\n" + direccion
                                                
                                                self.markerList.append(marker)
                                                
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    OperationQueue.main.addOperation({
                        self.agregarMarcadorServicio()
                        activityIndicator.stopAnimating()
                        background.removeFromSuperview()
                    })
                    
                }catch {
                    print(error)
                }
                
            }
            }.resume()
        
        
    }
    
    //agrega los marcadores de servicios encontrados
    func agregarMarcadorServicio(){
        
        
        var bounds = GMSCoordinateBounds()
        
        for marker in markerList {
            bounds = bounds.includingCoordinate(marker.position)
            
            switch marcadorServicio{
            case "shopping_mall":
                marker.icon = UIImage(named: "shopping_mall.png")
                break
            case "restaurant":
                marker.icon = UIImage(named: "restaurant.png")
                break
            case "school":
                marker.icon = UIImage(named: "school.png")
                break
            case "convenience_store":
                marker.icon = UIImage(named: "convenience_store.png")
                break
            case "hospital":
                marker.icon = UIImage(named: "hospital.png")
                break
            case "park":
                marker.icon = UIImage(named: "park.png")
                break
            default:
                marker.icon = UIImage(named: "houseMarker.png")
                break
            }
            
            marker.map = self.mapView
        }
        
        CATransaction.begin()
        CATransaction.setValue(NSNumber(value: 1.5), forKey: kCATransactionAnimationDuration)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        CATransaction.commit()
        
    }
    

}
