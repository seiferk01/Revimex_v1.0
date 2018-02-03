//
//  NuevoBrokerageCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 28/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
//


class NuevoBrokerageCellController: UITableViewCell {
    
    @IBOutlet weak var txLbEstado: TextField!
    @IBOutlet weak var txLbMunicipio: TextField!
    @IBOutlet weak var txLbValorReferencia: TextField!
    @IBOutlet weak var txLbPrecioOriginal: TextField!
    @IBOutlet weak var imgPrincipal: UIImageView!
    
    var idBrokerage = -1
    
    var datos = UIView()
    var tabla = UITableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iniTexts();
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func iniTexts(){
        
        txLbEstado.placeholder = "Estado: ";
        txLbEstado.isEnabled = false;
        
        txLbMunicipio.placeholder = "Municipio: ";
        txLbMunicipio.isEnabled = false;
        
        txLbValorReferencia.placeholder = "Precio : ";
        txLbValorReferencia.isEnabled = false;
        
        txLbPrecioOriginal.placeholder = "Precio Original: ";
        txLbPrecioOriginal.isEnabled = false;
        
        imgPrincipal.image = UIImage.fontAwesomeIcon(name: .download, textColor: .black, size: CGSize(width: 500, height: 500));
        
    }
    
    public func setNuevoBrokerage(nuevoBrokerage:NuevoBrokerage!){
        idBrokerage = nuevoBrokerage.id_ai
        txLbEstado.text = nuevoBrokerage.estado;
        txLbMunicipio.text = nuevoBrokerage.municipio;
        txLbValorReferencia.text = nuevoBrokerage.valorReferencia;
        txLbPrecioOriginal.text = nuevoBrokerage.precioOriginal;
        if(!nuevoBrokerage.urlFotoPrincipal.isEmpty){
            obtnerImage(url: nuevoBrokerage.urlFotoPrincipal){ img in
                DispatchQueue.main.async {
                    self.imgPrincipal.image = img;
                }
            }
        }else{
            imgPrincipal.image = UIImage(named: "imagenNoEncontrada.png");
        }
    }
    
    public func obtnerImage(url:String!,completado:@escaping(_ image:UIImage)->Void){
        let urlEncoded = url.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlEncoded)else{return}
        URLSession.shared.dataTask(with: url){ (data,response,error) in
            guard let data = data else{return};
            print(data.base64EncodedData());
            
            completado(UIImage(data: data)!);
        }.resume();
    }
    
    @IBAction func continuar(_ sender: Any) {
        
        etapaBrokerage = "DatosPropiedad"
        idOfertaSeleccionada = String(idBrokerage)
        
    }
    
    
}

