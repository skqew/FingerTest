//
//  TargetingViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 5..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit
class TargetingViewController: UIViewController {

    private let fingerManager = finger.sharedData()
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var targetText: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var xButton: UIButton!
    @IBOutlet var idenButton: UIButton!
    @IBOutlet var topView: UIView!
    
    var strIdenti = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        fingerManager?.requestPushInfo { (posts, error) -> Void in
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
            if posts != nil {
                print("posts : \(posts!)")
                
                self.strIdenti = posts!["identity"] as! String
                
                //식별자가 등록되어 있으면
                if self.strIdenti != ""{
                self.label.text = self.strIdenti
                self.xButton.isHidden = false
                }

                //식별자가 등록되어있지 않으면
                self.label.text = "식별자를 등록하세요."
                self.xButton.isHidden = true
                
            }
        }

        
        targetText.backgroundColor = .clear
        targetText.layer.borderColor = UIColor.orange.cgColor
        targetText.layer.borderWidth = 0.4
        targetText.layer.cornerRadius = 5
        targetText.frame.size = CGSize(width: 500, height: 100)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "타겟팅"
        

    }
    
     //MARK: - identy button background color
    @IBAction func touchUp(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
             
            self.targetText.backgroundColor = .white
                
                }, completion:nil)
        }
    
    
    @IBAction func touchDown(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                   self.targetText.backgroundColor = .lightGray
                       
                       }, completion:nil)
               }

    
    
    //MARK: - 등록 버튼을 눌렀을 때
    @IBAction func idenButton(_ sender: Any) {
        
        let offImage = UIImage(named: "signup_btn_active") as UIImage?
        self.idenButton.setBackgroundImage(offImage, for: .normal)
        let text = self.textField.text
        
        //텍스트 필드가 비어있으면
        if text?.isEmpty == true{
            let alertController = UIAlertController(title: "식별자를 입력해주세요.", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        

        //식별자가 등록 된 상태에서 등록하면
        if self.label.text != "식별자를 등록하세요."{
            let alertController = UIAlertController(title: "수정하시겠습니까?", message: nil, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "취소", style: .default)
            alertController.addAction(defaultAction)
            
            let okAction = UIAlertAction(title: "확인", style: .default){(action: UIAlertAction) -> Void in
                
                let strText = self.textField.text! as String
                self.regIdentity(strText)
                
                self.label.text = self.textField.text
                self.textField.text = ""
                self.xButton.isHidden = false
                
                self.view.endEditing(true)
                
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        //처음 식별자를 등록하면 얼럿이 뜨지 않음
        if self.label.text == "식별자를 등록하세요."{
            let strText = self.textField.text! as String
            self.regIdentity(strText)
            
            self.label.text = self.textField.text
            self.textField.text = ""
            self.xButton.isHidden = false
            
            self.view.endEditing(true)
            
        }
    }

    //등록버튼 눌렀을 때 이미지
    @IBAction func idenButtonTouchDown(_ sender: Any) {
        let offImage = UIImage(named: "signup_btn_inactive") as UIImage?
        self.idenButton.setBackgroundImage(offImage, for: .normal)
        self.idenButton.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
    }
    
    
    
    //MARK: - 식별자 등록
    func regIdentity(_ str:String){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        fingerManager?.requestRegId(withBlock: str) { (posts, error) -> Void in
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
            
            if posts != nil{
                print("posts : \(posts!)")
                
                self.strIdenti = str
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    //MARK: - 식별자 삭제
    func removeIdentity(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        fingerManager?.requestRemoveId{ (posts, error) -> Void in
            if error != nil {
                print("error : \(error.debugDescription)")
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    //삭제 얼럿
    func del(){
        if self.label.text != "식별자를 등록하세요."{
        let alertController = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "취소", style: .default)
        alertController.addAction(defaultAction)
        
        let okAction = UIAlertAction(title: "확인", style: .default){(action: UIAlertAction) -> Void in
            
            self.removeIdentity()
            self.label.text = "식별자를 등록하세요."
            self.xButton.isHidden = true
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func button(_ sender: Any) {
        del()
    }
    
    @IBAction func xButton(_ sender: Any) {
        del()
    }
    

   
    
    //MARK: - 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.hideKeyboard()

    }
    
    func hideKeyboard(){
        if (textField.isFirstResponder) {
            textField.resignFirstResponder()
        }
    }
}
