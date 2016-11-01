//
//  QQDrawerViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by zzy on 2016/10/30.
//  Copyright © 2016年 BlackSky. All rights reserved.
//

import UIKit

class QQDRrawerViewController: UIViewController {

    //  创建单例
    static let sharedDrawerViewController = QQDRrawerViewController()
    
    var leftViewController: QQLeftViewController?
    var mainViewController: QQMainViewController?
    var maxWidth: CGFloat?
    
    var switchViewController: UIViewController?
    
    var coverButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCoverButton()
        
        view.backgroundColor = UIColor.white;
        
        self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -maxWidth!, y: 0)
        
        for childViewController in (mainViewController?.childViewControllers)! {
            addScreenEdgePanGestureRecognizer(view: childViewController.view)
        }
    }
    
    /// 创建抽屉
    ///
    /// - parameter _leftViewcontroller: 左侧控制器
    /// - parameter _mainViewController: 主控制器
    ///
    /// - returns: 抽屉控制器
    class func drawerWithViewController(_leftViewcontroller : QQLeftViewController,_mainViewController : QQMainViewController, DrawerMaxWithd: CGFloat) -> QQDRrawerViewController{
        let drawerViewController = QQDRrawerViewController.sharedDrawerViewController
        
        drawerViewController.leftViewController = _leftViewcontroller
        drawerViewController.mainViewController = _mainViewController
        drawerViewController.maxWidth = DrawerMaxWithd
        
        drawerViewController.view.addSubview(_leftViewcontroller.view)
        drawerViewController.addChildViewController(_leftViewcontroller)
        
        drawerViewController.view.addSubview(_mainViewController.view)
        drawerViewController .addChildViewController(_mainViewController)
        
        return drawerViewController
    }

    /// 添加边缘手势
    ///
    /// - parameter view: 添加边缘手势的view
    func addScreenEdgePanGestureRecognizer(view: UIView) {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: (#selector(QQDRrawerViewController.screenEdgePanGestureRecognizer(pan:))))
        pan.edges = UIRectEdge.left
        view.addGestureRecognizer(pan)
    }
    
    /// 边缘手势的回调
    ///
    /// - parameter pan: 边缘手势
    func screenEdgePanGestureRecognizer(pan: UIScreenEdgePanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { 
            if pan.state == UIGestureRecognizerState.changed && offsetX < self.maxWidth! {
                self.mainViewController?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
                self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -self.maxWidth! + offsetX, y: 0)
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed {
                if offsetX > UIScreen.main.bounds.width * 0.5 {
                    self.openDrawer(openDrawerWithDuration: (self.maxWidth! - offsetX)/self.maxWidth! * 0.2)
                }else {
                    self.closeDrawer(closeDrawerWithDuration: offsetX / self.maxWidth! * 0.2)
                }
            }
        });
        
    }
    
    /// 打开抽屉
    func openDrawer(openDrawerWithDuration: CGFloat) {
        
        UIView.animate(withDuration: TimeInterval(openDrawerWithDuration), delay: 0, options: .curveLinear, animations: {
            self.mainViewController?.view.transform = CGAffineTransform.init(translationX: self.maxWidth!, y: 0)
            self.leftViewController?.view.transform = CGAffineTransform.identity
            }) { (Bool) in
                
                self.setCoverButton()
                
                self.mainViewController?.view.addSubview(self.coverButton!)
        };
    }
    
    /// 关闭抽屉
    func closeDrawer(closeDrawerWithDuration: CGFloat) {
        UIView.animate(withDuration: TimeInterval(closeDrawerWithDuration), delay: 0, options: .curveLinear, animations: {
            self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -self.maxWidth!, y: 0)
            self.mainViewController?.view.transform = CGAffineTransform.identity
        }) { (Bool) in
            self.coverButton?.removeFromSuperview()
            self.coverButton = nil
        };
    }
    
    /// 创建遮罩按钮
    func setCoverButton() {
        
        guard self.coverButton != nil else {
            //  创建遮罩按钮
            let coverButton = UIButton.init()
            self.coverButton = coverButton
            coverButton.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            coverButton.addTarget(self, action: (#selector(QQDRrawerViewController.closeDrawer)), for: .touchUpInside)
            addPanGestureRecognizer(view: coverButton)
            return
        }
    }
    
    /// 给遮罩按钮添加拖拽手势
    ///
    /// - parameter view: 遮罩按钮
    func addPanGestureRecognizer(view: UIView) {
        let pan = UIPanGestureRecognizer.init(target: self.mainViewController, action: (#selector(QQMainViewController.panGestureRecognizer(pan:))))
        view.addGestureRecognizer(pan)
    }
    
    /// 拖动手势处理
    func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if pan.state == .cancelled || pan.state == .failed || pan.state == .ended {
            
            if offsetX < 0 , UIScreen.main.bounds.width - self.maxWidth! + abs(offsetX) > UIScreen.main.bounds.width * 0.5{
                closeDrawer(closeDrawerWithDuration: (self.maxWidth! + offsetX) / self.maxWidth! * 0.2)
            }else{
                openDrawer(openDrawerWithDuration:abs(offsetX) / self.maxWidth! * 0.2)
            }
            
        }else if pan.state == .changed{
            if offsetX < 0 , offsetX > -self.maxWidth! {
                mainViewController?.view.transform = CGAffineTransform.init(translationX: self.maxWidth! + offsetX, y: 0)
                leftViewController?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
            }
        }
        
    }
    
    /// 选择左侧菜单进行跳转
    ///
    /// - parameter viewController: 跳转目标控制器
    func switchViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        switchViewController = viewController
        viewController.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        view.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.2) { 
            viewController.view.transform = CGAffineTransform.identity
        };
        
    }
    
    /// 返回到左侧控制器
    func switchBackMainViewController() {
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.switchViewController?.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
            }) { (Bool) in
                self.switchViewController?.removeFromParentViewController()
                self.switchViewController?.view.removeFromSuperview()
        }
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
