//
//  SecondTableViewCell.swift
//  schedule
//
//  Created by TimeCity on 2019/11/21.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    @IBOutlet var aniImage: UIImageView!
    @IBOutlet var type: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var checkDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
