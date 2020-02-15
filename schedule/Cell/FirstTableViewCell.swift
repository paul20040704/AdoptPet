//
//  TableViewCell.swift
//  schedule
//
//  Created by TimeCity on 2019/10/3.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet var aniImage: UIImageView!
    
    @IBOutlet var type: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var checkDate: UILabel!
    @IBOutlet var likeBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
