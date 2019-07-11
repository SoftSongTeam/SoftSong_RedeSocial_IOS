//
//  SearchController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 05/07/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(self.Username.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "follows", for: indexPath) as! FollowsCell
        cell.lblUsername?.setTitle("@\((Username[indexPath.row]))", for: UIControl.State.normal)
        //cell.lblNome?.text = Nome[indexPath.row]
        let u = "http://192.168.15.17/pictures/\(Caminho_Imagem[indexPath.row])"
        print(u)
        let url = URL(string: u)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.imgPerfil.image = UIImage(data: data!)
            }
        }
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PublicPerfilController.user = Username[indexPath.row]
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "publicperfil") as! PublicPerfilController
            self.present(home, animated:true, completion:nil)}
    }
    
    @IBOutlet weak var txtSearch: UITextField!
    var Caminho_Imagem = [String]()
    var Nome = [String]()
    var Username = [String]()
    static var SearchUser : String = ""
    @IBOutlet weak var Table: UITableView!
    @IBOutlet var Vieww: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.layer.borderColor = UIColor.black.cgColor
        self.txtSearch.layer.borderWidth = 1.0
        self.txtSearch.layer.cornerRadius = 15
        self.txtSearch.clipsToBounds = true
        self.Table.delegate = self
        self.Table.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func SerachFunc(_ sender: Any) {
        self.DownloadJSON()
    }
    
    func DownloadJSON()
    {
        self.Caminho_Imagem.removeAll()
        self.Username.removeAll()
        self.Nome.removeAll()
        let url = ( "http://192.168.15.17/Search.php?user=\(txtSearch.text!)")
        print(url)
        let requestURL = NSURL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        URLSession.shared.dataTask(with: (requestURL as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "data") as Any)
                
                if let actorArray = jsonObj.value(forKey: "data") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "username") {
                                self.Username.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "nome") {
                                self.Nome.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "caminho_imagem") {
                                self.Caminho_Imagem.append(name as! String)
                            }
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    self.Table.reloadData()
                })
            }
        }).resume()
    }
}
