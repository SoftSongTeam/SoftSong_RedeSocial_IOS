//
//  CommentsCell.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 10/08/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {
    @IBOutlet weak var ImagePerfil: UIImageView!
    @IBOutlet weak var Comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImagePerfil.contentMode = UIView.ContentMode.scaleAspectFit
        ImagePerfil.layer.borderWidth = 1
        ImagePerfil.layer.masksToBounds = false
        ImagePerfil.layer.borderColor = UIColor.black.cgColor
        ImagePerfil.layer.cornerRadius = 20
        ImagePerfil.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
