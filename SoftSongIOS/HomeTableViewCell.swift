//
//  HomeTableViewCell.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 21/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var Slider: UIWebView!
    @IBOutlet weak var PicPerfil: UIImageView!
    @IBOutlet weak var txtUsername: UILabel!
    @IBOutlet weak var BarraUP: UIView!
    @IBOutlet weak var BarraDOWN: UIView!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var txtLikes: UILabel!
    @IBOutlet weak var txtData: UILabel!
    var likes : String = ""
    var postID = ""
    var liked = false
    var controller : String = ""
    static var idp : String = ""
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
    
    @IBAction func Curtir(_ sender: Any) {
        if(self.liked == true)
        {
            self.btnLike.setImage(UIImage(named: "icons8-copas-100"), for: UIControl.State.normal)
        }
        else
        {
            self.btnLike.setImage(UIImage(named: "icons8-copas-100-2"), for: UIControl.State.normal)
        }
        self.LikeDeslike()
    }
    
    
    
    @IBAction func Comentar(_ sender: Any) {
        HomeTableViewCell.idp = self.postID
        HomeController.Comentar()
    }
    
    
    
    func LikeDeslike()
    {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        let url = NSURL(string: "http://\(ViewController.IP)/LikeDeslike.php?id=\(userLogged!)&post=\(postID)")
        let request = URLRequest(url:url! as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest ) {(data, response, error) in
            guard let data = data else { return }
            self.likes = String(data: data, encoding: .utf8)!
            print(self.likes)
            self.setLikes()
        }
        
        task.resume()
    }
    
    func setLikes()
    {
        DispatchQueue.main.async {
            self.txtLikes.text = (Int(self.likes) == 1 ? "\(self.likes) like" : "\(self.likes) likes")
        }
    }
    
}
