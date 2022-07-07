//
//  TagViewController.swift
//  FingerPushLiveTest
//
//  Created by 정예진 on 2019. 9. 5..
//  Copyright © 2019년 정예진. All rights reserved.
//

import UIKit

class TagViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var TagArr : NSArray = []
    var TagrefreshControl : UIRefreshControl!
    
    private let fingerManager = finger.sharedData()

    @IBOutlet weak var TagText: UITextField!
    @IBOutlet weak var TagTable: UITableView!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var topView: UIView!
    
    @IBOutlet var buttonView: UIView!
    @IBOutlet var buttonView2: UIView!
    
    let allButton = UIButton()
    let myButton = UIButton()
    let allLabel = UILabel()
    let myLabel = UILabel()



    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TagTable.dataSource = self
        self.TagTable.delegate = self
        
        //textfield placeholder
        TagText.placeholder = "태그 설정"
        
        //tableview 모양
        TagTable.layer.borderWidth = 0.5
        TagTable.layer.cornerRadius = 5
        TagTable.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        //처음에 모든 태그 보여주기
        goTagAllList()
        
        //리프레시
        self.TagrefreshControl = UIRefreshControl()
        TagrefreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        TagTable.addSubview(TagrefreshControl)
        
        
        let tagOn = UIImage(named: "tag_on") as UIImage?
        let tagOff = UIImage(named: "tag_off") as UIImage?
        
        //모든 태그 버튼
        allButton.addTarget(self, action: #selector(AllTagAct(_:)), for: .touchUpInside)
        allButton.setBackgroundImage(tagOff, for: .normal)
        allButton.setBackgroundImage(tagOn, for: .selected)
        allButton.isSelected = true
        allLabel.text = "모든 태그"
        allLabel.textColor = UIColor.white
        
        //내 태그 버튼
        myButton.addTarget(self, action: #selector(MyTagAct(_:)), for: .touchUpInside)
        myButton.setBackgroundImage(tagOff, for: .normal)
        myButton.setBackgroundImage(tagOn, for: .selected)
        myButton.isSelected = false
        myLabel.text = "내 태그"


        self.buttonView.addSubview(allButton)
        self.buttonView2.addSubview(myButton)
        buttonView.addSubview(allLabel)
        buttonView2.addSubview(myLabel)

        allLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        
        allLabel.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor, constant: 0).isActive = true
        allLabel.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor, constant: 0).isActive = true
        
        myLabel.centerXAnchor.constraint(equalTo: buttonView2.centerXAnchor, constant: 0).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: buttonView2.centerYAnchor, constant: 0).isActive = true
        
        let rect = CGRect(x: 0, y: 0, width: buttonView.bounds.width, height: buttonView.bounds.height + 6)
        allButton.frame = rect

        let rect2 = CGRect(x: 0, y: 0, width: buttonView2.bounds.width, height: buttonView.bounds.height)
        myButton.frame = rect2

        self.view.layoutIfNeeded()
        
        //모든태그, 내태그 버튼 누를 때 키보드 내리기
        allButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        
        //드래그 할 때 키보드 내리기
        TagTable.keyboardDismissMode = .onDrag
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TagArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tag", for: indexPath) as! TagViewControllerCell

        //tag, date 정보
        let dic : NSDictionary = TagArr[indexPath.row] as! NSDictionary
        let tag = dic["tag"] as? String
        let TagstrDate : String = dic["date"] as! String
        
        let TagdateFormatter = DateFormatter()
        TagdateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.0"
        let Tagdate = TagdateFormatter.date(from: TagstrDate)!
        TagdateFormatter.dateFormat = "yyyy.MM.dd."
        let TagchgStrDate = TagdateFormatter.string(from: Tagdate)
        
        
        cell.leftLabel?.text = tag
        cell.leftLabel?.textColor = .darkGray
            
        cell.rightLabel.text = TagchgStrDate
        cell.rightLabel.textColor = .gray
        cell.rightLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.rightLabel.topAnchor.constraint(equalTo: cell.leftLabel.topAnchor, constant: 0).isActive = true

        cell.rightLabel2.text = TagchgStrDate
        cell.rightLabel2.textColor = .gray
        cell.rightLabel2.translatesAutoresizingMaskIntoConstraints = false
        cell.rightLabel2.topAnchor.constraint(equalTo: cell.leftLabel.topAnchor, constant: 0).isActive = true

        
        //라벨 여백 조정
        
        if allLabel.textColor == UIColor.white{

            cell.rightLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true

            cell.rightLabel.isHidden = false
            cell.rightLabel2.isHidden = true
            cell.xButton.isHidden = true

        }

        if myLabel.textColor == UIColor.white{
            
            cell.rightLabel2.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -50).isActive = true

            cell.rightLabel.isHidden = true
            cell.rightLabel2.isHidden = false

            cell.xButton.translatesAutoresizingMaskIntoConstraints = false
            let xImage = UIImage(named: "delete_btn_active") as UIImage?
            cell.xButton.setBackgroundImage(xImage, for: .normal)
            cell.xButton.topAnchor.constraint(equalTo: cell.leftLabel.topAnchor, constant: 0).isActive = true
            cell.xButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
            cell.xButton.isHidden = false

            cell.xButton.addTarget(self, action: #selector(xButtonAction), for: .touchUpInside)
            cell.xButton.addTarget(self, action: #selector(xButtonDownAction), for: .touchDown)

        }


        return cell
    }
    
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath){
                   
        //삭제 얼럿
        if myLabel.textColor == UIColor.white {
        let alertController = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "취소", style: .default)
        alertController.addAction(defaultAction)

        let okAction = UIAlertAction(title: "확인", style: .default){(action: UIAlertAction) -> Void in

            let tagDic = self.TagArr[indexPath.row] as! NSDictionary
            let tagStr = tagDic["tag"] as? String

            self.removeMyTag(tagStr!)

        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

        }

        //셀 선택 시 textfield에 보여주기
        if allLabel.textColor == UIColor.white {
            let tagDic = self.TagArr[indexPath.row] as! NSDictionary
            let tagStr = tagDic["tag"] as? String
            self.TagText.text = tagStr
        }
        
        //셀 선택 시 키보드 내리기
        self.hideKeyboard()

    }
    
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rect = CGRect(x: 0, y: 0, width: buttonView.bounds.width, height: buttonView.bounds.height + 6)
        allButton.frame = rect

        let rect2 = CGRect(x: 0, y: 0, width: buttonView2.bounds.width, height: buttonView.bounds.height)
        myButton.frame = rect2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - 리프레시
    @objc func refreshData(){
        
        if self.allLabel.textColor == UIColor.white{
            self.goTagAllList()
        }

        if self.myLabel.textColor == UIColor.white{
            self.getMyTagList()
        }
        
    }
    

    //MARK: - 등록 버튼
    
    @IBAction func addButton(_ sender: UIButton) {
        
        let offImage = UIImage(named: "signup_btn_active") as UIImage?
        self.addButton.setBackgroundImage(offImage, for: .normal)
        
        let strText = self.TagText.text! as String
        self.addMyTag(strText)

        self.view.window?.endEditing(true)
        self.TagText.text = ""
        
        self.TagTable.reloadData()

    }
    
    //등록 버튼 눌렀을 때 이미지
    @IBAction func addButtonTouchDown(_ sender: Any) {
        let offImage = UIImage(named: "signup_btn_inactive") as UIImage?
        self.addButton.setBackgroundImage(offImage, for: .normal)
        self.addButton.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
    }
    
    
    
    //MARK: - 모든태그 버튼
   @objc func AllTagAct(_ sender: Any) {
        
        if allButton.isSelected {
            return
        }
        
        allButton.isSelected = true
        myButton.isSelected = false
        

        allLabel.textColor = UIColor.white
        myLabel.textColor = UIColor.black

        goTagAllList()
        
        let rect = CGRect(x: 0, y: 0, width: buttonView.bounds.width, height: buttonView.bounds.height + 6)
        allButton.frame = rect

        let rect2 = CGRect(x: 0, y: 0, width: buttonView2.bounds.width, height: buttonView.bounds.height)
        myButton.frame = rect2
        
    }
  
    //MARK: -  내태그 버튼
    @objc func MyTagAct(_ sender: Any) {
        
        if myButton.isSelected {
            return
        }
        
        allButton.isSelected = false
        myButton.isSelected = true

        
        allLabel.textColor = UIColor.black
        myLabel.textColor = UIColor.white

        getMyTagList()
        
        let rect = CGRect(x: 0, y: 0, width: buttonView.bounds.width, height: buttonView.bounds.height)
        allButton.frame = rect
        
        let rect2 = CGRect(x: 0, y: 0, width: buttonView2.bounds.width, height: buttonView2.bounds.height+6)
        myButton.frame = rect2

        
    }
    

    
    
//MARK: - X버튼
    
    @objc func xButtonAction(sender: UIButton!){
        
        let buttonPostion = sender.convert(CGPoint.zero, to: self.TagTable)
        //x버튼의 indexPath.row값 가져오기
        if let indexPath = self.TagTable.indexPathForRow(at: buttonPostion) {
            
            if myLabel.textColor == UIColor.white {
                   //삭제 얼럿
                   let alertController = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)

                   let defaultAction = UIAlertAction(title: "취소", style: .default)
                   alertController.addAction(defaultAction)

                   let okAction = UIAlertAction(title: "확인", style: .default){(action: UIAlertAction) -> Void in

                       let tagDic = self.TagArr[indexPath.row] as! NSDictionary
                       let tagStr = tagDic["tag"] as? String

                       self.removeMyTag(tagStr!)

                   }
                   alertController.addAction(okAction)
                   self.present(alertController, animated: true, completion: nil)

                   }
                }
            }
    
    //x버튼을 눌렀을 때 이미지
    @objc func xButtonDownAction(sender: UIButton!){
        let cell = self.TagTable.dequeueReusableCell(withIdentifier: "Tag") as! TagViewControllerCell
        let xImage = UIImage(named: "delete_btn_inactive") as UIImage?
        cell.xButton.setBackgroundImage(xImage, for: .normal)
    }

    
    /* MARK: - 태그 호출*/
    
     func goTagAllList() {
        
        self.navigationItem.title = "태그 확인 중"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        finger.sharedData()?.requestGetAllTagList { (posts, error) -> Void in
            if error != nil {
                print("error : \(error.debugDescription)")
            }
            if posts != nil {
                self.TagArr = posts! as NSArray
                self.TagArr.addingObjects(from: posts!)
            }
            self.TagTable.reloadData()
            
            self.TagrefreshControl.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.navigationItem.title = "태그"
      }
    }
    
    
    func getMyTagList(){
        
        self.navigationItem.title = "태그 확인 중"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        finger.sharedData()?.requestGetDeviceTagList { (posts,error) -> Void in
            
            self.setEditing(false, animated: false)
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
            
            if posts != nil {
                self.TagArr = posts! as NSArray
                self.TagArr.addingObjects(from: posts!)
                
            }
            self.TagTable.reloadData()
            
            self.TagrefreshControl.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.navigationItem.title = "태그"
        }
    }
    
    /* MARK: - 기기 태그 추가*/

    func addMyTag(_ strTag: String){
        
        if strTag.count > 0 {
            
            let arrParam:Array = [strTag]
            
            fingerManager?.requestRegTag(withBlock: arrParam, { (posts, error) -> Void in
                
                if error != nil {
                    print("error : \(error.debugDescription)")
                }
                
                if posts != nil {
                    print("posts : \(posts!)")
                
                
                if self.allLabel.textColor == UIColor.white{
                    self.goTagAllList()
                }

                if self.myLabel.textColor == UIColor.white{
                    self.getMyTagList()
                }
            }
        })
        } else {
            //태그 값 없을 때 얼럿
            let alertController = UIAlertController(title: "태그값을 입력해주세요.", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
  
    /* MARK: - 기기 태그 삭제*/

    func removeMyTag(_ strTag: String){
                
        if strTag.count > 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let arrParam:Array = [strTag]
            
            fingerManager?.requestRemoveTag(withBlock: arrParam, { (posts, error) -> Void in
                
                if error != nil {
                    
                    print("error : \(error.debugDescription)")
                }
                
                if posts != nil{
                    print("posts : \(posts!)")
                    
                    self.getMyTagList()
                }
            })
            
        }
        
    }

    //MARK: - 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.hideKeyboard()

    }
    
    @objc func hideKeyboard(){
        if (TagText.isFirstResponder) {
            TagText.resignFirstResponder()
        }
    }
    
  

}
