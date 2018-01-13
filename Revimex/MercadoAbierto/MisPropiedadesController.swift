//
//  MisPropiedadesController.swift
//  Revimex
//
//  Created by Maquina 53 on 06/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class MisPropiedadesController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var subirPropiedad: FABButton!
    
    @IBOutlet public weak var tableMisPropiedades: UITableView!
    public var data: [String]!;

    override func viewDidLoad() {
        super.viewDidLoad()
        data = [];
        iniFlBtn();
        
        tableMisPropiedades.dataSource = self;
        tableMisPropiedades.translatesAutoresizingMaskIntoConstraints = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iniFlBtn(){
        subirPropiedad.image = Icon.cm.add;
        subirPropiedad.tintColor = Color.white;
        subirPropiedad.backgroundColor = Color.black;
        subirPropiedad.addTarget(self, action: #selector(nuevaPropiedad), for: .touchUpInside);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableMisPropiedades.dequeueReusableCell(withIdentifier: "cellMisPropiedades") as! MisPropiedadesCellController;
        return cell;
    }
    
    @objc func nuevaPropiedad() {
        performSegue(withIdentifier: "nuevaPropiedad", sender: nil);
    }
    
    
    
}