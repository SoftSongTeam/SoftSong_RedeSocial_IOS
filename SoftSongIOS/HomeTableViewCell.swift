//
//  HomeTableViewCell.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 21/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var PicPerfil: UIImageView!
    @IBOutlet weak var txtUsername: UILabel!
    @IBOutlet weak var BarraUP: UIView!
    @IBOutlet weak var BarraDOWN: UIView!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var txtLikes: UILabel!
    @IBOutlet weak var txtData: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        BarraUP.elevate(elevation: 0.5)
        BarraDOWN.elevate(elevation: 0.5)
        PicPerfil.contentMode = UIView.ContentMode.scaleAspectFit
        PicPerfil.layer.borderWidth = 1
        PicPerfil.layer.masksToBounds = false
        PicPerfil.layer.borderColor = UIColor.black.cgColor
        PicPerfil.layer.cornerRadius = 20
        PicPerfil.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
