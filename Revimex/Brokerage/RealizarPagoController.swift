//
//  RealizarPagoController.swift
//  Revimex
//
//  Created by Hector Morales on 05/02/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class RealizarPagoController: UIViewController {

    
    var ancho = CGFloat()
    var largo = CGFloat()
    
    var timerLabel = UILabel()
    
    var seconds = 259200
    var timer = Timer()
    var isTimerRunning = false
    
    
    let pagarBtn = UIButton()
    let checkBox = UIButton()
    
    var terminosAceptados = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = instanciaEtapasBrokerageController.contenedorVistas.frame
        
        ancho = view.bounds.width
        largo = view.bounds.height
        
        
        runTimer()
        
        formaPago()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    
    func timeString(time:TimeInterval) -> String {
        
        let dias = (Int(time) / 3600)/24
        let hours = Int(time) / 3600 % 24
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%i dias %02i:%02i:%02i", dias, hours, minutes, seconds)
    }
    
    
    
    func formaPago(){
        
        
        let titulo = UILabel()
        titulo.text = "Realizar pago"
        titulo.font = UIFont.fontAwesome(ofSize: 20.0)
        titulo.frame = CGRect(x:0, y:0, width: ancho, height: largo*0.1)
        
        let subtitulo = UILabel()
        subtitulo.text = "Tiempo restante para realizar su pago"
        subtitulo.textAlignment = .center
        subtitulo.frame = CGRect(x:0, y:largo*0.07, width: ancho, height: largo*0.1)
        
        timerLabel.font = UIFont(name: "CourierNewPSMT ", size: 15.0)
        timerLabel.text = "0 dias 00:00:00"
        timerLabel.textAlignment = .center
        timerLabel.frame = CGRect(x:0, y:largo*0.15, width: ancho, height: largo*0.15)
        
        let imagen = UIImageView(image: UIImage(named: "formasPago.png"))
        imagen.frame = CGRect(x:ancho*0.05, y:largo*0.3, width: ancho*0.8, height: largo*0.35)
        imagen.contentMode = .scaleAspectFit
        imagen.clipsToBounds = true
        
        let aceptar = UITapGestureRecognizer(target: self, action: #selector(aceptarTerminos(tapGestureRecognizer:)))
        checkBox.setBackgroundImage(UIImage(named: "unchecked.png"), for: .normal)
        checkBox.frame = CGRect(x:ancho*0.25, y:largo*0.7, width: largo*0.05, height: largo*0.05)
        checkBox.contentMode = .scaleAspectFit
        checkBox.clipsToBounds = true
        checkBox.addGestureRecognizer(aceptar)
        
        let mostrarTerminos = UITapGestureRecognizer(target: self, action: #selector(mostrarTerminosCondiciones(tapGestureRecognizer:)))
        let terminos = UIButton()
        terminos.setTitle("He leido y acepto los terminos y condiciones", for: .normal)
        terminos.setTitleColor(azulObscuro, for: .normal)
        terminos.frame = CGRect(x:ancho*0.33, y:largo*0.65, width: ancho*0.67, height: largo*0.15)
        terminos.titleLabel?.font = UIFont(name: "Marion-Italic", size: 15.0)
        terminos.titleLabel?.textAlignment = .left
        terminos.addGestureRecognizer(mostrarTerminos)
        
        let pagar = UITapGestureRecognizer(target: self, action: #selector(realizarPago(tapGestureRecognizer:)))
        pagarBtn.frame = CGRect(x:ancho/4, y:largo*0.9, width: ancho/2, height: largo*0.06)
        pagarBtn.setTitle("Pagar y Continuar", for: .normal)
        pagarBtn.setTitleColor(UIColor.black, for: .normal)
        pagarBtn.layer.borderColor = UIColor.black.cgColor
        pagarBtn.layer.borderWidth = 0.5
        pagarBtn.addGestureRecognizer(pagar)
        
        
        view.addSubview(titulo)
        view.addSubview(subtitulo)
        view.addSubview(timerLabel)
        view.addSubview(imagen)
        view.addSubview(checkBox)
        view.addSubview(terminos)
        view.addSubview(pagarBtn)
        
    }
    
    
    @objc func aceptarTerminos(tapGestureRecognizer: UITapGestureRecognizer) {
        terminosAceptados = !(terminosAceptados)
        
        if terminosAceptados{
            checkBox.setBackgroundImage(UIImage(named: "checked.png"), for: .normal)
        }
        else{
            checkBox.setBackgroundImage(UIImage(named: "unchecked.png"), for: .normal)
        }
    }
    
    @objc func mostrarTerminosCondiciones(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Terminos y condiciones", message: "Estos seran los terminos y condiciones para realizar el pago por medio de la aplicacion movil", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }
    
    
    //funcion para registrar avance del brokerage y realizar pago(PENDIENTE), se envia el estatus "pago_realizado" y la propiedad queda con estatus "Pago realizado"
    @objc func realizarPago(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var estatus = "pago_realizado"
        
        //integrar aqui servicio para realizar pago
        
        
        if terminosAceptados{
            instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
        }
        else{
            let alert = UIAlertController(title: "Aviso", message: "Acepta los terminos y condiciones para continuar", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated:true,completion:nil)
        }
        
    }


}
