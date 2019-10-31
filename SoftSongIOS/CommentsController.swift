//
//  CommentsController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 10/08/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class CommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Com.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as! CommentsCell
        cell.Comment.text = Com[indexPath.row]
        let u = "http://192.168.15.17/pictures/\(Pic[indexPath.row])"
        print(u)
        let url = URL(string: u)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.ImagePerfil.image = UIImage(data: data!)
            }
        }
        return(cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadComments()
        let c1 = UIColor.init(netHex: 0x285FBA)
        let c2 = UIColor.init(netHex: 0x7535AD)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.Gradient.bounds
        gradientLayer.colors = [c1.cgColor, c2.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        Gradient.layer.addSublayer(gradientLayer)
        Gradient.alpha = 0.5
        Holder?.backgroundColor = UIColor(white: 1, alpha: 0)
        self.Comment.layer.cornerRadius = 10
        self.Comment.clipsToBounds = true
        self.Comment.layer.borderWidth = 1
        self.Comment.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    var Pic = [String]()
    var Com = [String]()
    
    func LoadComments()
    {
        let url = NSURL(string: "http://\(ViewController.IP)/getComments.php?id=\(HomeTableViewCell.idp)")
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "data") as Any)
                
                if let actorArray = jsonObj.value(forKey: "data") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "caminho_imagem") {
                                self.Pic.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "comentario") {
                                self.Com.append(name as! String)
                            }
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    self.List.reloadData()
                })
            }
        }).resume()
        
    }
    
    
    
    @IBOutlet weak var Gradient: UIView!
    @IBOutlet weak var Holder: UIView!
    @IBOutlet weak var List: UITableView!
    @IBOutlet weak var Comment: UITextField!
    
    
    @IBAction func AddComment(_ sender: Any) {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")!
        let url = NSURL(string: "http://\(ViewController.IP)/addComment.php?id=\(userLogged)&post=\(HomeTableViewCell.idp)&comment=\(Comment.text!)")
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "data") as Any)
                
                if let actorArray = jsonObj.value(forKey: "data") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    self.List.reloadData()
                })
            }
        }).resume()
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
