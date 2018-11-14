//
//  CityForecastCell.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CityForecastCell: UITableViewCell {

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelIcon: UILabel!
    @IBOutlet weak var forecast: ForecastView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelIcon.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        alpha = highlighted ? 0.3 : 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}
