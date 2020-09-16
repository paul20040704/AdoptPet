//
//  LostFollowTableViewCell.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/16.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class LostFollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
