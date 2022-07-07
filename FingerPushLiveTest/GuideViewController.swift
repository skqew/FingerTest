//
//  GuideViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 5..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
 
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView2.delegate = self
        
        textView.layer.borderWidth = 0.5
        textView2.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView2.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView2.layer.cornerRadius = 5
        
        textView.textContainerInset = UIEdgeInsets(top: 12,left: 7,bottom: 12,right: 12)
        textView2.textContainerInset = UIEdgeInsets(top: 12,left: 7,bottom: 12,right: 12)

        
        if let localfilepath = Bundle.main.path(forResource: "Guide_index1", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: localfilepath)

                let html = contents
                        
                let encoded = html.data(using: String.Encoding.utf8)!
                let attributedOptions : [NSAttributedString.DocumentReadingOptionKey : Any] = [
                    .documentType : NSAttributedString.DocumentType.html]
                let attributedTxt = try! NSAttributedString(data: encoded, options: attributedOptions, documentAttributes: nil)
                textView.attributedText = attributedTxt
                
                 
            } catch {
                
            }
        }
        
        if let localfilepath2 = Bundle.main.path(forResource: "Guide_index2", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: localfilepath2)
                print(contents)

                let html = contents
                        
                let encoded = html.data(using: String.Encoding.utf8)!
                let attributedOptions : [NSAttributedString.DocumentReadingOptionKey : Any] = [
                    .documentType : NSAttributedString.DocumentType.html]
                let attributedTxt = try! NSAttributedString(data: encoded, options: attributedOptions, documentAttributes: nil)
                textView2.attributedText = attributedTxt
                
                 
            } catch {
                
            }
        }
    }

    
    //MARK: - 하이퍼링크 클릭했을 때
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            return true
        }
    }
    

}
