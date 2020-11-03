//
//  HomeTVCell.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/11/3.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class HomeTVCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
