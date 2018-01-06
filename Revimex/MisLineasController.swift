//
//  MisLineasController.swift
//  Revimex
//
//  Created by Seifer on 02/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class MisLineasController: UIViewController {
    
    var tapGesture: UITapGestureRecognizer!;
    var menuContainer: UIView!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar();
        
        instanciaMisLineasController = self
        
        self.navigationController?.isNavigationBarHidden = false;
        
        menuContextual()
        
        iniMenu();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imagenCuentaBtn.setBackgroundImage(UIImage(named: "cuenta.png"), for: .normal);
        imagenCuentaBtn.removeGestureRecognizer(tapGesture);
        super.viewWillDisappear(animated);
    }
    
    func menuContextual(){
        imagenCuentaBtn.setBackgroundImage(UIImage(named:"menu-horizontal-100.png"), for: .normal);
        tapGesture = UITapGestureRecognizer(target: self,action: #selector(menuTapped(tapGestureRecognizer:)));
        imagenCuentaBtn.addGestureRecognizer(tapGesture);
    }
    
    //Crear menu contextual
    private func iniMenu(){
        
        let screenSize = UIScreen.main.bounds;
        let navigation = navigationController?.navigationBar.frame;
        let posY = navigation?.maxY;
        let posX = navigation?.maxX;
        
        menuContainer = UIView();
        menuContainer.frame = CGRect(x: posX! - (screenSize.width*(0.35)) - 5, y: posY!, width: screenSize.width*(0.35), height: view.bounds.height*0.15);
        menuContainer.backgroundColor = UIColor.white;
        menuContainer.layer.masksToBounds = false;
        menuContainer.layer.shadowRadius = 2.0;
        menuContainer.layer.shadowColor = UIColor.gray.cgColor;
        menuContainer.layer.shadowOffset = CGSize(width: 0.7, height: 0.7);
        menuContainer.layer.shadowOpacity = 0.5;
        menuContainer.isHidden = true;
        
        let subScreen = menuContainer.bounds;
        
        let logOutBtn = UIButton();
        logOutBtn.frame = CGRect(x: 0, y:subScreen.height*0.5, width: subScreen.width, height: subScreen.height*0.5);
        logOutBtn.setTitle("Cerrar Sesión", for: .normal);
        logOutBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
        logOutBtn.setTitleColor(UIColor.black, for: .normal);
        logOutBtn.backgroundColor = UIColor.white;
        logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside);
        
        let infoPerfilBtn = UIButton();
        infoPerfilBtn.frame = CGRect(x: 0, y:0, width: subScreen.width, height: subScreen.height*0.5);
        infoPerfilBtn.setTitle("Datos de Usuario", for: .normal);
        infoPerfilBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
        infoPerfilBtn.setTitleColor(UIColor.black, for: .normal);
        infoPerfilBtn.backgroundColor = UIColor.white;
        infoPerfilBtn.addTarget(self, action: #selector(infoUsuario), for: .touchUpInside);
        
        menuContainer.addSubview(infoPerfilBtn);
        menuContainer.addSubview(logOutBtn);
        
        view.addSubview(menuContainer);
    }
    
    
    func crearTabs(){
        
    }
    
    
    @objc func menuTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuContainer.isHidden = !menuContainer.isHidden
    }
    
    @objc func logOut(){
        UserDefaults.standard.removeObject(forKey: "usuario");
        UserDefaults.standard.removeObject(forKey: "contraseña");
        UserDefaults.standard.removeObject(forKey: "userId");
        navBarStyleCase = 0;
        performSegue(withIdentifier: "infoToLogin", sender: nil)
    }
    
    @objc func infoUsuario(){
        imagenCuentaBtn.isHidden = true
        performSegue(withIdentifier: "infoToUserInfo", sender: nil)
        menuContainer.isHidden = true
    }


}
