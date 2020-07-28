//
//  ViewController.swift
//  InstaClone
//
//  Created by Apple on 27.07.2020.
//  Copyright © 2020 erdogan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        // firebase kullanıcı girişi
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil )
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            //firebase kullanıcı oluşturma
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else{
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
}

