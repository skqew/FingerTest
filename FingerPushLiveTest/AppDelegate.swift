//
//  AppDelegate.swift
//  FingerPushLiveTest
//
//  Created by 정예진 on 2019. 9. 4..
//  Copyright © 2019년 정예진. All rights reserved.

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//test
    var window: UIWindow?
    private let fingerManager = finger.sharedData()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        //핑거 푸시 sdk 버전
        print("SdkVer : " + finger.getSdkVer())
        
        /*핑거 푸시*/
        fingerManager?.setAppKey("Evt7Ht4RkZVs")
        fingerManager?.setAppScrete("mDMxSCUZ8WXHeUYo0zoeCgFkd6UmH9As")
        
        /*apns 등록*/
        registeredForRemoteNotifications(application: application)
        
  
        return true
    }
    
    //MARK: - 푸시 등록
    
    func registeredForRemoteNotifications(application: UIApplication) {

        if #available(iOS 10.0, *) {

            let center = UNUserNotificationCenter.current()
            center.delegate = self

            center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted, error) in

                if (granted == true){
                    DispatchQueue.main.async(execute: {
                        application.registerForRemoteNotifications()
                    })
                }else{
                    print("User Notification permission denied")
                    if error != nil {
                        print("error : \(error.debugDescription)")
                    }
                }
            })

        }else{
        
            let types = UIUserNotificationType([.alert, .sound, .badge])
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken)")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
//        var testData = NSMutableData()
//        let value: Byte = {'\0'}
//        let byte: [Byte] = [value]
        
        fingerManager?.registerUser(withBlock: deviceToken, { (posts, error) -> Void in
            
            print("token : " + (self.fingerManager?.getToken() ?? ""))
            print("DeviceIdx : " + (self.fingerManager?.getDeviceIdx() ?? ""))
            
            if posts != nil {
                print("기기등록: \(posts!)")
            }
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
        })
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("userInfo : \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    //MARK: - 푸시 얼럿
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //push메시지 얼럿
        let UserInfo = notification.request.content.userInfo
        print(UserInfo)
        let message = finger.recevieMessage(UserInfo)
        let pushImgStr = UserInfo["imgUrl"]


        let dicCode = finger.receviveCode(UserInfo)
        let strImg = dicCode!["IM"] as! String

        //이미지 있을 때 imgView 추가
        let IntstrImg : Int = 1
        if strImg == String(IntstrImg){
            let AlertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            let CloseAlert = UIAlertAction(title:"닫기",style: UIAlertAction.Style.default, handler: nil)
            let OkAlert = UIAlertAction(title: "수신 확인", style: UIAlertAction.Style.default, handler: { action in
                self.checkPush(UserInfo)
            })

            let imgView = UIImageView()
            imgView.frame = CGRect(x: 10, y: 70, width: 250, height: 80)
            imgView.image = UIImage()
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            if let url = URL(string: pushImgStr as! String){
            URLSession.shared.dataTask(with: url) {data, response, error in guard error == nil else{
                return
                }
                DispatchQueue.main.async {
                    let data = try? Data(contentsOf: url)
                    if let imgdata = data{
                        let imgView2 = UIImage(data: imgdata)
                            imgView.image = imgView2
                    }
                }
            }
            .resume()
        }
            AlertController.view.addSubview(imgView)

            AlertController.addAction(CloseAlert)
            AlertController.addAction(OkAlert)
            
            let height:NSLayoutConstraint = NSLayoutConstraint(item: AlertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: AlertController.view.frame.height * 0.30)
            AlertController.view.addConstraint(height)

            self.window?.rootViewController?.present(AlertController, animated: false, completion: nil)
            

        } else {
            
            // 이미지 없을 떄
            let AlertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            let CloseAlert = UIAlertAction(title:"닫기",style: UIAlertAction.Style.default, handler: nil)
            let OkAlert = UIAlertAction(title: "수신확인", style: UIAlertAction.Style.default, handler: { action in
                self.checkPush(UserInfo)
            
            })
            
            AlertController.addAction(CloseAlert)
            AlertController.addAction(OkAlert)
            
            self.window?.rootViewController?.present(AlertController, animated: false, completion: nil)
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /* MARK: - 푸시 오픈 체크*/
    func checkPush(_ UserInfo : [AnyHashable : Any]){
 
        finger.sharedData().requestPushCheck(withBlock: UserInfo , { (posts, error) -> Void in

            
            if posts != nil {
                print("posts : \(posts!)")
            }
            
            if error != nil {
                print("error : \(error.debugDescription)")
            }
        })
    }
}

