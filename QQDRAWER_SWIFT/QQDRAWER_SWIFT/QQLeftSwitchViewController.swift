//
//  QQLeftSwitchViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by zzy on 2016/11/1.
//  Copyright © 2016年 BlackSky. All rights reserved.
//

import UIKit

class QQLeftSwitchViewController: UIViewController ,UIWebViewDelegate{
    
    // var label: UILabel?
    
    class func initWithTitle(title: String) -> UIViewController {
       
        let rootViewController = QQLeftSwitchViewController.init()
        
        let navViewController = UINavigationController.init(rootViewController: rootViewController)
        
        rootViewController.navigationItem.title = "正在加载。。。" //title
        
        return navViewController
    }
    
    func switchBackMainViewController() {
        QQDRrawerViewController.sharedDrawerViewController.switchBackMainViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "cancle", style: .plain, target: self, action: (#selector(QQLeftSwitchViewController.switchBackMainViewController)))
        
        let webView = UIWebView.init(frame: UIScreen.main.bounds)
        webView.delegate = self
        let url = NSURL.init(string: "http://www.baidu.com")
        
        if let u = url {
            webView.loadRequest(NSURLRequest.init(url: u as URL) as URLRequest)
        }
        view.addSubview(webView)
        
        /*
        let lbl = UILabel.init(frame: CGRect.init(x: 0, y: view.center.y, width: UIScreen.main.bounds.width, height: 30))
        lbl.textAlignment = .center
        label = lbl
        label?.alpha = 0.6
        label?.text = "正在加载。。。"
        view.addSubview(lbl)
         */
    }

    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.title = "加载完成"
        
        // self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.title = "加载失败"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
