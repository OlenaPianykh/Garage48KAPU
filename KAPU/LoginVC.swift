//
//  ViewController.swift
//  KAPU
//
//  Created by Vasyl Khmil on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging

class LoginVC: UIViewController {
    var databaseRef: FIRDatabaseReference!
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    var loader: KapuLoader?
    
    override func viewDidLoad() {
        self.databaseRef = FIRDatabase.database().reference()
        self.loader = KapuLoader()
    }
    
    @IBAction private func signUpPressed() {
        self.signUp()
    }
    
    private func signUp() {
        guard
            let email = self.emailField.text,
            let password = self.passwordField.text,
            let firstname = self.firstNameField.text else {
                
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) {
            (user, error) in
            
            guard let userId = user?.uid else {
                
                print("\(error)")
                return
            }
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = firstname
                changeRequest.commitChanges { error in
                    if error != nil {
                        print("An error occured.")
                    } else {
                        print("name saved")
                    }
                }
            }
            PushManager.shared.subscribeToAllFeeds()
            
            let usersTable = FIRDatabase.database().reference().child("users")
            usersTable.child(userId).setValue(["email" : email, "first_name" : firstname])
        }
    }
    
    @IBAction private func logInPressed() {
            self.login()
    }
    
    
    private func login() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
                print("user is signed in")
        } else {
            
        FIRAuth.auth()?.createUser(withEmail: "test1@test.com", password: "test123") { (user, error) in
            
            if error == nil {
                print("You have successfully logged in")
                
                PushManager.shared.subscribeToAllFeeds()
                
                FIRMessaging.messaging().subscribe(toTopic: "topics/app")
                
              /*  let kapu = Kapu(title: "Peace On Earth A Wonderful Wish But No Way?",
                                body: "The following article covers a topic that has recently moved to center stage–at least it seems that way. If you’ve been thinking you need to know more about unconditional love, here’s your",
                                categoryName: "Transportation",
                                creationDate: "05 Jan 2017, 10:30PM",
                                creatorName: "Annie Roger")
                if let loader = self.loader {
                    loader.addNew(kapu: kapu)
                }*/
                
            } else {
                
                PushManager.shared.subscribeToAllFeeds()
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        }
    
       
    }
}

