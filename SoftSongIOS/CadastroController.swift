//
//  CadastroController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 15/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit


class CadastroController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var BtnCadastrar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUser.layer.borderWidth = 2.0
        txtUser.layer.cornerRadius = 15
        txtUser.clipsToBounds = true
        txtSenha.layer.borderWidth = 2.0
        txtSenha.layer.cornerRadius = 15
        txtSenha.clipsToBounds = true
        txtMail.layer.borderWidth = 2.0
        txtMail.layer.cornerRadius = 15
        txtMail.clipsToBounds = true
        txtNome.layer.borderWidth = 2.0
        txtNome.layer.cornerRadius = 15
        txtNome.clipsToBounds = true
        let c1 = UIColor.init(netHex: 0x285FBA)
        let c2 = UIColor.init(netHex: 0x7535AD)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [c1.cgColor, c2.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.frame = self.BtnCadastrar.bounds
        gradientLayer.cornerRadius = 10
        BtnCadastrar.layer.addSublayer(gradientLayer)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Select_Picture(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            Picture.image = image
        }
        else{}
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cadastrar(_ sender: UIButton) {
        let username = txtUser.text
        let senha = txtSenha.text
        let email = txtMail.text
        let nome = txtNome.text!
        let caminho = username! + ".jpg"
        if(username != "" && senha != "" && email != "" && nome != "")
        {
        let URL = "http://192.168.15.17/InserirCadastro.php?user=\(username!)&senha=\(senha!)&email=\(email!)&nome=\(nome)&caminho=\(caminho)"
        let requestURL = NSURL(string: URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            print(json!)
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            do {
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if(myJSON != nil)
                {
                    if let parseJSON = myJSON{
                        var msg : NSArray!
                        msg = parseJSON["result"] as? NSArray
                        if(msg != nil && msg.count > 0)
                        {
                            DispatchQueue.main.async {
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                let home = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeController
                                self.present(home, animated:true, completion:nil)}
                            self.myImageUploadRequest()
                            self.SaveAll()
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Tente Novamente :(", message: "Ocorreu um erro ao adicionar um novo usuario.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        }
        else
        {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Tente Novamente", message: "Preencha todos os campos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func SaveAll() {
        let username:String = txtUser.text!
        
        let defaults = UserDefaults.standard
        
        defaults.set(username, forKey: "username")
    }
    
    func myImageUploadRequest()
    {
        let myUrl = NSURL(string: "http://192.168.15.17/postPic.php");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        let param = [
            "firstName"  : "SoftSong",
            "lastName"    : "Uploads",
            "userId"    : "000"
        ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = Picture.image!.jpegData(compressionQuality: 0.7)
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
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


