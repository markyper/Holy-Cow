//
//  LoginViewController.swift
//  Holy-Cow
//
//  Created by Enrique Pajuelo on 7/19/16.
//  Copyright © 2016 Holy iOS Cows. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var connectLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //amount that screen moves with keyboard
    let movement: CGFloat = 150.0
    
    //makes the close button work
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //email and password verification
    @IBAction func signInButtonTapped(sender: UIButton) {

        let onCompletion = {(user: User?, message: String?) in
            print("inside login method")
            
            if user == nil {
                let errorAlert = UIAlertController(title: "Error", message: "not a user", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissErrorAlert = UIAlertAction(title: "Dismiss", style: .Default)  { (action: UIAlertAction) in }
                errorAlert.addAction(dismissErrorAlert)
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
            else {
                let viewController = UIStoryboard(name: "Calendar", bundle: nil).instantiateInitialViewController()
                let window = UIApplication.sharedApplication().keyWindow
                window?.rootViewController = viewController
                
                //dismissing keyboard - returning veiw to normal bounds
                self.dismissKeyboard()
                self.textFieldDidEndEditing(self.passwordField)
                self.textFieldDidEndEditing(self.emailField)
            }
        }
        
        UserController.sharedInstance.login(emailField.text!, password: passwordField.text!, onCompletion: onCompletion)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting text field delegates
        passwordField.delegate = self
        emailField.delegate = self
        
        orLabel.layer.bounds = CGRectMake(0, 0, 70, 70)
        orLabel.layer.masksToBounds = true
        orLabel.layer.cornerRadius = 25
        orLabel.layer.borderColor = UIColor.whiteColor().CGColor
        orLabel.layer.borderWidth = 2
        
        closeButton.layer.bounds = CGRectMake(0, 0, 50, 50)
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 15
        closeButton.layer.borderColor = UIColor.whiteColor().CGColor
        closeButton.layer.borderWidth = 2
        
        signInButton.layer.cornerRadius = 3
        
        //fb button
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("user is already logged in")
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
        
        //keyboard removal by touching on screen
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(recognizer)

    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.bounds = CGRectOffset(self.view.bounds, 0, self.movement)
        })
    }

    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.bounds = CGRectOffset(self.view.bounds, 0, -self.movement)
        })
    }

    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("fb authentication canceled")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                print("fb email accessed")
            }
            
            if result.grantedPermissions.contains("public_profile") {
                print("fb public profile accessed")
            }
            
            if result.grantedPermissions.contains("user_friends") {
                print("fb user friends accessed")
            }
            
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") && result.grantedPermissions.contains("user_friends") {
                
                print("all fb user info accessed")
            }
            
            self.returnUserData()
            let viewController = UIStoryboard(name: "Calendar", bundle: nil).instantiateInitialViewController()
            let window = UIApplication.sharedApplication().keyWindow
            window?.rootViewController = viewController
        }

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    //self.returnUserData()    ^to call
    
}
