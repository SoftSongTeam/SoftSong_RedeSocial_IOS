//
//  CadastroController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 15/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit


class CadastroController: UIViewController {
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtNome: UITextField!
    
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
