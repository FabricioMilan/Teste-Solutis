//
//  CellDados.swift
//  ProvaFinalSolutis
//
//  Created by Virtual Machine on 25/10/21.
//

import UIKit

class CellDados: UITableViewCell {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblConta: UILabel!
    @IBOutlet weak var Lblvalor: UILabel!
    @IBOutlet weak var lblView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblView.layer.cornerRadius = 25
        
        
        
    }
    
    
}
