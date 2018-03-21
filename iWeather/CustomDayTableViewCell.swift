//
//  CustomDayTableViewCell.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-21.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class CustomDayTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
