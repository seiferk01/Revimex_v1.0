//
//  CarritoCellController.swift
//  Revimex
//
//  Created by Seifer on 28/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class CarritoCellController: UITableViewCell {

    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var precio: UITextField!
    @IBOutlet weak var desalojo: UITextField!
    @IBOutlet weak var total: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
