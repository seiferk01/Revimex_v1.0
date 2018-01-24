//
//  AppDelegate.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import IQKeyboardManagerSwift
import Material


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //para ocultar la barra de status en el splashScreen
        application.isStatusBarHidden = true;
        
        //???????
        IQKeyboardManager.sharedManager().enable = true;
        
        //si ya se tiene un id de usuario hace una llamada al login para verificar que sigue activo
        if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
            logIn()
        }
        
        //para el uso del sdk de places de google
        GMSServices.provideAPIKey("AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q")
        GMSPlacesClient.provideAPIKey("AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q")
        
        //variable para verificar si es la primera vez que se abre la aplicacion
        var isFirstTime = true
        if let firstTime = UserDefaults.standard.object(forKey: "isFirstTime") as? Bool{
            isFirstTime = firstTime
        }
        
        //si no es la primera vez que se abre la aplicacion, asigna el controller de stock como principal
        if isFirstTime == false {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "navigationManager")
        
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        
        //para el login con google
        GIDSignIn.sharedInstance().clientID = "1096846608841-27vv0035g8t3u84ea1i9hnamikc8r9kg.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
        //para el loggin con facebook
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        //para el loggin con facebook
        FBSDKAppEvents.activateApp()
        
    }
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //para login con facebook
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    //para login con google
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print(userId)
            print(idToken)
            print(fullName)
            print(givenName)
            print(familyName)
            print(email)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }

    

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
    //llamada de login 
    func logIn(){
        
        var usuario = ""
        var contraseña = ""
        
        if let us = UserDefaults.standard.object(forKey: "usuario") as? String{
            usuario = us
        }
        if let pass = UserDefaults.standard.object(forKey: "contraseña") as? String{
            contraseña = pass
        }
        
        
        let urlRequestFiltros = "http://18.221.106.92/api/public/user/login"
        
        let parameters: [String:Any] = [
            "email" : usuario,
            "password" : contraseña
        ]
        
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
                    print(json["status"] as! Int)
                    print(json["mensaje"] as! String)
                    
                    switch (json["status"] as! Int) {
                        case 1:
                            if let userId = (json["user_id"] as? Int){
                                UserDefaults.standard.set(usuario, forKey: "usuario")
                                UserDefaults.standard.set(contraseña, forKey: "contraseña")
                                UserDefaults.standard.set(userId, forKey: "userId")
                            }
                        default:
                            UserDefaults.standard.removeObject(forKey: "userId")
                    }
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                
            }
        }.resume()
            
    
        
    }


}

