//
//  PopUpViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 10..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
   
    
    @IBOutlet var popup: UIView!
    @IBOutlet weak var fingerpushImg: UIImageView!
    @IBOutlet weak var fingerContent: UILabel!
    @IBOutlet weak var fingerDate: UILabel!
    @IBOutlet weak var fingerImage: UIImageView!
    
    var PopUpDic : NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        self.view.layoutIfNeeded()
        
        popup.layer.cornerRadius = 5
        
        
        //푸시 정보 가져오기
        let strDate : String = PopUpDic["date"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "yyyy.MM.dd. HH:mm:ss"
        let chgStrDate = dateFormatter.string(from: date)
        
        self.fingerContent.text = PopUpDic["content"] as? String
        
        self.fingerDate.text = chgStrDate
        self.fingerpushImg.image = UIImage(named: "icon_1024")
        self.fingerpushImg.layer.cornerRadius = 9
        self.fingerpushImg.clipsToBounds = true
        
        let img = PopUpDic["imgUrl"] as? String
        
        
        if img != ""{
            if let url = URL(string: "\(img ?? "")") {
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let Data = data {
                        let image = UIImage(data: Data)
                        DispatchQueue.main.async(execute: {
                            self.fingerImage.image = image
                        })
                    }
                }
                task.resume()
            }
        }
    }
    
    //Dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else {return}
        if !popup.frame.contains(location){
            
            self.dismiss(animated: false, completion: nil)
            view.isHidden = true
        }
    }
}
