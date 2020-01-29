//The MIT License (MIT)
//
//Copyright (c) 2020 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

class ForceUpdateVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var txvMsg: UITextView!
    
    //MARK:- Variables
    var versionInfoDict: NSDictionary = [:]
    var navController: UINavigationController?
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnOK.tag = 101
        self.btnCancel.tag = 102
        
        self.btnOK.setTitleColor(.black, for: .normal)
        self.btnCancel.setTitleColor(.black, for: .normal)
        
        self.viewMain.layer.cornerRadius    = 5.0
        self.viewMain.layer.shadowColor     = UIColor.black.cgColor
        self.viewMain.layer.shadowOpacity   = 1
        self.viewMain.layer.shadowOffset    = CGSize.zero
        self.viewMain.layer.shadowRadius    = 5
        
        self.view.backgroundColor       = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewMain.centerX = self.view.width/2
    }
    
    //MARK: - Layout Subview
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        self.updateLayout()
    }
    
    func updateLayout() {
        let app_Version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! NSString
        let min_Version = self.versionInfoDict["minimum_app_version_ios"] as? NSString ?? app_Version
        
        self.btnOK.width = self.btnCancel.width
        if app_Version.doubleValue < min_Version.doubleValue {
            self.btnCancel.isHidden = true
            self.btnOK.centerX = self.viewMain.width/2
        }
        else {
            self.btnCancel.isHidden = false
            self.btnOK.right = 10
        }
        
        self.viewMain.center = self.view.center
    }
    
    //MARK: - Show Popup Class Method
    class func showMsgPopup(strTitle:String, dictData:NSDictionary, viewController : UIViewController, completion:@escaping (UIButton)-> ()){
        
        let msgPopup = ForceUpdateVC.init(nibName: "ForceUpdateVC", bundle: nil)
        msgPopup.view.tag = 10021;
        msgPopup.lblTitle.text = strTitle
        msgPopup.txvMsg.text = dictData["whats_new_text"] as? String
        msgPopup.versionInfoDict = dictData
        msgPopup.navController = viewController.navigationController
        
        let size = msgPopup.txvMsg.bounds.size
        var frame = msgPopup.txvMsg.frame
        frame.size = msgPopup.txvMsg.sizeThatFits(CGSize(width: size.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
        if frame.size.height < 200 {
            msgPopup.txvMsg.height  = frame.height
            msgPopup.txvMsg.width   = msgPopup.viewMain.width - 10
            
            var viewframe = msgPopup.viewMain.frame
            viewframe.size.height = frame.size.height + 220
            msgPopup.viewMain.frame = viewframe
        }
        msgPopup.view.frame = (msgPopup.navController?.view.bounds ?? CGRect.zero)!
        msgPopup.viewMain.center.y = msgPopup.view.center.y
        msgPopup.navController?.view.addSubview(msgPopup.view)
        
        msgPopup.btnCancel.addTapGesture { (gesture) in
            if let popUpView = msgPopup.navController?.view.viewWithTag(10021) {
                popUpView.removeFromSuperview()
            }
            completion(msgPopup.btnCancel)
        }
        
        msgPopup.btnOK.addTapGesture { (gesture) in
            if let popUpView = msgPopup.navController?.view.viewWithTag(10021) {
                popUpView.removeFromSuperview()
            }
            completion(msgPopup.btnOK)
        }
    }
}
