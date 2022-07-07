//
//  InfoViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 5..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var appReportdic : NSDictionary = [:]
    var keys:Array = ["App Key", "App Name", "User ID", "Icon", "Category", "Environments", "Be iOS", "Be Android", "Be Update Alert", "Version", "iOS Update Link", "Version Update Date","SDK ver", "Device Environment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 테이블 높이 조절*/
        self.table.rowHeight = UITableView.automaticDimension
        self.table.estimatedRowHeight = 200
        
        /* 테이블 모양*/
        self.table.dataSource = self
        self.table.delegate = self
        self.table.layer.borderWidth = 1
        self.table.layer.cornerRadius = 5
        self.table.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        /* 개발 정보 가져오기*/
        finger.sharedData()?.requestGetAppReport{(posts, error) -> Void in
            if error != nil {
                print("error : \(error.debugDescription)")
            }
            if posts != nil {
                let appReport = posts
                self.appReportdic = appReport! as NSDictionary
                print("appReport : \(self.appReportdic)")
                    }
                    self.table.reloadData()
                }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.key.count
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoViewControllerCell
        
        //폰트, 글씨 색깔
        cell.leftLabel.font = UIFont(name: "NanumGothicBold", size: 14)!
        cell.leftLabel.textColor = .darkGray
        
        cell.rightLabel.font = UIFont(name: "NanumGothicBold", size: 14)!
        cell.rightLabel.numberOfLines = 0
        cell.rightLabel.lineBreakMode = .byWordWrapping


        /* 개발 정보 테이블 뷰에 보여주기 */
        cell.leftLabel.text = self.keys[indexPath.row]
        
        switch (indexPath.row) {
        case 0:
            //app key
            cell.rightLabel.text = self.appReportdic["appid"] as? String
            break
        
        case 1:
            //app name
            cell.rightLabel.text = self.appReportdic["app_name"] as? String
            break
            
        case 2:
            //user id
            cell.rightLabel.text = self.appReportdic["user_id"] as? String
            break
         
        case 3:
            //icon
            cell.rightLabel.text = self.appReportdic["icon"] as? String
            break
            
        case 4:
            //category
            cell.rightLabel.text = self.appReportdic["category"] as? String
            break
            
        case 5:
            //environments
            cell.rightLabel.text = self.appReportdic["environments"] as? String
            break
            
        case 6:
            //be ios
            cell.rightLabel.text = self.appReportdic["beios"] as? String
            break
            
        case 7:
            //be android
            cell.rightLabel.text = self.appReportdic["beandroid"] as? String
            break
            
        case 8:
            //be update alert
            if (appReportdic["beupdalert_i"] as? String == "") {
            cell.rightLabel.text = "-"
            } else {
            cell.rightLabel.text = self.appReportdic["beupdalert_i"] as? String
            }
            break
            
        case 9:
            //version
            if (appReportdic["ios_version"] as? String == "") {
            cell.rightLabel.text = "-"
            } else {
            cell.rightLabel.text = self.appReportdic["ios_version"] as? String
            }
            break
            
        case 10:
            //ios update link
            if (appReportdic["ios_upd_link"] as? String == "") {
            cell.rightLabel.text = "-"
            } else {
            cell.rightLabel.text = self.appReportdic["ios_upd_link"] as? String
            }
            break
            
        case 11:
            //version update date
            if (appReportdic["ver_update_date_i"] as? String == "") {
            cell.rightLabel.text = "-"
            } else {
            cell.rightLabel.text = self.appReportdic["ver_update_date_i"] as? String
            }
            break
            
        case 12:
            //sdk ver
            cell.rightLabel.text = finger.getSdkVer()
            break
            
        case 13:
            //device environment
            cell.rightLabel.text = "Release AppStore"

        default:
            print("default")
        }
        return cell
    }
    
    

}
