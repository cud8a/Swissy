//
//  CityForecastCell.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class CityForecastCell: UITableViewCell {

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        alpha = highlighted ? 0.3 : 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}
