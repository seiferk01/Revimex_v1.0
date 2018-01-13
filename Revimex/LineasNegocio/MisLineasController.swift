//
//  MisLineasController.swift
//  Revimex
//
//  Created by Seifer on 02/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit

class MisLineasController: UIViewController {
    
    @IBOutlet weak var vistasContainer: UIView!
    
    
    var misPropiedadesBtn = UIButton()
    var misInversionesBtn = UIButton()
    var misBrokeragesBtn = UIButton()
    
    var tapGesture: UITapGestureRecognizer!;
    var menuContainer: UIView!;
    
    var misPropiedades:UIViewController?
    var misInversiones:UIViewController?
    var misBrokerages:UIViewController?
    
    var arrayViews:[UIViewController?]!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar();
        
        instanciaMisLineasController = self
        
        self.navigationController?.isNavigationBarHidden = false;
        
        crearTabs()
        
        menuContextual()
        
        iniMenu();
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imagenCuentaBtn.setBackgroundImage(UIImage(named: "cuenta.png"), for: .normal);
        imagenCuentaBtn.removeGestureRecognizer(tapGesture);
        super.viewWillDisappear(animated);
    }
    
    
    //**************************funciones para crear el menu contextual**********************************
    func menuContextual(){
        imagenCuentaBtn.setBackgroundImage(UIImage(named:"menu-horizontal-100.png"), for: .normal);
        tapGesture = UITapGestureRecognizer(target: self,action: #selector(menuTapped(tapGestureRecognizer:)));
        imagenCuentaBtn.addGestureRecognizer(tapGesture);
    }
    
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
    
    //*****************************funciones para manejo de las vistas******************************
    func crearTabs(){
        
        let tapMisPropiedades = UITapGestureRecognizer(target: self, action: #selector(mostrarMisPropiedades(tapGestureRecognizer:)))
        let tapMisInversiones = UITapGestureRecognizer(target: self, action: #selector(mostrarMisInversiones(tapGestureRecognizer:)))
        let tapMisBrokerages = UITapGestureRecognizer(target: self, action: #selector(mostrarMisBrokerages(tapGestureRecognizer:)))
        
        misPropiedadesBtn = tabStyle(position: 0,tab: misPropiedadesBtn,titulo: "Mis Propiedades")
        misInversionesBtn = tabStyle(position: 1,tab: misInversionesBtn,titulo: "Mis Inversiones")
        misBrokeragesBtn = tabStyle(position: 2,tab: misBrokeragesBtn,titulo: "Mis Brokerages")
        
        misPropiedadesBtn.addGestureRecognizer(tapMisPropiedades)
        misInversionesBtn.addGestureRecognizer(tapMisInversiones)
        misBrokeragesBtn.addGestureRecognizer(tapMisBrokerages)
        
        view.addSubview(misPropiedadesBtn)
        view.addSubview(misInversionesBtn)
        view.addSubview(misBrokeragesBtn)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        misPropiedades = storyboard.instantiateViewController(withIdentifier: "MisPropiedades") as! MisPropiedadesController
        misInversiones = storyboard.instantiateViewController(withIdentifier: "MisInversiones") as! MisInversionesController
        misBrokerages = storyboard.instantiateViewController(withIdentifier: "MisBrokerages") as! MisBrokerageViewController
        
        arrayViews = [misPropiedades,misInversiones,misBrokerages]
        
        actualViewController = arrayViews[0];
        
    }
    
    func tabStyle(position: Int, tab: UIButton,titulo: String)->UIButton{
        
        let ancho = view.bounds.width * 0.333
        let largo = view.bounds.height * 0.05
        let top = (navigationController?.navigationBar.bounds.height)!+20
        
        vistasContainer.frame = CGRect(x:0,y:top + largo,width:view.bounds.width,height:view.bounds.height - top - largo)
        misPropiedadesBtn.setTitleColor(azul, for: .normal)
        
        tab.frame = CGRect(x:ancho*CGFloat(position), y: top, width: ancho, height:largo)
        tab.setTitle(titulo, for: .normal)
        tab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        tab.setTitleColor(UIColor.white, for: .normal)
        tab.layer.borderWidth = 0.5
        tab.layer.borderColor = UIColor.white.cgColor
        
        return tab
    }
    
    private var actualViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = actualViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = vistasContainer.bounds;
            vistasContainer.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    @objc func mostrarMisPropiedades(tapGestureRecognizer: UITapGestureRecognizer){
        misPropiedadesBtn.setTitleColor(azul, for: .normal)
        misInversionesBtn.setTitleColor(UIColor.white, for: .normal)
        misBrokeragesBtn.setTitleColor(UIColor.white, for: .normal)
        actualViewController = arrayViews[0];
    }
    
    @objc func mostrarMisInversiones(tapGestureRecognizer: UITapGestureRecognizer){
        misPropiedadesBtn.setTitleColor(UIColor.white, for: .normal)
        misInversionesBtn.setTitleColor(azul, for: .normal)
        misBrokeragesBtn.setTitleColor(UIColor.white, for: .normal)
        actualViewController = arrayViews[1];
    }
    
    @objc func mostrarMisBrokerages(tapGestureRecognizer: UITapGestureRecognizer){
        misPropiedadesBtn.setTitleColor(UIColor.white, for: .normal)
        misInversionesBtn.setTitleColor(UIColor.white, for: .normal)
        misBrokeragesBtn.setTitleColor(azul, for: .normal)
        actualViewController = arrayViews[2];
    }
    


}
