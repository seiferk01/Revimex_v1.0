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
        titulo.frame = CGRect(x:0, y:largo*0.05, width: ancho, height: largo*0.15)
        
        let subtitulo = UILabel()
        subtitulo.text = "Tiempo restante para realizar su pago"
        subtitulo.textAlignment = .center
        subtitulo.frame = CGRect(x:0, y:largo*0.15, width: ancho, height: largo*0.15)
        
        timerLabel.font = UIFont(name: "CourierNewPSMT ", size: 15.0)
        timerLabel.text = "0 dias 00:00:00"
        timerLabel.textAlignment = .center
        timerLabel.frame = CGRect(x:0, y:largo*0.3, width: ancho, height: largo*0.15)
        
        let imagen = UIImageView(image: UIImage(named: "formasPago.png"))
        imagen.frame = CGRect(x:ancho*0.05, y:largo*0.45, width: ancho*0.8, height: largo*0.35)
        imagen.contentMode = .scaleAspectFit
        imagen.clipsToBounds = true
        
        
        let pagar = UITapGestureRecognizer(target: self, action: #selector(realizarPago(tapGestureRecognizer:)))
        let pagarBtn = UIButton()
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
        view.addSubview(pagarBtn)
        
    }
    
    
    @objc func realizarPago(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var estatus = "pago_realizado"
        
        //integrar aqui servicio para realizar pago
        
        instanciaEtapasBrokerageController.mostrarEtapa(estatus: estatus)
        
    }


}
