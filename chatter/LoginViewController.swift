//
//  LoginViewController.swift
//  chatter
//
//  Created by William Falk-Wallace on 2/18/15.
//  Copyright (c) 2015 Falk-Wallace. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let username = split(email, {$0=="@"}, allowEmptySlices: false)[0]
        let password = passwordTextField.text
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                println("user: \(user)")
            } else {
                println("error: \(error)")
            }
        }
    }

    @IBAction func signUpButtonTapped(sender: AnyObject) {
        var user = PFUser()
        let email = emailTextField.text
        let username = split(email, {$0=="@"}, allowEmptySlices: false)[0]
        let password = passwordTextField.text

        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                println("SUCCESS")
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println(errorString)
            }
        }
    }

}
