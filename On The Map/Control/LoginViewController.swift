//
//  LoginViewController.swift
//  On The Map
//
//  Created by Anna Solovyeva on 10/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var success: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBLoginButton()
        buttonStackView.addArrangedSubview(loginButton)
        loginButton.permissions = ["public_profile", "email"]
        if let token = AccessToken.current, !token.isExpired {
            let controller = storyboard?.instantiateViewController(withIdentifier:"tabBar")
            present(controller!, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        OnTheMapAPI.postSessionId(username: emailTextField.text!, password: passwordTextField.text!, completion: handleStudentLocationResponse(success:error:))
        OnTheMapAPI.getPublicUserData(completion: handleSessionIdResponse(success:error:))
        emailTextField.text = "Username"
        passwordTextField.text = "Password"
        if success {
            let controller = storyboard?.instantiateViewController(withIdentifier:"tabBar")
            present(controller!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Login is failed", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        (UIAlertAction) -> Void in
                    }
                    alert.addAction(alertAction)
                    present(alert, animated: true)
                    {
                        () -> Void in
                    }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    
    func handleSessionIdResponse(success: Bool, error: Error?) {
        if success {
            print("Session is successful")
            self.success = true
        } else {
            print("Error is found")
            self.success = false
        }
    }
    
    
    func handleStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            print("Everything is successful")
        } else {
            print("Error is found")
        }
    }
    

}

