//
//  TargetingInfoViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 18..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class TargetingInfoViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var popup: UIView!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popup.layer.cornerRadius = 5
        
        //텍스트 뷰에 html로드
        if let filepath = Bundle.main.path(forResource: "TargetInfo", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)

                let html = contents
                        
                let encoded = html.data(using: String.Encoding.utf8)!
                let attributedOptions : [NSAttributedString.DocumentReadingOptionKey : Any] = [
                    .documentType : NSAttributedString.DocumentType.html]
                let attributedTxt = try! NSAttributedString(data: encoded, options: attributedOptions, documentAttributes: nil)
                textView.attributedText = attributedTxt
                 
            } catch {
                
            }
        }
        
    }
    
   //MARK: - Dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else {return}
        if !popup.frame.contains(location){
            
            self.dismiss(animated: false, completion: nil)
            
            
        }
    }

    //MARK: - 하이퍼링크 클릭했을 때
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }

}
