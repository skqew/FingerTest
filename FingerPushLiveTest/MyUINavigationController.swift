//
//  MyUINavigationController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019/10/14.
//  Copyright © 2019 박은지. All rights reserved.
//

import UIKit

class MyUINavigationController: UINavigationController, SlideMenuDelegate{

    var dimStatus = false
    var menuVC : MenuViewController?
    var dimView: UIView!
    let app = UIApplication.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "FINGER PUSH LIVE"
        
        //네비게이션바 컬러
        navigationBar.barTintColor = UIColor(red: 2/255, green: 128/255, blue: 188/255, alpha: 1)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "NanumGothicExtraBold", size: 20)!]
        navigationBar.tintColor = UIColor.white
        
        //메뉴 버튼 추가
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu_btn"), style: .plain, target: self, action: #selector(onSlideMenuButtonPressed))
        
        //홈 버튼 추가
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_btn"), style: .plain, target: self, action: #selector(onSlideHomeButtonPressed))

        
        //메뉴뷰 추가
        self.menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        
        self.menuVC?.delegate = self

        self.view.insertSubview(menuVC!.view, at: 1)

        menuVC!.view.layoutIfNeeded()
        
        menuVC!.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: navigationBar.frame.height + app.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        //딤뷰 추가
        self.dimView = UIView.init(frame: self.view.bounds)
        self.dimView.backgroundColor = UIColor.clear
        self.view.insertSubview(dimView, belowSubview: menuVC!.view)

        dimView.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

    }
    

    //MenuView Delegate
    func slideMenuItemSelectedAtIndex(_ index: Int) {

        switch(index){
            
        case 0:
            self.openViewControllerBasedOnIdentifier("NoticeViewController")
            navigationBar.topItem?.title = "알림"
            break
            
        case 1:
            self.openViewControllerBasedOnIdentifier("TagViewController")
            navigationBar.topItem?.title = "태그"
            
            navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named:"menu_btn"), style: .plain, target: self, action: #selector(onSlideMenuButtonPressed)), UIBarButtonItem(image: UIImage(named:"info_btn"), style: .plain, target: self, action: #selector(TagInfoButtonPressed))]

            break
            
        case 2:
            self.openViewControllerBasedOnIdentifier("TargetingViewController")
            navigationBar.topItem?.title = "타겟팅"
            
            navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named:"menu_btn"), style: .plain, target: self, action: #selector(onSlideMenuButtonPressed)), UIBarButtonItem(image: UIImage(named:"info_btn"), style: .plain, target: self, action: #selector(TargetingInfoButtonPressed))]
            
            break
            
        case 3:
            self.openViewControllerBasedOnIdentifier("InfoViewController")
            navigationBar.topItem?.title = "개발정보"
            break
            
        case 4:
            self.openViewControllerBasedOnIdentifier("GuideViewController")
            navigationBar.topItem?.title = "이용가이드"
            break
            
        case 5:
            let CallStr = "tel://"+"02-3453-3324"
            let numberURL = NSURL(string: CallStr)
            UIApplication.shared.open(numberURL! as URL)
            closeMenu()

            break
            
        case 6:
            self.openViewControllerBasedOnIdentifier("SettingViewController")
            navigationBar.topItem?.title = "알림설정"
            break
            
        default:
            break
        }
        
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu_btn"), style: .plain, target: self, action: #selector(onSlideMenuButtonPressed))
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_btn"), style: .plain, target: self, action: #selector(onSlideHomeButtonPressed))


    }
    
    
    //MARK: - 선택한 메뉴로 이동하는 함수
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
                
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        let topViewController = self.topViewController
        
        //선택한 뷰
        print("destview : \(destViewController)")
        
        //원래의 뷰
        print("topview : \(String(describing: topViewController))")
        
        if (topViewController!.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        }
        
        else {
            self.setViewControllers([destViewController], animated: false)
        }
        
        closeMenu()

    }
    
  
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){

        //메뉴 닫힘
        if self.dimStatus == true
        {
            closeMenu()

        }
            
        //메뉴 열림
        else {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.menuVC?.view.frame=CGRect(x: (UIScreen.main.bounds.size.width/5)*3, y: self.navigationBar.frame.height + self.app.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)

            }, completion:nil)
        
        self.dimView.isUserInteractionEnabled = true

        self.dimStatus = true
        
        print("subview : \(self.view.subviews.count)")
            
        }
    }
    
    //홈버튼이 눌렸을 때
    @objc func onSlideHomeButtonPressed(_ sender : UIButton){
                    
        self.openViewControllerBasedOnIdentifier("ViewController")
        
        if self.dimStatus == true{
        closeMenu()
        }
        
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu_btn"), style: .plain, target: self, action: #selector(onSlideMenuButtonPressed))
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_btn"), style: .plain, target: self, action: #selector(onSlideHomeButtonPressed))
        navigationBar.topItem?.title = "FINGER PUSH LIVE"

    }
    
    //태그 info버튼이 눌렸을 때
    @objc func TagInfoButtonPressed(_ sender : UIButton){
       let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "TagInfoViewController") as! TagInfoViewController
       popupVC.modalPresentationStyle = .overFullScreen

       present(popupVC, animated: false, completion: nil)

    }
    
    //타겟팅 info버튼이 눌렸을 때
    @objc func TargetingInfoButtonPressed(_ sender : UIButton){
       let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "TargetingInfoViewController") as! TargetingInfoViewController
       popupVC.modalPresentationStyle = .overFullScreen

       present(popupVC, animated: false, completion: nil)

    }

    
    
    //딤뷰 터치했을 때 메뉴 닫힘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.dimStatus == true{
        let touch = touches.first
        guard let location = touch?.location(in: self.dimView) else {return}
        if dimView.frame.contains(location){
                closeMenu()
            self.dimStatus = false
            }
        }
    }
    
    
        
//MARK: -  슬라이드 메뉴 닫기
    func closeMenu(){
        self.dimStatus = false

        let viewMenuBack : UIView = self.menuVC!.view

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()

            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0)

            }, completion: { (finished) -> Void in
        })
        self.dimView.isUserInteractionEnabled = false

    }
}
