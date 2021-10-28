//
//  ViewController.swift
//  ProvaFinalSolutis
//
//  Created by Virtual Machine on 13/10/21.
//

import UIKit
import KeychainAccess
import Alamofire

class LoginViewController: UIViewController {
    
    var usuario: ModelUser?
    var homeScreen = HomeViewController()
    
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleTextTecnologia: UILabel!
    
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {//ao clicar no login verifique os parametros de Email e senha
       
        let LoginModel = ModelLogin(username: userTextField.text! , password: passwordTextField.text!)
        
        
        let alamofire = ApiRequest()
        if validarLogin(email: userTextField.text ?? "", password: passwordTextField.text ?? "") {
            alamofire.doLogin(login: LoginModel) { response in
                switch response {
                case.success(let responseUser):
                    DispatchQueue.main.async {
                        let keychain = Keychain(service: "com.Fabricio.ProvaFinalSolutis")
                        keychain["Login"] = LoginModel.username
                        self.usuario = responseUser
                        self.performSegue(withIdentifier: "IrParaExtrato", sender: self)
                    }
                    
                case .failure(_):
                    print("Erro ao fazer login")
                    let alert = UIAlertController(title: "Atenção", message: "Nome ou usuário incorretos", preferredStyle: .alert)
                    let acaoAvançar = UIAlertAction(title: "Ok", style: .default, handler: nil)

                    alert.addAction(acaoAvançar)
                    self.present(alert, animated: true, completion: nil)
            
                }
                
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        //funcao para aparecer titulo letra por letra
        titleTextTecnologia.text = ""
        var charIndex = 0.0
        let titleText = "Apaixonados por tecnologia"
        for letter in titleText{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false){ (Timer)in
                self.titleTextTecnologia.text?.append(letter)
            }
            charIndex += 1
        
        }
        let keychain = Keychain(service: "com.Fabricio.ProvaFinalSolutis")
        userTextField.text = keychain["Login"]
        print(keychain)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IrParaExtrato"){//nome da segue
            let destino = segue.destination as! HomeViewController
            destino.puxarDados = usuario
        }
    }
    
    func validarLogin(email: String, password: String) -> Bool {
   
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"//validacao de email
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        
        let passwordRegEx = "^(?=.*[a-z, 0-9])(?=.*[$@$#!%*?&]).{6,}$"//validacao de senha
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        
        if passwordPred.evaluate(with: password) && emailPred.evaluate(with: email) {
            print("Login feito com suscesso")
            return true
            
        }else{
            print("Erro ao fazer login")// alerta caso a senha ou usuaro estejam errados 
            let alert = UIAlertController(title: "Atenção!", message: "Usuario ou senha incorretos", preferredStyle: .alert)

                   let acaoAvançar = UIAlertAction(title: "Ok", style: .default, handler: nil)

                   alert.addAction(acaoAvançar)

                   self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    
    
    
}
   
