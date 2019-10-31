//
//  PerfilController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 09/06/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class PerfilController: UIViewController {
    
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
    var Posts = [String]()
    var Seguidores = [String]()
    var Seguindo = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DownloadJSON()
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
        let defaults = UserDefaults.standard
        let cm = defaults.string(forKey: "caminho_imagem")
        let u = "http://\(ViewController.IP)/pictures/\(cm!)"
        print(u)
        let url = URL(string: u)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imgPerfil.image = UIImage(data: data!)
            }
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    func DownloadJSON()
    {
        
        
        
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "username")
        let url = NSURL(string: "http://\(ViewController.IP)/InfoPerfil.php?nome=\(userLogged!)")
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "info") as Any)
                
                if let actorArray = jsonObj.value(forKey: "info") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "Posts") {
                                self.Posts.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "Seguindo") {
                                self.Seguindo.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "Seguidores") {
                                self.Seguidores.append(name as! String)
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
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "username")
        self.Username.text = userLogged
        self.nPost.setTitle(self.Posts[0], for: .normal)
        self.nSeguindo.setTitle(self.Seguindo[0], for: .normal)
        self.nSeguidores.setTitle(self.Seguidores[0], for: .normal)
    }
    
    @IBAction func FuncSeguidores(_ sender: Any) {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "username")
        FollowersController.TypeC = "seguidores"
        FollowersController.User = userLogged!
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "follows") as! FollowersController
            self.present(home, animated:true, completion:nil)}
    }
    
    @IBAction func FuncSeguidos(_ sender: Any) {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "username")
        FollowersController.TypeC = "seguidos"
        FollowersController.User = userLogged!
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "follows") as! FollowersController
            self.present(home, animated:true, completion:nil)}
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
