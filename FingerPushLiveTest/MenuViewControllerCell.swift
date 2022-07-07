//
//  MenuViewControllerCell.swift
//  FingerPushLiveTest
//
//  Created by 정예진 on 07/10/2019.
//  Copyright © 2019 박은지. All rights reserved.
//

import UIKit

class MenuViewControllerCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
