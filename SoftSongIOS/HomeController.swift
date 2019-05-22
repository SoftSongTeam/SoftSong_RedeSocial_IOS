//
//  HomeController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 15/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

extension UIView {
    func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(CGFloat(elevation))
        
        self.layer.shadowOpacity = 0.24
    }
}

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(self.IDPost.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! HomeTableViewCell
        cell.txtUsername?.text = (Username[indexPath.row])
        cell.txtLikes?.text = "\(Likou[indexPath.row]) likes"
        cell.txtPost?.text = ("\(Username[indexPath.row]): \(Legenda[indexPath.row])")
        cell.txtData?.text = (Data_Horario[indexPath.row])
        
        let url = URL(string: "http://192.168.15.17/pictures/9.jpg")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.PicPerfil.image = UIImage(data: data!)
            }
        }
        
        return(cell)
    }
    
    
    @IBOutlet weak var tblPosts: UITableView!
    var Curtidas = [String]()
    var Likou = [String]()
    var Username = [String]()
    var Caminho_imagem = [String]()
    var ID_Usuario = [String]()
    var IDPost = [String]()
    var Titulo = [String]()
    var Legenda = [String]()
    var Data_Horario = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadJSON()
    }
    
    
    
    func DownloadJSON()
    {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "username")
        let url = NSURL(string: "http://192.168.15.17/PostDeals.php?username=\(userLogged!)")
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "posts") as Any)
                
                if let actorArray = jsonObj.value(forKey: "posts") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "curtidas") {
                                self.Curtidas.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "likou") {
                                self.Likou.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "username") {
                                self.Username.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "caminho_imagem") {
                                self.Caminho_imagem.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "ID_Usuario") {
                                self.ID_Usuario.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "IDPost") {
                                self.IDPost.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "legenda") {
                                self.Legenda.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "data_horario") {
                                self.Data_Horario.append(name as! String)
                            }
                            
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    self.tblPosts.reloadData()
                })
            }
        }).resume()
    }
    

}
