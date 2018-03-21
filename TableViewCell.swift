//
//  TableViewCell.swift
//  13MarApi
//
//  Created by Appinventiv-PC on 13/03/18.
//  Copyright © 2018 Appinventiv-PC. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var DiscriptionOfItemInCellClas: UILabel!
    @IBOutlet weak var NameOutletinCellclass: UILabel!
    @IBOutlet weak var imageOutletInCellClass: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
