//
//  TableViewCell.swift
//  zhihu
//
//  Created by he on 2017/7/21.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var model: Model? {
        didSet {
            let url = URL(string: model?.images?.first ?? "")
            iconImage.kf.setImage(with: url)
            
            descLabel.text = model?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
