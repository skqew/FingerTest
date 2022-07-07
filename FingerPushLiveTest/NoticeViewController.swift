//
//  NoticeViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 4..
//  Copyright © 2019년 박은지. All rights reserved.
//
//
import UIKit

@available(iOS 10.0, *)
class NoticeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var alreamarr : NSMutableArray = []
    var page : Int32 = 1
    var key : String = ""
    var refreshControl : UIRefreshControl!

    
    @IBOutlet weak var alreamTable: UITableView!
    
    @IBOutlet weak var Noti: UILabel!
    @IBOutlet weak var NoticeSwi: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAlreamData()
                
        self.alreamTable.dataSource = self
        self.alreamTable.delegate = self
        
        //테이블 모양
        alreamTable.rowHeight = UITableView.automaticDimension
        alreamTable.estimatedRowHeight = 200
        
        
        self.alreamTable.reloadData()
        
        alreamTable.layer.borderWidth = 1
        alreamTable.layer.cornerRadius = 5
        alreamTable.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        //푸시 수신 여부
        finger.sharedData()?.requestPushInfo {(posts, error) -> Void in
            //activity가 A이면 스위치 온
            if(posts != nil){
                if posts!["activity"] as! String == "A" {
                    self.NoticeSwi!.setOn(true, animated: false)
                }else{
                    self.NoticeSwi!.setOn(false, animated: false)
                }
            }
            if error != nil {
                print("error : \(error.debugDescription)")
            }
        }
        
        //리프레시
        addRefreshControl()
 
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alreamarr.count
    }
    
    // 내용, 날짜, 이미지 로드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notice", for: indexPath) as! NoticeTableViewCell
        
        let push = self.alreamarr[indexPath.row] as! NSDictionary

        let strDate : String = push["date"] as! String
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = dateFormatter.date(from: strDate)!
        
        dateFormatter.dateFormat = "yyyy.MM.dd. HH:mm:ss"
        let chgStrDate = dateFormatter.string(from: date)
        
        cell.content.text = push["content"] as? String
        cell.date.text = chgStrDate
        
        cell.fingerImg.image = UIImage(named: "icon_1024")
        cell.fingerImg.layer.cornerRadius = 5

        //이미지 있는 푸시정보 띄우기
        image(cell:cell, dic:push)

        //알림 확인 N일 떄 new_box이미지 보여주기
        cell.newIconImg.image = UIImage()
        let checkOpen = push["opened"] as! String
                 if(checkOpen == "N"){
                        cell.newIconImg.image = UIImage(named: "new_box")
                 }
        
        return cell
        
    }
    
  
    //푸시리스트 테이블뷰에 보여주기
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (indexPath.row == self.alreamarr.count - 1) {

            if (page > Int32(key) ?? 0) {

                return

            }
            getAlreamData()

        }
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath){
        
        //셀 선택 했을 때 팝업 뷰
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        popupVC.modalPresentationStyle = .overFullScreen
        
        
        let notice = self.alreamarr[indexPath.row] as! NSDictionary
        popupVC.PopUpDic = notice
        
        present(popupVC, animated: false, completion: nil)
        
        //셀 선택 시 회색 해제
        self.alreamTable.deselectRow(at: indexPath, animated: true)

        //opened값 Y로 set해줌
        finger.sharedData()?.requestPushCheck(withBlock: notice as? [AnyHashable : Any], {(posts, err) in

            if posts != nil {
                    let Open = notice["opened"] as! String
                if (Open == "N") {
                    notice.setValue("Y", forKey: "opened")
                        
                    self.alreamTable.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                            
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let push = self.alreamarr[indexPath.row] as! NSDictionary
        
        let imgUrl = push["imgUrl"] as! String
        if imgUrl != ""{
            return 170
        }
        
        return UITableView.automaticDimension
        
    }
    
    
    //MARK: - 스위치
    @IBAction func NoticeSwitch(_ sender: UISwitch) {
        finger.sharedData().setEnable((sender as AnyObject).isOn, { (posts, error) -> Void in
            
            if posts != nil {
                print("posts : \(posts!)")
            }
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
        })
    }
    
    //MARK: - 리프레시
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        alreamTable.addSubview(refreshControl)
    }
    
    //푸시리스트 요청
    
    @objc func refreshList() {
        
        self.navigationItem.title = "알림 확인 중"
               refreshControl.beginRefreshing()
               
               finger.sharedData()?.requestPushList({(posts, error) -> Void in
                   if (posts != nil) {
                       self.alreamarr.setArray(posts!)
                    
                        self.alreamTable.reloadData()
                   }
                   self.refreshControl.endRefreshing()
                   self.navigationItem.title = "알림"
               })
    }
    
    /* MARK: - 푸시리스트 10개씩 불러오기*/
    
    func getAlreamData() {
        
        finger.sharedData()?.requestPushListPage(withBlock: page, cnt: 10, {(dic, err) in
            
            self.key = dic!["totalpage"] as! String
            
            let key2 = dic!["pushList"] as! NSArray
            
            self.page = self.page+1
            
            self.alreamarr.addObjects(from: key2 as! [Any])
            
                self.alreamTable.reloadData()
        })
    }
    
    //MARK: - 이미지 로딩 함수
    func image(cell:NoticeTableViewCell, dic: NSDictionary) {
        let imgUrl = dic["imgUrl"] as! String
        
        cell.imgView.image = UIImage()
        
        if let url = URL(string: imgUrl){
            URLSession.shared.dataTask(with: url) {data, response, error in guard error == nil else{
                return
                }
                DispatchQueue.main.async {
                    let data = try? Data(contentsOf: url)
                    if let imgdata = data{
                        let imgView2 = UIImage(data: imgdata)
                        
                        cell.imgView.image = imgView2
                    }
                }
                }.resume()
            
        }
    }
    

    

}
