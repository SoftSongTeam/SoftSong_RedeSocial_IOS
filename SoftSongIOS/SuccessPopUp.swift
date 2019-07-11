//
//  SuccessPopUp.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 01/07/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class SuccessPopUp: UIView {

    static let instance = SuccessPopUp()
    
    @IBOutlet weak var Holder: UIView!
    @IBOutlet weak var PopUp: UIView!
    @IBOutlet weak var ImageOK: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    var cases:String = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SuccessPopUpView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit()
    {
        PopUp.elevate(elevation: 5)
    }
    
    enum AlertType
    {
        case success
        case failure
    }
    
    func showAlert(title: String, Message: String, alertType: AlertType, View: UIView)
    {
        lbl1.text = title
        lbl2.text = Message
        switch alertType {
        case .failure:
            ImageOK.image = UIImage(named: "icons8-cancel-100")
            btnOK.layer.backgroundColor = UIColor.init(netHex: 0xF98685).cgColor
        case .success:
            ImageOK.image = UIImage(named: "icons8-checkmark-100")
        }
        View.addSubview(Holder)
    }
    
    
    @IBAction func btnOkAction(_ sender: Any) {
            Holder.removeFromSuperview()
    }
}
