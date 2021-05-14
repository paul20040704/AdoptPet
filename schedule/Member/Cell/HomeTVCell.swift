//
//  HomeTVCell.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/11/3.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit


class HomeTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var kindLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    var id = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func click(_ sender: Any) {
        HomeMenuView.homeMenuView.showMenuView(id: self.id)
    }
    

}
