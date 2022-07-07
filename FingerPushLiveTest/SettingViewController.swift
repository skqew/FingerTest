//
//  SettingViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 5..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var AlreamView: UIView!
    @IBOutlet weak var AdverView: UIView!
    
    @IBOutlet weak var getAlream: UILabel!
    @IBOutlet weak var getAdver: UILabel!
    @IBOutlet weak var AlSwitch: UISwitch!
    @IBOutlet weak var AdSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //글씨체, 크기
        getAlream.text = "알림 수신"
        getAlream.font = UIFont(name: "NanumGothicBold", size: 18)!
        getAdver.text = "광고 수신"
        getAdver.font = UIFont(name: "NanumGothicBold", size: 18)!

        //푸시 수신 여부
        finger.sharedData()?.requestPushInfo {(posts, error) -> Void in

            if(posts != nil){

                if posts!["activity"] as! String == "A" {
                      self.AlSwitch!.setOn(true, animated: false)
                   }else{
                      self.AlSwitch!.setOn(false, animated: false)
                   }
                if posts!["ad_activity"] as! String == "A" {
                    self.AdSwitch!.setOn(true, animated: false)
                }else{
                    self.AdSwitch!.setOn(false, animated: false)
                }              
            }
        }
    }
    
   
    /* MARK: - 알림 스위치*/

    @IBAction func AlreamSw(_ sender: UISwitch) {

        
        finger.sharedData().setEnable((sender as AnyObject).isOn, { (posts, error) -> Void in
         
            if posts != nil {
                print("Settingposts : \(String(describing: posts))")
            }
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
        })
     


    }

    /* MARK: - 광고 수신 스위치*/
    
    @IBAction func AdverSw(_ sender: UISwitch) {

        finger.sharedData()?.requestSetAdPushEnable((sender as AnyObject).isOn, {(posts, error) -> Void in

            if posts != nil {
                print("posts : \(posts!)")
            }
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }

        })
    }
}
