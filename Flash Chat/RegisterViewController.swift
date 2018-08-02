//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD


class RegisterViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate  {


    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate  = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            
            if let currentError = error {
                print(currentError)
            }else{
                //Success
                 print("registration worked")
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: AppSegues.goToChat.rawValue, sender: self)
            }
            
           
        }
        
    }
    
//    Google SignIn delegate implementation
    //    Google SingIn delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            
            print(error)
            return
        }
        
        let authentication = user.authentication
        
        let crendential = GoogleAuthProvider.credential(withIDToken: authentication!.idToken, accessToken: authentication!.accessToken)
        
        
        print(crendential)
        
        Auth.auth().signInAndRetrieveData(with: crendential) { (authResult, error) in
            if let error = error {
                print("Error in didSignIn - app delegate")
                print(error)
                return
            }
            
            
            print("Sign In google success")
             self.performSegue(withIdentifier: AppSegues.goToChat.rawValue, sender: self)
            
        }
    }
}
