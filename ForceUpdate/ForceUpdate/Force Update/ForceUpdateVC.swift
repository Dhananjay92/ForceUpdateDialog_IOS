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
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewRemindMe: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var viewUpdate: UIView!
    
    //MARK:- Variables
    var versionInfoDict: NSDictionary = [:]
    var navController: UINavigationController?
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnOK.tag = 101
        self.viewMain.layer.cornerRadius = 10
        self.viewMain.layer.shadowColor = UIColor.black.cgColor
        self.viewMain.layer.shadowOpacity = 0.5
        self.viewMain.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.viewMain.layer.shadowRadius = 10
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
    }
    
    //MARK: - Layout Subview
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        self.updateLayout()
    }
    
    func updateLayout() {
        let app_Version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! NSString
        let min_Version = self.versionInfoDict["minimum_app_version_ios"] as? NSString ?? app_Version
        viewRemindMe.isHidden = app_Version.doubleValue < min_Version.doubleValue
    }
    
    //MARK: - Show Popup Class Method
    class func showMsgPopup(strTitle:String, dictData:NSDictionary, viewController : UIViewController, completion:@escaping (UIButton)-> ()){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let msgPopup = ForceUpdateVC.init(nibName: "ForceUpdateVC", bundle: nil)
        msgPopup.view.tag = 10021;
        msgPopup.lblTitle.text = strTitle
        msgPopup.lblDescription.text = dictData["whats_new_text"] as? String
        msgPopup.versionInfoDict = dictData
        msgPopup.view.frame = keyWindow?.bounds ?? CGRect.zero
        msgPopup.viewMain.center.y = msgPopup.view.center.y
        keyWindow?.addSubview(msgPopup.view)
        msgPopup.btnCancel.addTapGesture { (_) in
            for subview in keyWindow?.subviews ?? [] {
                if let popUpView = subview.viewWithTag(10021) {
                    popUpView.removeFromSuperview()
                }
            }
            completion(msgPopup.btnCancel)
        }
        msgPopup.btnOK.addTapGesture { _ in
            completion(msgPopup.btnOK)
        }
    }
}
