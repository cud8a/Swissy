//
//  DailyForecastCell.swift
//  Swissy
//
//  Created by Tamas Bara on 17.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class DailyForecastCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelIcon: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelMinMax: UILabel!
    @IBOutlet weak var labelSunrise: UILabel!
    @IBOutlet weak var labelSunset: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
}
