//
//  UpdateController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 20/06/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class UpdateController: UIViewController {
    @IBOutlet weak var Holder: UIView!
    @IBOutlet weak var Invisible: UIView!
    @IBOutlet weak var elevate1: UILabel!
    @IBOutlet weak var elevate2: UILabel!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var txtSenha: UITextField!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var btnCadastrar: UIButton!
    var sucess : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Holder.layer.cornerRadius = 10
        Holder.elevate(elevation: 5)
        Invisible?.backgroundColor = UIColor(white: 1, alpha: 0)
        elevate1.elevate(elevation: 3)
        elevate2.elevate(elevation: 3)
        txtUser.layer.borderWidth = 1.0
        txtUser.layer.cornerRadius = 15
        txtUser.clipsToBounds = true
        txtSenha.layer.borderWidth = 1.0
        txtSenha.layer.cornerRadius = 15
        txtSenha.clipsToBounds = true
        txtMail.layer.borderWidth = 1.0
        txtMail.layer.cornerRadius = 15
        txtMail.clipsToBounds = true
        txtNome.layer.borderWidth = 1.0
        txtNome.layer.cornerRadius = 15
        txtNome.clipsToBounds = true
        let c1 = UIColor.init(netHex: 0x285FBA)
        let c2 = UIColor.init(netHex: 0x7535AD)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [c1.cgColor, c2.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.frame = self.btnCadastrar.bounds
        gradientLayer.cornerRadius = 10
        btnCadastrar.layer.addSublayer(gradientLayer)
        let defaults = UserDefaults.standard
        let pic = defaults.string(forKey: "caminho_imagem")
        let u = "http://\(ViewController.IP)/pictures/\(pic!)"
        print(u)
        let url = URL(string: u)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch}
            DispatchQueue.main.async {
                self.imgPerfil.image = UIImage(data: data!)
            }
        }
        self.Load()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Load_Picture(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgPerfil.image = image
        }
        else{}
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAtualizar(_ sender: Any) {
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        let caminho = txtUser.text! + ".jpg"
        let user = txtUser.text!
        let nome = txtNome.text!
        let mail = txtMail.text!
        let tel = "12345678"
        let senha = txtSenha.text!
        let desc = "teste"
        self.myImageUploadRequest()
        let url = ("http://\(ViewController.IP)/updateUser.php?id=\(userLogged!)&user=\(user)&nome=\(nome)&email=\(mail)&senha=\(senha)&telefone=\(tel)&caminho_imagem=\(caminho)&descricao=\(desc)")
        print(url)
        let requestURL = NSURL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        URLSession.shared.dataTask(with: (requestURL as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "info") as Any)
                
                if let actorArray = jsonObj.value(forKey: "info") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "sucess") {
                                self.sucess = name as! String
                            }
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    if(self.sucess == "1")
                    {
                        SuccessPopUp.instance.showAlert(title: "Perfeito", Message: "Alteracoes feitas com sucesso!", alertType: .success, View: self.Invisible)
                        let defaults = UserDefaults.standard
                        defaults.set(user, forKey: "username")
                        defaults.set(caminho, forKey: "caminho_imagem")
                        defaults.set(mail, forKey: "mail")
                    }
                    else
                    {
                        SuccessPopUp.instance.showAlert(title: "Ops!!", Message: "Algo deu errado :(", alertType: .failure, View: self.Invisible)
                    }
                })
            }
        }).resume()
    }
    
    func Load()
    {
            let defaults = UserDefaults.standard
            let userLogged = defaults.string(forKey: "id")
            let url = NSURL(string: "http://\(ViewController.IP)/loadInfo.php?id=\(userLogged!)")
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    print(jsonObj.value(forKey: "info") as Any)
                    
                    if let actorArray = jsonObj.value(forKey: "info") as? NSArray {
                        for actor in actorArray{
                            if let actorDict = actor as? NSDictionary {
                                if let name = actorDict.value(forKey: "username") {
                                    DispatchQueue.main.async {self.txtUser.text = name as? String}
                                }
                                if let name = actorDict.value(forKey: "email") {
                                    DispatchQueue.main.async {self.txtMail.text = name as? String}
                                }
                                if let name = actorDict.value(forKey: "senha") {
                                    DispatchQueue.main.async {self.txtSenha.text = name as? String}
                                }
                                if let name = actorDict.value(forKey: "nome") {
                                    DispatchQueue.main.async {self.txtNome.text = name as? String}
                                }
                                
                            }
                        }
                        //print(self.Username[2])
                    }
                    
                    OperationQueue.main.addOperation({
                    })
                }
            }).resume()
        }
    
    func myImageUploadRequest()
    {
        let myUrl = NSURL(string: "http://\(ViewController.IP)/postPic.php");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        let param = [
            "firstName"  : "SoftSong",
            "lastName"    : "Uploads",
            "userId"    : "000"
        ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = imgPerfil.image!.jpegData(compressionQuality: 0.7)
        if(imageData==nil)  { return; }
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            print("******* response = \(response)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                print(json)
            }catch
            {
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(txtUser.text!).jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

}
