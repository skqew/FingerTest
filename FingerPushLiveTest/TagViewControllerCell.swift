//
//  TagViewControllerCell.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 19..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class TagViewControllerCell: UITableViewCell {

    @IBOutlet var leftLabel: UILabel!
    let xButton = UIButton()

    let rightLabel = UILabel()
    let rightLabel2 = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addSubview(rightLabel)
        self.addSubview(rightLabel2)
        self.addSubview(xButton)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()


    }
}
