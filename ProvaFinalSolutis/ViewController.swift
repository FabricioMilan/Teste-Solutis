//
//  ViewController.swift
//  ProvaFinalSolutis
//
//  Created by Virtual Machine on 13/10/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    
   // @IBOutlet weak var UserTextField: UITextField!
   // @IBOutlet weak var PasswordTextField: UITextField!
  
 
        super.viewDidLoad()
        
        let alamoFire = service (baseURL: "https://api.mobile.test.solutis.xyz")
        alamoFire.getLogin(endPoint: "login")
    }
    
 //   @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
       // _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    //}
    
    




}
