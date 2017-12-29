//
//  LineasNegociosControllerViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class LineasNegociosController: UIViewController {
    
    @IBOutlet weak var btnClienteFinal: UIButton!
    @IBOutlet weak var btnMercadoAbierto: UIButton!
    @IBOutlet weak var btnInversionista: UIButton!
    @IBOutlet weak var btnBrokerage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        let anchoPantalla = view.bounds.width
        let largoBan = ((view.bounds.height - ((navigationController?.navigationBar.bounds.height)!+20+tabBarHeight!)) / 4) - 2
        let top = (navigationController?.navigationBar.bounds.height)!+20
        
        self.setCustomBackgroundAndNavbar()
        btnClienteFinal.frame = CGRect(x:0,y:top,width:anchoPantalla+2,height:largoBan)
        btnClienteFinal.layer.borderWidth = 0.5
        btnClienteFinal.layer.borderColor = UIColor.gray.cgColor
        btnMercadoAbierto.frame = CGRect(x:0,y:top+largoBan+2,width:anchoPantalla,height:largoBan)
        btnMercadoAbierto.layer.borderWidth = 0.5
        btnMercadoAbierto.layer.borderColor = UIColor.gray.cgColor
        btnInversionista.frame = CGRect(x:0,y:top+(largoBan+2) * 2,width:anchoPantalla,height:largoBan)
        btnInversionista.layer.borderWidth = 0.5
        btnInversionista.layer.borderColor = UIColor.gray.cgColor
        btnBrokerage.frame = CGRect(x:0,y: top+(largoBan+2) * 3,width:anchoPantalla,height:largoBan)
        btnBrokerage.layer.borderWidth = 0.5
        btnBrokerage.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func actionBrokerage(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let formContainer = storyboard.instantiateViewController(withIdentifier: "MisBrokerages");
        
        
        navigationController?.pushViewController(formContainer, animated: true);
    }
    
    
}
