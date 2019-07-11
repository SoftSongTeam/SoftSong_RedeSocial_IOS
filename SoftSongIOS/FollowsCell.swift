//
//  FollowsCell.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 01/07/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class FollowsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        imgPerfil.contentMode = UIView.ContentMode.scaleAspectFit
        imgPerfil.layer.borderWidth = 1
        imgPerfil.layer.masksToBounds = false
        imgPerfil.layer.borderColor = UIColor.black.cgColor
        imgPerfil.layer.cornerRadius = 20
        imgPerfil.clipsToBounds = true
        lblUsername.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    }
    
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var lblUsername: UIButton!
    @IBAction func btnUser(_ sender: Any) {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
