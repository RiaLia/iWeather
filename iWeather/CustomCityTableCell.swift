//
//  CustomCityTableCell.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-23.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class CustomCityTableCell: UITableViewCell {
    
    @IBOutlet weak var cityText: UILabel!
    var cityId : String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
