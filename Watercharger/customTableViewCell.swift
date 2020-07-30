//
//  customTableViewCell.swift
//  Watercharger
//
//  Created by 平良悠貴 on 2020/07/26.
//  Copyright © 2020 平良悠貴. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var bariation: UILabel!
    @IBOutlet weak var ryou: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
