//
//  InfoViewControllerCell.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 18..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class InfoViewControllerCell: UITableViewCell {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib(){
        
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
