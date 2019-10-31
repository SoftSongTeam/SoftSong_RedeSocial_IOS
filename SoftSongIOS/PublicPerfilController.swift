//
//  PublicPerfilController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 04/07/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class PublicPerfilController: UIViewController {
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var EffectView: UIView!
    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var Barra1: UIView!
    @IBOutlet weak var Barra2: UIView!
    @IBOutlet weak var Barra3: UIView!
    @IBOutlet weak var Barra4: UIView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var nPost: UIButton!
    @IBOutlet weak var nSeguidores: UIButton!
    @IBOutlet weak var nSeguindo: UIButton!
    @IBOutlet weak var btnSeguir: UIButton!
    @IBOutlet weak var btnBloquear: UIButton!
    var Posts = [String]()
    var Seguidores = [String]()
    var Seguindo = [String]()
    var Bloqueado = [String]()
    var Sigo = [String]()
    var Nome = [String]()
    var Caminho = [String]()
    static var user : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSeguir.titleLabel?.textColor = UIColor.init(netHex: 0x03ae7d)
        btnSeguir.layer.cornerRadius = 15
        btnSeguir.clipsToBounds = true
        btnBloquear.layer.borderWidth = 2
        btnBloquear.layer.borderColor = UIColor.init(netHex: 0xffffff).cgColor
        btnBloquear.layer.masksToBounds = false
        btnBloquear?.backgroundColor = UIColor(white: 1, alpha: 0)
        btnBloquear.layer.cornerRadius = 15
        
        
        Barra1.layer.cornerRadius = 5
        Barra2.layer.cornerRadius = 5
        Barra3.layer.cornerRadius = 5
        Barra4.layer.cornerRadius = 5
        Barra1.clipsToBounds = true
        Barra2.clipsToBounds = true
        Barra3.clipsToBounds = true
        Barra4.clipsToBounds = true
        
        let c1 = UIColor.init(netHex: 0x285FBA)
        let c2 = UIColor.init(netHex: 0x7535AD)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [c1.cgColor, c2.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.frame = self.GradientView.bounds
        GradientView.layer.addSublayer(gradientLayer)
        GradientView.alpha = 0.5
        EffectView?.backgroundColor = UIColor(white: 1, alpha: 0)
        self.DownloadJSON()
        // Do any additional setup after loading the view.
    }
    

    func DownloadJSON()
    {
        
        
        
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        let url = NSURL(string: "http://\(ViewController.IP)/PublicPerfil.php?id=\(userLogged!)&user=\(PublicPerfilController.user)")
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "data") as Any)
                
                if let actorArray = jsonObj.value(forKey: "data") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "Count(*)") {
                                self.Posts.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "seguindo") {
                                self.Seguindo.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "seguidores") {
                                self.Seguidores.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "sigo") {
                                self.Sigo.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "bloqueado") {
                                self.Bloqueado.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "nome") {
                                self.Nome.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "caminho_imagem") {
                                self.Caminho.append(name as! String)
                            }
                            
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    self.setText()
                })
            }
        }).resume()
    }
    
    func setText()
    {
        self.Username.text = Nome[0]
        self.nPost.setTitle(self.Posts[0], for: .normal)
        self.nSeguindo.setTitle(self.Seguindo[0], for: .normal)
        self.nSeguidores.setTitle(self.Seguidores[0], for: .normal)
        if(self.Sigo[0] != "0")
        {
            self.btnSeguir.setTitle("S E G U I N D O", for: UIControl.State.normal)
        }
        if(self.Bloqueado[0] != "0")
        {
            self.btnBloquear.setTitle("B L O Q U E A D O", for: UIControl.State.normal)
        }
        let u = "http://192.168.15.17/pictures/\(Caminho[0])"
        print(u)
        let url = URL(string: u)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imgPerfil.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func btnPosts(_ sender: Any) {
        FollowersPostController.user = PublicPerfilController.user
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "specpost") as! FollowersPostController
            self.present(home, animated:true, completion:nil)}
    }
    
    @IBAction func btnSeguidores(_ sender: Any) {
        FollowersController.TypeC = "seguidores"
        FollowersController.User = PublicPerfilController.user
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "follows") as! FollowersController
            self.present(home, animated:true, completion:nil)}
    }
    
    @IBAction func btnSeguindo(_ sender: Any) {
        FollowersController.TypeC = "seguidos"
        FollowersController.User = PublicPerfilController.user
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "follows") as! FollowersController
            self.present(home, animated:true, completion:nil)}
    }
    
    @IBAction func btnBloquear(_ sender: Any) {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        if(btnBloquear.titleLabel?.text == "B L O Q U E A R")
        {
            let url = "http://\(ViewController.IP)/blockProcedure.php?user=\(PublicPerfilController.user)&id=\(userLogged!)"
            self.Interacoes(url: url)
        }
        else
        {
            let url = "http://\(ViewController.IP)/Interacoes.php?type=desbloquear&user=\(PublicPerfilController.user)&id=\(userLogged!)"
            self.Interacoes(url: url)
        }
    }
    
    @IBAction func btnSeguir(_ sender: Any) {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        if(btnSeguir.titleLabel?.text == "S E G U I R")
        {
            let url = "http://\(ViewController.IP)/Interacoes.php?type=follow&user=\(PublicPerfilController.user)&id=\(userLogged!)"
            self.Interacoes(url: url)
        }
        else
        {
            let url = "http://\(ViewController.IP)/Interacoes.php?type=unfollow&user=\(PublicPerfilController.user)&id=\(userLogged!)"
            self.Interacoes(url: url)
        }
    }
    
    func Interacoes(url:String)
    {
        var ok:String = ""
        let urll = NSURL(string:url)
        URLSession.shared.dataTask(with: (urll as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "data") as Any)
                
                if let actorArray = jsonObj.value(forKey: "data") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "ok") {
                                ok = name as! String
                            }
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    if(ok == "ok")
                    {
                        self.DownloadJSON()
                    }
                })
            }
        }).resume()
    }
}
