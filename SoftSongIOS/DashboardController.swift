//
//  DashboardController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 15/06/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

class DashboardController: UIViewController {

    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var TransparentView: UIView!
    @IBOutlet weak var Bloco1: UIView!
    @IBOutlet weak var Bloco2: UIView!
    @IBOutlet weak var Bloco3: UIView!
    @IBOutlet weak var Bloco4: UIView!
    @IBOutlet weak var Mail: UILabel!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var imgPerfil: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let c1 = UIColor.init(netHex: 0x285FBA)
        let c2 = UIColor.init(netHex: 0x7535AD)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [c1.cgColor, c2.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.frame = self.GradientView.bounds
        self.GradientView.layer.addSublayer(gradientLayer)
        GradientView.alpha = 0.5
        TransparentView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        Bloco1.layer.cornerRadius = 10
        Bloco1.elevate(elevation: 3)
        Bloco2.layer.cornerRadius = 10
        Bloco2.elevate(elevation: 3)
        Bloco3.layer.cornerRadius = 10
        Bloco3.elevate(elevation: 3)
        Bloco4.layer.cornerRadius = 10
        Bloco4.elevate(elevation: 3)
        
        imgPerfil.layer.cornerRadius = 27.5
        imgPerfil.clipsToBounds = true
        let defaults = UserDefaults.standard
        let cm = defaults.string(forKey: "caminho_imagem")
        let user = defaults.string(forKey: "username")
        let em = defaults.string(forKey: "mail")
        Username.text = user
        Mail.text = em
        let u = "http://192.168.15.17/pictures/\(cm!)"
        print(u)
        let url = URL(string: u)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imgPerfil.image = UIImage(data: data!)
            }
        // Do any additional setup after loading the view.
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
    
    @IBAction func Logout(_ sender: Any) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Voce tem certeza?", message: "Voce tem certeza que quer sair?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Nao", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { action in
                
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                self.restartApplication()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func restartApplication () {
        OperationQueue.main.addOperation({
            
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let home = storyBoard.instantiateViewController(withIdentifier: "Main") as! ViewController
                    self.present(home, animated:true, completion:nil)}
        })
        
    }
}
