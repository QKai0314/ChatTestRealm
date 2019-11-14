//
//  WelcomeViewController.swift
//  ChatTestRealm
//
//  Created by Kai Qiao on 11/14/19.
//  Copyright © 2019 iKai0314. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var username: String? {
        get {
            return usernameField.text
        }
    }

    var password: String? {
        get {
            return passwordField.text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc @IBAction func signIn(_ sender: Any) {
        
        logIn(username: username!, password: password!, register: false)
    }
    
    @objc @IBAction func signUp(_ sender: Any) {
        
        logIn(username: username!, password: password!, register: true)
    }
//    @objc func signIn() {
//    }
//
//    @objc func signUp() {
//    }

    // Log in with the username and password, optionally registering a user.
    func logIn(username: String, password: String, register: Bool) {
        print("Log in as user: \(username) with register: \(register)");
        setLoading(true);
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register);
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            self!.setLoading(false);
            if let error = err {
                // Auth error: user already exists? Try logging in as that user.
                print("Login failed: \(error)");
                return;
            }
            print("Login succeeded!");
            self?.performSegue(withIdentifier: "goItem", sender: self)
        });
    }
    
    // Turn on or off the activity indicator.
    func setLoading(_ loading: Bool) {
        if loading {
//            activityIndicator.startAnimating();
//            errorLabel.text = "";
        } else {
//            activityIndicator.stopAnimating();
        }
        usernameField.isEnabled = !loading
        passwordField.isEnabled = !loading
        signInButton.isEnabled = !loading
        signUpButton.isEnabled = !loading
    }
}

