//
//  CustomTableCellTableViewCell.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-14.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {

    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var windText: UILabel!

    @IBOutlet weak var tempField: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var cityId : String?
    
    
    // var data : String?
    // För att kunna hämta RÄTT cell även när man söker
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
