//
//  ViewController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 11/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

//import Alamofire

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class ViewController: UIViewController {
    @IBOutlet var Vieww: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    var path : UIBezierPath!
    let defaultValues = UserDefaults.standard
    var cm : String = ""
    var id : String = ""
    var mail : String = ""
    
    @IBOutlet weak var txtSenha: UITextField!
    @IBOutlet weak var txtLogin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let c1 = UIColor.init(netHex: 0x285FBA)
        let c2 = UIColor.init(netHex: 0x7535AD)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [c1.cgColor, c2.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.frame = self.btnLogin.bounds
        gradientLayer.cornerRadius = 10
        btnLogin.layer.addSublayer(gradientLayer)
        btnLogin.layer.cornerRadius = 15
        let myColor = UIColor.white
        txtLogin.layer.borderColor = myColor.cgColor
        txtLogin.layer.borderWidth = 2.0
        txtLogin.layer.cornerRadius = 15
        txtLogin.clipsToBounds = true
        txtSenha.layer.borderColor = myColor.cgColor
        txtSenha.layer.borderWidth = 2.0
        txtSenha.layer.cornerRadius = 15
        txtSenha.clipsToBounds = true
        
        
        make1()
        Linha1()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
        let defaults = UserDefaults.standard
        let u = defaults.string(forKey: "username")
        print(u)
        if(u != nil)
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeController
            self.present(home, animated:true, completion:nil)
        }
        }
    }
    
    @IBAction func Logar(_ sender: UIButton) {
        let login = txtLogin.text
        let senha = txtSenha.text
        
        let URL = "http://192.168.15.17/DBConnect.php?nome=\(login!)&senha=\(senha!)"
        
        let url = NSURL(string: URL)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "data") as Any)
                
                if let actorArray = jsonObj.value(forKey: "data") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "caminho_imagem") {
                                self.cm = (name as! String)
                            }
                            if let name = actorDict.value(forKey: "IDUsuario") {
                                self.id = (name as! String)
                            }
                            if let name = actorDict.value(forKey: "email") {
                                self.mail = (name as! String)
                            }
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    if(self.cm != "")
                    {
                        DispatchQueue.main.async {
                            self.SaveAll()
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                            let home = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeController
                            self.present(home, animated:true, completion:nil)}
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Tente Novamente", message: "Usuario ou senha incorretos", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
                            self.present(alert, animated: true, completion: nil)
                    }
                    }
                
                })
            }
        }).resume()
    }
    
    
    @IBAction func SaveAll() {
        let username:String = txtLogin.text!
        
        let defaults = UserDefaults.standard
        
        defaults.set(username, forKey: "username")
        defaults.set(self.cm, forKey: "caminho_imagem")
        defaults.set(self.id, forKey: "id")
        defaults.set(self.mail, forKey: "mail")
    }
    
    func Linha1()  {
        let layer = CAShapeLayer()
        layer.path  = path.cgPath
        layer.strokeEnd = 0
        layer.lineWidth = 2
        layer.strokeColor = UIColor.init(netHex: 0x9E81E6).cgColor
        layer.fillColor = UIColor.init(netHex: 0x0F1C31).cgColor
        view.layer.addSublayer(layer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 4  //Second
        animation.repeatCount = .infinity
        
        layer.add(animation, forKey: "line")
        
    }
    
    func make1()  {
        path = UIBezierPath()
        
        path.addLine(to: CGPoint(x:40, y:739))
        path.move(to:CGPoint(x: 0,y: 739))
        path.addCurve(to:CGPoint(x: 416, y: 739), controlPoint1: CGPoint(x: 136, y: 639), controlPoint2: CGPoint(x: 178, y: 839))
        
        //path.close()
    }


}
