//
//  MisInversionesController.swift
//  Revimex
//
//  Created by Seifer on 09/01/18.
//  Copyright © 2018 Revimex. All rights reserved.
//

import UIKit
import Material

class MisInversionesController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var nuevaInversionBtn: FABButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        iniFlBtn();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iniFlBtn(){
        nuevaInversionBtn.image = Icon.cm.add
        nuevaInversionBtn.tintColor = UIColor.white
        nuevaInversionBtn.backgroundColor = azulObscuro
        nuevaInversionBtn.addTarget(self, action: #selector(nuevaInversion), for: .touchUpInside)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @objc func nuevaInversion() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nuevaInversionCtrl = storyboard.instantiateViewController(withIdentifier: "NuevaInversion") as! InversionistaController
        navigationController?.present(nuevaInversionCtrl, animated: true, completion: nil)
    }

}
