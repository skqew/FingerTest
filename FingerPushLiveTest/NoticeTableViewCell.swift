//
//  NoticeTableViewCell.swift
//  FingerPushLiveTest
//
//  Created by 정예진 on 05/09/2019.
//  Copyright © 2019 박은지. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var fingerImg: UIImageView!

    @IBOutlet weak var newIconImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()


    }


}
